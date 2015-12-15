#!/usr/bin/python

import requests

class Parse():

	_URL = "https://api.parse.com/1/classes/"

	def __init__(self, apiKey, appId):
		self.apiKey = apiKey
		self.appId = appId

	def headers(self):
		return {'X-Parse-Application-Id': self.appId, 'X-Parse-REST-API-Key': self.apiKey}

	def query(self, obj):
		url = Parse._URL + obj
		headers = self.headers()
		r = requests.get(url, headers=headers)
		return r.json()

	def upload(self, obj, json):
		try:
			url = Parse._URL + obj
			headers = self.headers()
			r = requests.post(url, headers=headers, data=json)
			return r
		except:
			traceback.print_exc()
