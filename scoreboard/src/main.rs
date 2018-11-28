extern crate actix_web;
extern crate listenfd;
extern crate scoreboard;

use actix_web::server;
use listenfd::ListenFd;
use std::env;
use scoreboard::scores;

fn main() {
    let mut listenfd = ListenFd::from_env();
    let mut server = server::new(|| {
        vec![
            scores::app(),
        ]
    });

    server = if let Some(l) = listenfd.take_tcp_listener(0).unwrap() {
        server.listen(l)
    } else {
        let port = env::var("PORT").unwrap();
        server.bind(format!("127.0.0.1:{}", port)).unwrap()
    };

    server.run();
}
