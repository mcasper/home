FROM ruby:2.7.2-alpine

RUN \
  apk add --update --no-cache --virtual .build-deps \
  build-base \
  git \
  nodejs \
  postgresql-dev

ENV APP_HOME /scoreboard
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV RAILS_ENV production

ADD Gemfile* $APP_HOME/

RUN \
  bundle check --path=vendor/bundle || \
  bundle install --path=vendor/bundle --jobs=4 --retry=3 --without development test

ADD .ruby-version  $APP_HOME/
ADD Rakefile       $APP_HOME/
ADD config.ru      $APP_HOME/
ADD bin            $APP_HOME/bin
ADD config         $APP_HOME/config
ADD db             $APP_HOME/db
ADD lib            $APP_HOME/lib
ADD public         $APP_HOME/public
ADD app            $APP_HOME/app
