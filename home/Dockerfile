FROM node as builder

RUN npm install create-elm-app

ADD elm.json elm.json
ADD src/ src/
ADD public/ public/

ENV ELM_APP_MODE=localCluster
ENV PUBLIC_URL=/
RUN /node_modules/create-elm-app/bin/elm-app-cli.js build

FROM nginx

COPY --from=builder build/ /usr/share/nginx/html
RUN echo "OK" > /usr/share/nginx/html/health
