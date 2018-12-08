#!/usr/bin/env perl

use strict;
use warnings;
use XML::LibXML;
use Capture::Tiny qw(capture);
use utf8;

my $METRIC = 1;
my $COUNTRY = "Au";
my $CITY = "Balaklava";
my $LANG = "EN";
my $CODE = "41930";


my $title = $CITY . " " . $COUNTRY;
#my $color_normal = "argb:0023262f, argb:F2a3be8c, argb:0023262f, argb:F2a3be8c, argb:F223262f";
#my $color_window = "argb:D923262f, argb:F2ffffff, argb:F2ffffff";
my $options = "-width -30 -location 3 -bw 2 -dmenu -i -p \"$title\" -lines 3";

sub get_url {
	my $url = capture { system qq{curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=$METRIC&locCode=$LANG|$COUNTRY|$CODE|$CITY"} };
	return $url;
}	

sub get_icon {
	my $str;

	if( $_[0] =~ /Showers/i || $_[0] =~ /Rain/i || $_[0] =~ /Flurries/i || $_[0] =~ /Snow/i || $_[0] =~ /Ice/i || $_[0] =~ /Sleet/i || $_[0] =~ /Cold/i )
	{ $str= ""; }
	elsif( $_[0] =~ /T-Storms/i || $_[0] =~ /Thunderstorms/i )
	{ $str = ""; }
	elsif( $_[0] =~ /Sunny/i || $_[0] =~ /Intermittent/i || $_[0] =~ /Hazy/i || $_[0] =~ /Hot/i || $_[0] =~ /Clear/i || $_[0] =~ /Sunshine/i ) 
	{ $str = ""; }
	elsif( $_[0] =~ /Moonlight/i || $_[0] =~ /Intermittent/i )
	{ $str = ""; }
	elsif( $_[0] =~ /Cloudy/i || $_[0] =~ /Sun/i || $_[0] =~ /Clouds/i || $_[0] =~ /Dreary/i || $_[0] =~ /Fog/i )
	{ $str = ""; }
	elsif( $_[0] =~ /Windy/i )
	{ $str= ""; } 	
	else
	{ $str = ""; }

	return $str;
}

sub get_stat {
	my $str;

	if( $_[0] =~ /Showers/i || $_[0] =~ /Rain/i || $_[0] =~ /Flurries/i || $_[0] =~ /Snow/i || $_[0] =~ /Ice/i || $_[0] =~ /Sleet/i || $_[0] =~ /Cold/i )
	{ $str= 0; }
	elsif( $_[0] =~ /T-Storms/i || $_[0] =~ /Thunderstorms/i )
	{ $str = 1; }
	elsif( $_[0] =~ /Sunny/i || $_[0] =~ /Intermittent/i || $_[0] =~ /Hazy/i || $_[0] =~ /Hot/i || $_[0] =~ /Clear/i || $_[0] =~ /Sunshine/i ) 
	{ $str = 0; }
	elsif( $_[0] =~ /Moonlight/i || $_[0] =~ /Intermittent/i )
	{ $str = 0; }
	elsif( $_[0] =~ /Cloudy/i || $_[0] =~ /Sun/i || $_[0] =~ /Clouds/i || $_[0] =~ /Dreary/i || $_[0] =~ /Fog/i )
	{ $str = 0; }
	elsif( $_[0] =~ /Windy/i )
	{ $str= 0; } 	
	else
	{ $str = 1; }

	return $str;
}

sub get_weather {
	my $url = get_url;

	while(length $url lt 1){
		$url = get_url;
	}

	my $xml = XML::LibXML->load_xml(string=>$url);
	my $str1 = "";
	my $str2 = "";
	my $strn = "";
	my $strs = "";
	my @arr;
	my $count = 0;
	my @dec1;
	my @dec2;
	my @dot1;
	my @dot2;
	#print $strs;

	foreach my $title ($xml->findnodes('/rss/channel/item/title')) {
		if($title =~ /Currently/){

			push (@arr, split(/:/, $title->to_literal()));
			$arr[1] =~ s/^\s+//;
			$arr[2] =~ s/\s+//;
			
			$strn = get_icon($arr[1]);
			
			$strs = "Now:        " . $strn . " " . $arr[2] . "\n";
		}    	
	}
	
	foreach my $desc ($xml->findnodes('/rss/channel/item/description')) {
		if($desc =~ /High/){
			#High: 22 C Low: 9 C Partly sunny; delightful <img src="https://vortex.accuweather.com/phoenix2/images/common/icons/03_31x31.gif" >
			
			#High: 21 C Low: 12 C Mostly cloudy, spotty showers
			#High: 22 C Low: 9 C Partly sunny
			$desc =~ s/[;].*//;
			$desc =~ s/^[^>]*>//;
			$desc =~ s/\s&lt//;

			my $title = "";

			if($count == 0){
				$title = "Today:      ";
				push (@dot1, split(/C /, $desc));
				push (@dec1, split(/,/, $dot1[2]));				

				$dot1[0] =~ s/\s//g;
				$dot1[1] =~ s/\s//g;
	 			$dec1[0] =~ s/^\s//;
	 			
	 			$str1 = get_icon($dec1[0]);
	 			
	 			$dot1[0] =~ s/^[^:]*://;
	 			$dot1[1] =~ s/^[^:]*://;
	 			
	 			$strs .= $title . $str1 . " " . $dot1[1] . "C / " . $dot1[0] . "C\n";
			}
			else {
				$title = "Tomorrow:   ";
				push (@dot2, split(/C /, $desc));
				push (@dec2, split(/,/, $dot2[2]));				

				$dot2[0] =~ s/\s//g;
				$dot2[1] =~ s/\s//g;
	 			$dec2[0] =~ s/^\s//;
	 			
	 			$str2 = get_icon($dec2[0]);
	 			
	 			$dot2[0] =~ s/^[^:]*://;
	 			$dot2[1] =~ s/^[^:]*://;
	 			
	 			$strs .= $title . $str2 . " " . $dot2[1] . "C / " . $dot2[0] . "C\n";
			}
			$count++
		}
	}
	chomp $strs;

	my $var = capture { system qq{echo \"$strs\" | rofi $options}};
	chomp $var;

	my $icon = "-i messagebox_info";


	if($var =~ /Now/i) {
		if(get_stat($arr[1])){
			$icon = "-i messagebox_critical";
		}
		system qq{notify-send -u normal $icon "$strn $arr[1]" "$arr[2]"}
	}
	elsif($var =~ /Today/i) {
		if(get_stat($dec1[0])){
			$icon = "-i messagebox_critical";
		}
		system qq{notify-send -u normal $icon "$str1 $dec1[0]" "$dot1[1]C / $dot1[0]C"}
	}
	elsif($var =~ /Tomorrow/i) {
		if(get_stat($dec2[0])){
			$icon = "-i messagebox_critical";
		}
		system qq{notify-send -u normal $icon "$str2 $dec2[0]" "$dot2[1]C / $dot2[0]C"}
	}
}


get_weather;