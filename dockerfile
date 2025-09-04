# Use a standard Python image
FROM python:3.10

# Set the working directory in the container to /app
WORKDIR /app

# Copy the requirements file into the working directory
COPY requirements.txt .

# Install all Python packages from requirements.txt, including gunicorn
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project to the working directory
COPY . .

# Expose port 8000, which Render uses for web services by default
EXPOSE 8000

# Run the application using Gunicorn
# 'app' is the name of your Python file (app.py)
# 'app' is the name of the Flask application instance inside app.py
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]


