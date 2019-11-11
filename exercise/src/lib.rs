#![cfg_attr(feature="clippy", feature(plugin))]
#![cfg_attr(feature="clippy", plugin(clippy))]

#![deny(warnings)]
#![allow(unknown_lints)]

#[macro_use] extern crate tera;

use tera::Tera;

pub fn terra() -> Tera {
    compile_templates!("templates/**/*")
}

pub mod actions;
pub mod health;
