#!/usr/bin/env python3

import os
import subprocess
import sys

class VPN(object):
	"""docstring for VPN"""
	def __init__(self):
		super(VPN, self).__init__()
		if len(sys.argv) == 2:
			if sys.argv[1] == "ip":
				if self.check_vpn():
					print(self.get_URL())
				else:
					print('Hidden')
			else:
				print(self.check_vpn())

	def check_vpn(self):
		if os.path.isdir("/proc/sys/net/ipv4/conf/tun0"):
			return 1
		
		if os.path.isdir("/proc/sys/net/ipv4/conf/ppp0"):
			return 1

		return 0

	def get_URL(self):
		p = subprocess.run(["curl", "-s", "https://api.ipify.org"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)		
		return p.stdout.decode()

if __name__ == '__main__':
	VPN()