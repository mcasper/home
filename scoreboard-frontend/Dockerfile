FROM node as builder

WORKDIR /app

RUN curl -o- -L https://yarnpkg.com/install.sh | bash

ADD elm.json /app/elm.json
ADD src/ /app/src/
ADD public/ /app/public/
ADD package.json /app/package.json
ADD yarn.lock /app/yarn.lock

RUN yarn
RUN yarn build

FROM nginx

RUN mkdir -p /usr/share/nginx/html/scoreboard/dist
COPY --from=builder /app/public/scoreboard/dist/elm.compiled.js /usr/share/nginx/html/scoreboard/dist/elm.compiled.js
COPY --from=builder /app/public/scoreboard/index.html /usr/share/nginx/html/scoreboard
COPY --from=builder /app/public/scoreboard/main.js /usr/share/nginx/html/scoreboard/main.js
COPY --from=builder /app/public/scoreboard/style.css /usr/share/nginx/html/scoreboard/style.css
RUN echo "OK" > /usr/share/nginx/html/health
