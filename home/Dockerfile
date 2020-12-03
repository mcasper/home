FROM node as builder

WORKDIR /app

RUN npm install create-elm-app

ADD elm.json /app/elm.json
ADD src/ /app/src/
ADD public/ /app/public/

ENV PUBLIC_URL=/
RUN /app/node_modules/create-elm-app/bin/elm-app-cli.js build

FROM nginx

COPY --from=builder /app/build/ /usr/share/nginx/html
RUN echo "OK" > /usr/share/nginx/html/health
