# Use the official NGINX image as the base image
FROM nginx:latest

# Set the working directory in the container
WORKDIR /usr/share/nginx/html/

# Copy all files and directories from the local repository to the working directory
COPY . .

# Expose port 80 to allow external access

EXPOSE 80
