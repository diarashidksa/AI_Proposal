# Use the official Miniconda3 base image
FROM continuumio/miniconda3:latest

# Set the working directory in the container to /app
WORKDIR /app

# Copy the requirements file into the working directory
COPY requirements.txt .

# Install all necessary packages using Conda and Pip
# This ensures that complex dependencies like sentence-transformers are handled correctly
# gunicorn is installed via pip since it's a web server
RUN conda install --yes -c conda-forge \
    python-dotenv \
    openai \
    faiss-cpu \
    pypdf \
    python-docx \
    langchain \
    langchain-community \
    langchain-openai \
    numpy \
    langdetect && \
    pip install --no-cache-dir gunicorn sentence-transformers tiktoken

# Copy the entire project to the working directory
COPY . .

# Expose port 8000, which Render uses for web services by default
EXPOSE 8000

# Run the application using Gunicorn
# 'app' is the name of your Python file (app.py)
# 'app' is the name of the Flask application instance inside app.py
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]




