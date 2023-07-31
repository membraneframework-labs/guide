FROM elixir:alpine AS build 

RUN apk add git
RUN mkdir /app
WORKDIR /app
COPY docs_versions.sh . 
RUN chmod +x docs_versions.sh
RUN ./docs_versions.sh

FROM nginx:alpine
COPY --from=build /app/guide /usr/share/nginx/html/guide
COPY nginx-default.conf /etc/nginx/conf.d/default.conf
COPY landing/*  /usr/share/nginx/html/guide/
