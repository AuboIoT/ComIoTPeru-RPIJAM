FROM python:3.11-slim

# Install Mosquitto clients (contains mosquitto_pub)
RUN apt-get update && \
    apt-get install -y mosquitto-clients && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy Python script
COPY mqtt_publisher.py /mqtt_publisher.py

# Make it executable
RUN chmod +x /mqtt_publisher.py

# Run the script
CMD ["python3", "/mqtt_publisher.py"]
