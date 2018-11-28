extern crate actix_web;
extern crate listenfd;

use actix_web::{server, App, HttpRequest};
use listenfd::ListenFd;
use std::env;

fn index(_req: &HttpRequest) -> &'static str {
    "Hello world!"
}

fn main() {
    let mut listenfd = ListenFd::from_env();
    let mut server = server::new(|| {
        App::new()
            .resource("/", |r| r.f(index))
    });

    server = if let Some(l) = listenfd.take_tcp_listener(0).unwrap() {
        server.listen(l)
    } else {
        let port = env::var("PORT").unwrap();
        server.bind(format!("127.0.0.1:{}", port)).unwrap()
    };

    server.run();
}
