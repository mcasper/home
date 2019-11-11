use actix_web::{HttpResponse, Responder};

#[allow(dead_code)]
pub fn health() -> impl Responder {
    HttpResponse::Ok()
}
