#!/usr/bin/env python

import os
import re
import subprocess

	
class wifi(object):

	def __init__(self):
		super(wifi, self).__init__()
		#print(self.get_device())
		#exit(0)
		try:
			result = subprocess.check_output(("nmcli", "-t", "-f", "in-use,ssid", "d", "wifi", "list"))
			res = result.decode().rstrip().split("\n")
			menu = ""
			for x in res:
				out = x.split(":")
				#print(out)
				if out[0] == "*":
					menu = menu + out[1] + " (*)\n"
				else:
					menu = menu + out[1] + "\n"
			menu = menu.rstrip()
			lines = len(menu.split("\n"))
			selection = self.show_menu("Wifi Menu", menu, lines)

			res = 0
			for x in menu.split("\n"):
				if "(*)" in x:
					res = 1

			if(res == 0 or "(*)" in selection):			
				self.connect(selection)
			elif(len(selection) > 1):
				self.show_notify("ERROR!", "You are already connected to wifi", "NO")

		except:
			exit(0)
            
	def get_device(self):
		items = subprocess.Popen(('nmcli', '-t', '-f', 'device,type', 'd'), stdout=subprocess.PIPE)
		output = subprocess.check_output(("grep", "wifi"), stdin=items.stdout).decode().strip()
		splt = output.split(":")[0]
		return splt

	def show_menu(self, TITLE, ITEMS, LINES):
		items = subprocess.Popen(('echo', ITEMS), stdout=subprocess.PIPE)
		output = subprocess.check_output(("rofi", "-width", "-30", "-location", "3", "-bw", "2", "-dmenu", "-i", "-p", TITLE, "-lines", str(LINES)), stdin=items.stdout)
		return output.decode().strip()
	
	def connect(self, SSID):
		if "(*)" in SSID:
			SSID = SSID.replace(" (*)", "")
			
			items = subprocess.Popen(('nmcli', '-t', '-f', 'name,device', 'c'), stdout=subprocess.PIPE)
			device = subprocess.check_output(('grep', self.get_device()), stdin=items.stdout)
			
			wifi = device.decode().strip().split(":")[0]
			
			device = subprocess.check_output(('nmcli', "c", "down", wifi))
			if "deactivated" in con.decode():
				self.show_notify(SSID, "Successfully deactivated", "OK")

		else:

			items = subprocess.Popen(('nmcli', '-t', '-f', 'name,device', 'c'), stdout=subprocess.PIPE)
			device = subprocess.check_output(('grep', SSID), stdin=items.stdout)
			wifi = device.decode().strip().split(":")[0]
			
			if(SSID in wifi or SSID == wifi):
				con = subprocess.check_output(("nmcli", "c", "up", wifi))
				self.show_notify(wifi, "Successfully activated""Successfully activated", "OK")

			else:
				output = subprocess.check_output(("rofi", "-width", "-30", "-location", "0", "-bw", "2", "-dmenu", "-i", "-p", "Wifi Password", "-lines", "1"))
				con = subprocess.check_output(("nmcli", "d", "wifi", "connect", SSID, "password", output.decode()))
				if("Successfully" in con.decode()):
					self.show_notify(result[0], "Successfully activated", "OK")
				else:
					self.show_notify(result[0], "FAILED " + con.decode(), "OK")


	def show_notify(self, selection, action, status):
		if(status == "OK"):
			ICON = "messagebox_info"
		else:
			ICON = "messagebox_critical"
		command = ' '.join(["notify-send", "-u", "normal", "-i", ICON, '"' + selection + '" ' + '"' + action + '"'])
		os.system(command.strip())


if __name__ == '__main__':
	wifi()