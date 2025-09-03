use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::Json,
    routing::{get, post},
    Router,
};
use serde::{Deserialize, Serialize};
use std::{collections::HashMap, sync::Arc};
use tokio::sync::RwLock;
use tower_http::cors::{Any, CorsLayer};
use tracing::{info, Level};
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize)]
struct AnalyticsEvent {
    id: Uuid,
    event_type: String,
    user_id: Option<String>,
    properties: HashMap<String, serde_json::Value>,
    timestamp: chrono::DateTime<chrono::Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct CreateEventRequest {
    event_type: String,
    user_id: Option<String>,
    properties: HashMap<String, serde_json::Value>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct EventStats {
    total_events: usize,
    events_by_type: HashMap<String, usize>,
    recent_events: Vec<AnalyticsEvent>,
}

type AppState = Arc<RwLock<Vec<AnalyticsEvent>>>;

#[tokio::main]
async fn main() {
    // Initialize tracing
    tracing_subscriber::fmt()
        .with_max_level(Level::INFO)
        .init();

    // Initialize in-memory storage (in production, use a database)
    let state: AppState = Arc::new(RwLock::new(Vec::new()));

    // Build our application with routes
    let app = Router::new()
        .route("/health", get(health_check))
        .route("/events", post(create_event))
        .route("/events", get(get_events))
        .route("/events/:id", get(get_event))
        .route("/stats", get(get_stats))
        .layer(
            CorsLayer::new()
                .allow_origin(Any)
                .allow_methods(Any)
                .allow_headers(Any),
        )
        .with_state(state);

    let port = std::env::var("PORT").unwrap_or_else(|_| "8081".to_string());
    let listener = tokio::net::TcpListener::bind(format!("0.0.0.0:{}", port))
        .await
        .unwrap();

    info!("Analytics service starting on port {}", port);
    axum::serve(listener, app).await.unwrap();
}

async fn health_check() -> Json<serde_json::Value> {
    Json(serde_json::json!({
        "status": "healthy",
        "service": "analytics-service"
    }))
}

async fn create_event(
    State(state): State<AppState>,
    Json(payload): Json<CreateEventRequest>,
) -> Result<Json<AnalyticsEvent>, StatusCode> {
    let event = AnalyticsEvent {
        id: Uuid::new_v4(),
        event_type: payload.event_type,
        user_id: payload.user_id,
        properties: payload.properties,
        timestamp: chrono::Utc::now(),
    };

    let mut events = state.write().await;
    events.push(event.clone());
    
    info!("Created analytics event: {:?}", event);
    Ok(Json(event))
}

async fn get_events(State(state): State<AppState>) -> Json<Vec<AnalyticsEvent>> {
    let events = state.read().await;
    Json(events.clone())
}

async fn get_event(
    State(state): State<AppState>,
    Path(id): Path<Uuid>,
) -> Result<Json<AnalyticsEvent>, StatusCode> {
    let events = state.read().await;
    
    if let Some(event) = events.iter().find(|e| e.id == id) {
        Ok(Json(event.clone()))
    } else {
        Err(StatusCode::NOT_FOUND)
    }
}

async fn get_stats(State(state): State<AppState>) -> Json<EventStats> {
    let events = state.read().await;
    
    let total_events = events.len();
    let mut events_by_type = HashMap::new();
    
    for event in events.iter() {
        *events_by_type.entry(event.event_type.clone()).or_insert(0) += 1;
    }
    
    let mut recent_events = events.clone();
    recent_events.sort_by(|a, b| b.timestamp.cmp(&a.timestamp));
    recent_events.truncate(10);
    
    Json(EventStats {
        total_events,
        events_by_type,
        recent_events,
    })
}