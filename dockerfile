FROM nginx:latest
RUN rm -rf /usr/share/nginx/html/*
COPY WebContent/ /usr/share/nginx/html/
EXPOSE 80
