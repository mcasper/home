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

FROM steebchen/nginx-spa:stable

COPY --from=builder /app/public/scoreboard/dist/elm.compiled.js /app/scoreboard/dist/elm.compiled.js
COPY --from=builder /app/public/scoreboard/index.html /app/
COPY --from=builder /app/public/scoreboard/main.js /app/scoreboard/main.js
COPY --from=builder /app/public/scoreboard/style.css /app/scoreboard/style.css

CMD ["nginx"]
