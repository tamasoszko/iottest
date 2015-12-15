#!/usr/bin/python

import RPi.GPIO as GPIO
import time, _thread, traceback

def init():
  GPIO.setmode(GPIO.BCM)
  GPIO.setwarnings(False)
    


class Button:

  LOW = GPIO.PUD_UP
  HIGH = GPIO.PUD_DOWN


  def __init__(self, channel, mode, eventCallback=None):
    self.channel = channel
    self.mode = mode
    GPIO.setup(self.channel, GPIO.IN, mode)
    if eventCallback is not None:
      GPIO.add_event_detect(self.channel, GPIO.BOTH, self.gpioEventCallback)
      self.eventCallback = eventCallback

  def gpioEventCallback(self, channel):
    self.eventCallback(self)

  def up(self):
    if self.mode == Button.LOW:
      return GPIO.input(self.channel) == GPIO.HIGH
    else:
      return GPIO.input(self.channel) == GPIO.LOW

  def down(self):
    if self.mode == Button.LOW:
      return GPIO.input(self.channel) == GPIO.LOW
    else:
      return GPIO.input(self.channel) == GPIO.HIGH

  def wait(self):
    GPIO.wait_for_edge(self.channel, GPIO.BOTH)

  def test(self):
    if self.down():
      print('Button down')
    else:
      print('Button up')


class Led:

  def __init__(self, channel):
    self.channel = channel
    GPIO.setup(channel, GPIO.OUT)
    self.off()

  def on(self):
    GPIO.output(self.channel, 1)

  def off(self):
    GPIO.output(self.channel, 0)

  def doBlink(self, count, delay):
    while count > 0:
      self.on()
      time.sleep(delay)
      self.off()
      time.sleep(delay)
      count -= 1

  def blinkAsynch(self, count=5):
    try:
      _thread.start_new_thread(self.doBlink, (count, 0.1, ))
    except:
      traceback.print_exc()

  def blink(self, count=5):
    self.doBlink(count, 0.1)
    
