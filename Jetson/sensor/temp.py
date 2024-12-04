#Python Script for Reading DHT11 Data
import Adafruit_DHT

# Set your GPIO pin number here (according to your wiring)
DHT_PIN = 11  # Change this to the GPIO pin you connected the DHT11 DATA pin to

# Set the sensor type (DHT11 or DHT22)
DHT_TYPE = Adafruit_DHT.DHT11

def read_dht11_data():
    humidity, temperature = Adafruit_DHT.read_retry(DHT_TYPE, DHT_PIN)
    return humidity, temperature

if __name__ == '__main__':
    while True:
        humidity, temperature = read_dht11_data()
        if humidity is not None and temperature is not None:
            print(f'Temperature: {temperature:.2f} °C, Humidity: {humidity:.2f}%')
        else:
            print('Failed to retrieve data from the sensor.')