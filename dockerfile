# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory in the container to /app
WORKDIR /app

# Install system dependencies needed for pypdf and python-docx
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the working directory
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
# Gunicorn is a production-ready web server that Render recommends for Flask
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project to the working directory
COPY . .

# Expose port 8000, which Render uses for web services by default
EXPOSE 8000

# Run the application using Gunicorn
# 'app' is the name of your Python file (app.py)
# 'app' is the name of the Flask application instance inside app.py
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
