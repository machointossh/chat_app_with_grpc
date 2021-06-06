FROM node:latest AS builder

WORKDIR /app
COPY ./ ./
RUN yarn install
RUN yarn build

FROM nginx:latest
COPY --from=builder /app/build/ /var/www/
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
