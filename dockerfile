# Use a pre-built image from Hugging Face for transformers and PyTorch
FROM huggingface/transformers-pytorch-gpu:latest

# Set the working directory in the container to /app
WORKDIR /app

# Copy the requirements file into the working directory
COPY requirements.txt .

# Install all Python packages from requirements.txt, including gunicorn
# This will be much faster now as many dependencies are already present
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project to the working directory
COPY . .

# Expose port 8000, which Render uses for web services by default
EXPOSE 8000

# Run the application using Gunicorn
# 'app' is the name of your Python file (app.py)
# 'app' is the name of the Flask application instance inside app.py
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
