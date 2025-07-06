import subprocess
import time
import json
import random
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s: %(message)s'
)

logger = logging.getLogger(__name__)

MQTT_BROKER = "mosquitto"
MQTT_TOPIC = "commands/vaper"

# Define value ranges
TEMP_MIN, TEMP_MAX = 20, 35
HUMI_MIN, HUMI_MAX = 30, 90
TVOC_MIN, TVOC_MAX = 0.0, 5.0
PM25_MIN, PM25_MAX = 0, 20
ALERT_VALUES = [0, 1]

def generate_random_data():
    return {
        "temperature": round(random.uniform(TEMP_MIN, TEMP_MAX), 1),
        "humidity": round(random.uniform(HUMI_MIN, HUMI_MAX), 1),
        "TVOC": round(random.uniform(TVOC_MIN, TVOC_MAX), 2),
        "PM2.5": random.randint(PM25_MIN, PM25_MAX),
        "alert": random.choice(ALERT_VALUES)
    }

print("🚀 Starting MQTT publisher...")

while True:
    try:
        payload = generate_random_data()
        message = json.dumps(payload)
        logger.info(f"📤 Publishing to {MQTT_TOPIC}")
        logger.info(f"📤 Published: {message}")
        subprocess.run([
            'mosquitto_pub',
            '-h', MQTT_BROKER,
            '-t', MQTT_TOPIC,
            '-m', message
        ], check=True)
    except subprocess.CalledProcessError as e:
        logger.error(f"❌ Failed to publish message: {e}")

    time.sleep(10)
