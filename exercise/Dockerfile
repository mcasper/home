FROM rust:1.39.0-slim-stretch

ENV APP_HOME /exercise
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Cargo* $APP_HOME/
ADD src $APP_HOME/src

RUN cargo build --release
