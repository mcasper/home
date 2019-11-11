extern crate actix_web;
extern crate env_logger;
extern crate listenfd;
extern crate exercise;

use actix_web::{App, HttpServer, web};
use listenfd::ListenFd;
use std::env;
use exercise::{health};

fn main() {
    env::set_var("RUST_LOG", "actix_web=info");
    env_logger::init();

    let mut listenfd = ListenFd::from_env();
    let mut server = HttpServer::new(|| {
        App::new()
            .route("/health", web::get().to(health::health))
            .service(
                web::scope("/exercise")
                    .route("/health", web::get().to(health::health))
            )
    });

    server = if let Some(l) = listenfd.take_tcp_listener(0).unwrap() {
        server.listen(l).unwrap()
    } else {
        let port = env::var("PORT").unwrap();
        server.bind(format!("127.0.0.1:{}", port)).unwrap()
    };

    server.run().unwrap();
}
