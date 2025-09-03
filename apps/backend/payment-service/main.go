package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/stripe/stripe-go/v76"
	"github.com/stripe/stripe-go/v76/paymentintent"
)

type PaymentRequest struct {
	Amount      int64  `json:"amount"`
	Currency    string `json:"currency"`
	Description string `json:"description"`
}

type PaymentResponse struct {
	ClientSecret string `json:"client_secret"`
	ID           string `json:"id"`
}

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	// Initialize Stripe
	stripe.Key = os.Getenv("STRIPE_SECRET_KEY")

	// Initialize Gin router
	r := gin.Default()

	// CORS middleware
	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	})

	// Health check endpoint
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "healthy",
			"service": "payment-service",
		})
	})

	// Create payment intent
	r.POST("/payment/create", func(c *gin.Context) {
		var req PaymentRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		params := &stripe.PaymentIntentParams{
			Amount:   stripe.Int64(req.Amount),
			Currency: stripe.String(req.Currency),
		}

		if req.Description != "" {
			params.Description = stripe.String(req.Description)
		}

		pi, err := paymentintent.New(params)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		response := PaymentResponse{
			ClientSecret: pi.ClientSecret,
			ID:           pi.ID,
		}

		c.JSON(http.StatusOK, response)
	})

	// Get payment status
	r.GET("/payment/:id", func(c *gin.Context) {
		paymentID := c.Param("id")

		pi, err := paymentintent.Get(paymentID, nil)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Payment not found"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"id":     pi.ID,
			"status": pi.Status,
			"amount": pi.Amount,
		})
	})

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Payment service starting on port %s", port)
	log.Fatal(r.Run(":" + port))
}
