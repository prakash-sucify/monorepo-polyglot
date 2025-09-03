use axum::{
    extract::Query,
    http::StatusCode,
    response::Json,
    routing::get,
    Router,
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Serialize)]
struct HealthResponse {
    service: String,
    status: String,
    version: String,
}

#[derive(Deserialize)]
struct AnalyticsQuery {
    event: Option<String>,
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/", get(health_check))
        .route("/health", get(health_check))
        .route("/analytics", get(handle_analytics));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8081").await.unwrap();
    println!("Analytics service running on http://0.0.0.0:8081");
    
    axum::serve(listener, app).await.unwrap();
}

async fn health_check() -> Json<HealthResponse> {
    Json(HealthResponse {
        service: "analytics-service".to_string(),
        status: "healthy".to_string(),
        version: "1.0.0".to_string(),
    })
}

async fn handle_analytics(Query(params): Query<AnalyticsQuery>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let mut response = HashMap::new();
    response.insert("service".to_string(), "analytics-service".to_string());
    response.insert("status".to_string(), "received".to_string());
    
    if let Some(event) = params.event {
        response.insert("event".to_string(), event);
    }
    
    Ok(Json(response))
}