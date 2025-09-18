# Use an official Python runtime as a parent image
FROM python:3.11-slim-buster

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . /app

# Collect static files and apply database migrations
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

# Run the application
CMD sh -c "gunicorn core.wsgi:application --bind 0.0.0.0:$PORT --workers 4"
