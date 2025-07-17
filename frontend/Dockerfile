FROM ghcr.io/cirruslabs/flutter:latest AS build

WORKDIR /app

COPY . .

RUN flutter pub get \
  && flutter build web --dart-define=ENV=production --release 

FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/build/web /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]