use actix_web::{App, HttpRequest};
use actix_web::middleware::Logger;

pub fn app() -> Vec<App> {
    vec![
        App::new()
            .middleware(Logger::default())
            .middleware(Logger::new("%a %{User-Agent}i"))
            .resource("/health", |r| r.f(health))
    ]
}

fn health(_req: &HttpRequest) -> &'static str {
    "Ok"
}
