# Step 1: Build the React App
FROM node:18 AS builder

# Set working directory inside container
WORKDIR /app

# Copy package files and install dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install --ignore-scripts

# Copy the entire project and build it
COPY . .
RUN npm run build

# Step 2: Serve the built app using Nginx
FROM nginx:alpine

# Copy built React files from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Remove default nginx config and add your own
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

# Expose port 80
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]

