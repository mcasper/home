use actix_web::{App, HttpRequest};

pub fn app() -> Vec<App> {
    vec![
        App::new()
            .resource("/", |r| r.f(index)),
        App::new()
            .prefix("/scores")
            .resource("/", |r| r.f(index)),
    ]
}

fn index(_req: &HttpRequest) -> &'static str {
    "Scores index"
}
