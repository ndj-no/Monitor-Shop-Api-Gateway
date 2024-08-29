# Bước 1: Xây dựng ứng dụng Angular
FROM node:16 AS build
ARG BUILD_MODE
WORKDIR /app
COPY . .
RUN npm install -f
RUN if [ -n "$BUILD_MODE" ]; then \
        npm run build -- --configuration ${BUILD_MODE}; \
    else \
        npm run build; \
    fi

# Bước 2: Chạy ứng dụng Angular với Nginx
FROM nginx:mainline-alpine3.18-slim AS final
COPY --from=build /app/dist/MonitorShop-Admin /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
