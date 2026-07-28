FROM nginx:alpine
LABEL maintainer="hyu"
COPY ./app /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
