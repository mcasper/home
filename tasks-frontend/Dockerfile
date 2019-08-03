FROM node as builder

ADD package.json package.json
ADD yarn.lock yarn.lock
ADD config/ config/
ADD scripts/ scripts/
ADD src/ src/
ADD public/ public/

ENV PUBLIC_URL=/tasks
RUN yarn install
RUN yarn run build

FROM nginx

COPY --from=builder build/ /usr/share/nginx/html/tasks
RUN echo "OK" > /usr/share/nginx/html/health
