FROM bitwalker/alpine-elixir-phoenix:1.8.0

RUN apk add yarn
# RUN apt update -qq && \
#   apt install -y \
#   build-essential \
#   git \
#   libpq-dev \
#   nodejs

ENV APP_HOME /budget
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV MIX_ENV prod

ADD mix.exs  $APP_HOME/mix.exs
ADD mix.lock $APP_HOME/mix.lock
RUN mix do deps.get, deps.compile

ADD bin    $APP_HOME/bin
ADD assets $APP_HOME/assets
ADD config $APP_HOME/config
ADD priv   $APP_HOME/priv
ADD lib    $APP_HOME/lib

RUN cd assets && yarn install
RUN mix compile && mix phx.digest

CMD mix phx.server
