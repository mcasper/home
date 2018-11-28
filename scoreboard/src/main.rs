extern crate actix_web;
use actix_web::{server, App, HttpRequest};
use std::env;

fn index(_req: &HttpRequest) -> &'static str {
    "Hello world!"
}

fn main() {
    let port = env::var("PORT").unwrap();
    server::new(|| App::new().resource("/", |r| r.f(index)))
        .bind(format!("127.0.0.1:{}", port))
        .unwrap()
        .run();
}
