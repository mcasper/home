FROM bitwalker/alpine-elixir-phoenix:1.8.1

RUN apk add yarn

ENV APP_HOME /budget
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV MIX_ENV prod

ADD mix.exs  $APP_HOME/mix.exs
ADD mix.lock $APP_HOME/mix.lock
RUN mix do deps.get, deps.compile

ADD bin    $APP_HOME/bin
ADD config $APP_HOME/config
ADD priv   $APP_HOME/priv
ADD lib    $APP_HOME/lib

CMD mix phx.server
