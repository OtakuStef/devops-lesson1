# Use an official Node.js runtime as the base image
FROM node:18 as builder

# Set the working directory
WORKDIR /blog

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Create a smaller image with just the built application
FROM node:18

# Set the working directory for the final image
WORKDIR /blog

# Copy only the built application from the previous stage
COPY --from=builder /blog/.next ./.next
COPY --from=builder /blog/node_modules ./node_modules
COPY --from=builder /blog/package.json ./package.json

# Expose the port your application will run on
EXPOSE 3000

# Start the Next.js application
CMD ["npm", "start"]
