#!/usr/bin/env python

import os
import re
import requests
import xml.etree.ElementTree as ET

title = "Weather"
color_normal = "argb:0023262f, argb:F2a3be8c, argb:0023262f, argb:F2a3be8c, argb:F223262f"
color_window = "argb:D923262f, argb:F2ffffff, argb:F2ffffff"
options = "-width -35 -bw 1 -dmenu -i -p \'" + title + "\' -lines 3 -color-window \'" + color_window + "\' -color-normal \'" + color_normal + "\' -font \'Inconsolata 12\'"

code = "42930"
country = "AU"
city = "Balaklava"
lang = "EN"

metric = "1"

array = ''.join(["http://rss.accuweather.com/rss/liveweather_rss.asp?metric=", metric, "&locCode=", lang, "|", country, "|", code, "|", city])


class weather(object):

    def __init__(self, arg):
        super(weather, self).__init__()
        resp = requests.get(arg)
        
        if resp.ok:
            self.xml = resp.text
            if self.check_xml(self.xml):
                e = ET.fromstring(self.xml)
                self.trim_result(e)
            else:
                print("ERROR: Check your settings")
                exit(0)
        else:
            exit(0)

    def check_xml(self, xml):
        if "Currently" in xml:
            return 1
        else:
            return 0

    def trim_result(self, string):
        now = string[0][8][0].text
        today = string[0][9][3].text
        tomorrow = string[0][10][3].text

        nows = now.split(":")

        tomorrows = tomorrow.split(":")
        tomorrows_low = tomorrows[2].split(";")        

        temp_high = tomorrows[1].split(' ')
        temp_low = tomorrows_low[0].split(' ')
        cond = tomorrows_low[0].split("C ")

        todays = today.split(":")
        todays_low = todays[2].split(";")        

        todays_temp_high = todays[1].split(' ')
        todays_temp_low = todays_low[0].split(' ')
        todays_cond = todays_low[0].split("C ")
        
        menu = ''.join(["Now:        ", self.set_icon(nows[1]), nows[2], "\n", \
                        "Today:      ", self.set_icon(todays_cond[1].strip()), " ", todays_temp_low[1], "C / ", todays_temp_high[1], "C", "\n", \
                        "Tomorrow:   ", self.set_icon(cond[1].strip()), " ", temp_low[1], "C / ", temp_high[1], "C"])
        system = "echo \'" + menu + "\' | rofi " + options
        self.show_rofi(system)

    def set_icon(self, string):

        strs = ""

        if re.search("Sunny", string, re.IGNORECASE) or re.search("Intermittent", string, re.IGNORECASE) or re.search("Hot", string, re.IGNORECASE) or \
        re.search("Hazy", string, re.IGNORECASE):
            strs = ""
        elif re.search("Dreary (Overcast)", string, re.IGNORECASE) or re.search("Fog", string, re.IGNORECASE) or re.search("Cloudy", string, re.IGNORECASE):
            strs = ""
        elif re.search("Showers", string, re.IGNORECASE) or re.search("Rain", string, re.IGNORECASE) or \
        re.search("Flurries", string, re.IGNORECASE) or re.search("Snow", string, re.IGNORECASE) or re.search("Ice", string, re.IGNORECASE) or \
        re.search("Sleet", string, re.IGNORECASE) or re.search("Rain", string, re.IGNORECASE) or re.search("Cold", string, re.IGNORECASE):
            strs = ""
        elif re.search("T-Storms", string, re.IGNORECASE) or re.search("Thunderstorms", string, re.IGNORECASE):
            strs = ""
        elif re.search("Windy", string, re.IGNORECASE):
            strs = ""
        elif re.search("Clear", string, re.IGNORECASE) or re.search("Moonlight", string, re.IGNORECASE) or re.search("Intermittent", string, re.IGNORECASE):
            strs = ""
        else:
            strs = ""

        return strs

    def show_rofi(self, string):
        os.system(string)


if __name__ == '__main__':
    weather(array)
