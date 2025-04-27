# Use a multi-stage build to include the React app
# Stage 1: Build the React app
FROM node:22 AS react-build

# Set the working directory for the React app
WORKDIR /client-app

# Copy package.json and package-lock.json
COPY client-app/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the React app code
COPY client-app/ ./

# Build the React app
RUN npm run build

# Stage 2: Combine Go and React app
FROM golang:1.24

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the Go application code
COPY . .

# Copy the built React app from the previous stage
#COPY --from=react-build /client-app/dist ./client-app/build

# Build the Go Gin application
RUN go build -o main .

# Set environment variables
ENV PORT=8080
ENV GIN_MODE=release
ENV COSMOS_CONNECTION_STRING="<your-cosmos-connection-string>"
ENV COSMOS_DATABASE_NAME="<your-cosmos-database-name>"
ENV COSMOS_CONTAINER_NAME="<your-cosmos-container-name>"

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["./main"]