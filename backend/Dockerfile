# Use the official lightweight Node.js 20 LTS image
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if available) first 
# This leverages Docker's cache layer for faster subsequent builds
COPY package*.json ./

# Install dependencies cleanly (including production and dev dependencies if needed)
RUN npm ci

# Copy the rest of your backend source code
COPY . .

# Expose the port your Express app listens on (usually 3000, 5000, or 8080)
EXPOSE 5000

# Run the application
CMD ["npm", "start"]