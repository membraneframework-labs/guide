FROM elixir:1.13 AS build 

COPY docs_versions.sh . 
RUN chmod +x docs_versions.sh
RUN ./docs_versions.sh 

FROM nginx:alpine
COPY nginx-default.conf /etc/nginx/conf.d/default.conf
COPY landing/*  /usr/share/nginx/html/guide/

COPY --from=build v0.3/doc /usr/share/nginx/html/guide/v0.3
COPY --from=build v0.4/doc /usr/share/nginx/html/guide/v0.4
COPY --from=build v0.5/doc /usr/share/nginx/html/guide/v0.5
COPY --from=build v0.6/doc /usr/share/nginx/html/guide/v0.6
COPY --from=build v0.7/doc /usr/share/nginx/html/guide/v0.7
