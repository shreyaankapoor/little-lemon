# Step 1: Build the React App
FROM node:18 AS builder

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./
RUN npm install --ignore-scripts

COPY . .
RUN npm run build

# Step 2: Serve the built app using Nginx
FROM nginx:alpine

# Copy built React files from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Remove default nginx config and add your own
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

# ✅ Add non-root user and fix permissions
RUN adduser -D appuser \
    && chown -R appuser:appuser /var/cache/nginx /var/run /var/log/nginx

USER appuser

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
