# Stage 1: Build Flutter Web
FROM debian:latest AS build-env

# Install system dependencies
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Clone the stable Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web build and build the project
WORKDIR /app
COPY . .
RUN flutter doctor
RUN flutter build web --release

# Stage 2: Serve static files using Nginx
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]