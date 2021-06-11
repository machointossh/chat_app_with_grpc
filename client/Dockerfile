FROM node:latest AS builder

ARG SERVER_HOSTNAME 

WORKDIR /app
COPY ./ ./
RUN yarn install
RUN REACT_APP_SERVER_HOSTNAME=${SERVER_HOSTNAME} yarn build

FROM nginx:latest
COPY --from=builder /app/build/ /var/www/
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
