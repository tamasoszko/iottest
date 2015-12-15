#!/usr/bin/python

import sys
import Adafruit_DHT
import BasicIO
from BasicIO import Led
from BasicIO import Button
import RPi.GPIO as GPIO
import time, threading
from parse import Parse


def notify(cond):
	cond.acquire()
	cond.notify()	
	cond.release()

def wait(cond):
	cond.acquire()
	cond.wait()
	cond.release()


def test():
	BasicIO.init()

	led = Led(4)

	exitCondition = threading.Condition()

	def buttonEvent(button):
		if button.down():
			led.on()
			notify(exitCondition)
		else:
			led.off()

	button = Button(14, Button.LOW, buttonEvent)

	# wait(cond)

	sensor = 22
	pin = 15

	# r = requests.get('https://google.com')
	# print(r.text.encode('utf-8'))

	# while True:
		# humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
		# print("temperature=%0.1f, humidity=%2.1f" % (temperature, humidity))
		# time.sleep(15)

	parse = Parse('BiPX6d3kDzfinO9Y8kHvNo1rnCPl8PoJW2zUXHYk', 'zNMGmfiYzq7W4eyD7mpSfixKIvxaZRPjCS38Qh6z')
	
	while True:
		humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
		print("temperature=%0.1f, humidity=%2.1f" % (temperature, humidity))
		resp = parse.upload('DHTMeter', '{"temperature":%2.1f,"humidity":%2.1f}' % (temperature, humidity))
		print("uploaded=%s" % resp)
		led.blink(3)
		# print(resp)
		time.sleep(60)

	led.blink()

test()
