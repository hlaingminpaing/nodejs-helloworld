# Base Node.js image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package.json .
RUN npm install

# Copy application code
COPY app/ ./app

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
