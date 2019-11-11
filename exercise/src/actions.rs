use actix_web::{HttpResponse, Responder};
use super::terra;

#[allow(dead_code)]
pub fn index() -> impl Responder {
    let context = tera::Context::new();
    let body = terra().render("actions/index.html", &context).unwrap();
    HttpResponse::Ok().body(body)
}
