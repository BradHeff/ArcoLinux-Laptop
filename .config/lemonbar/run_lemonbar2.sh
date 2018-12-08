#!/usr/bin/env bash

. $(dirname $0)/config


[ -e "${PANEL_FIFO}" ] && rm "${PANEL_FIFO}"
mkfifo "${PANEL_FIFO}"

#conky -c $(dirname $0)/lemonbar_conky > "${PANEL_FIFO}" &

xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/WIN\1/p' > "${PANEL_FIFO}" &

perl "$HOME/.config/lemonbar/i3_workspaces.pl" > "${PANEL_FIFO}" &

space() {
    while true; do
        spce=$(df -h | grep '/sdb2' | awk '{print $4}')
        spce="${spce%?}"

        echo "SPACE %{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_space}%{F- T1} ${spce} GB"

        sleep ${SPACE_SLEEP}
    done
}
#space > "${PANEL_FIFO}" &

music() {
    while true; do
        NCMP=$(mpc | grep "^\[playing\]" | awk '{print $1}')
        NUM_NCMP=$(mpc | head -1 | wc -c )
        S_NCMP=$(mpc | head -1 | head -c 30)

        pause='Pause'
        str=""

        if [ "$NCMP" = "[playing]" ]; then        
            if [ "$NUM_NCMP" -lt 30 ]; then            
                str=$(mpc current)            
            else
                str="${S_NCMP}..."
            fi
        else
            str="${pause}"
        fi

        echo "MUSIC %{F${color_sec_b2}}${sep_left}%{B${color_sec_b2}}%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_music}%{F${color_fore} T1}  ${str}"

        sleep ${MUSIC_SLEEP}
    done
}
music > "${PANEL_FIFO}" &

cnt=0
get_updates(){
    while true; do
        if (( ${cnt} == 300 )); then
            sudo pacman -Syy            
            cnt=0
        else
            cnt=$((cnt + 1))
        fi
        
        P_updates=`pacman -Qu | wc -l`
        Y_updates=`yay -Qu | wc -l`
        

        if (( "${P_updates}" > 0 )); then
            echo "UPDATE %{F${color_pacman} B${color_sec_b2}}${sep_left}%{F${color_back} B${color_pacman} T2} ${icon_pacman} %{T1}${P_updates} %{F${color_sec_b2} B${color_pacman}}${sep_left}%{F- B${color_sec_b2} T1}"
        else
            if (( "${Y_updates}" > 0 )); then
                echo "UPDATE %{F${color_yay} B${color_sec_b2}}${sep_left}%{F${color_back} B${color_yay} T2} ${icon_update} %{T1}${Y_updates} %{F${color_sec_b2} B${color_yay}}${sep_left}%{F- B${color_sec_b2} T1}"
            else
                echo "UPDATE %{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2} T1} ${icon_update}%{F- T2} %{T1}${P_updates} %{F${color_sec_b2} B${color_sec_b2}}${sep_left}%{F- B${color_sec_b2} T1}"
            fi
        fi
        sleep ${UPDATE_SLEEP}
    done
}

get_updates > "${PANEL_FIFO}" &

get_vpn(){
    while true; do
        if [ -d "/proc/sys/net/ipv4/conf/tun0" ]; then
            vpn="${stab}%{F${color_head}}${sep_left}%{F${color_back} B${color_head}} %{T2}${icon_vpn_on} On %{F${color_sec_b2} B${color_head}}${sep_left}%{F- B${color_sec_b2}}"
        elif [ -d "/proc/sys/net/ipv4/conf/ppp0" ]; then
            vpn="${stab}%{F${color_head}}${sep_left}%{F${color_back} B${color_head}} %{T2}${icon_vpn_on} On %{F${color_sec_b2} B${color_head}}${sep_left}%{F- B${color_sec_b2}}"
        else
            vpn="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_vpn_off}%{F- B${color_sec_b2}} Off "
        fi  
        echo "VPN ${vpn}"

        sleep ${VPN_SLEEP}
    done
}

get_vpn > "${PANEL_FIFO}" &

work(){
    while true; do
        local ws=$(xprop -root _NET_CURRENT_DESKTOP | sed -e 's/_NET_CURRENT_DESKTOP(CARDINAL) = //' )
        local seq="%{F${color_back} B${color_wsp}} %{T2}%{T1}"
        local total=${DESKTOP_COUNT}
        
        for ((i=0;i<total;i++)); do
            if [[ "$i" -eq "$ws" ]]; then            
                seq="${seq}%{F${color_wsp} B${color_head}}${sep_right}%{F${color_back} B${color_head} T1}  %{F${color_head} B${color_wsp}}${sep_right}"
            else            
                seq="${seq}%{F${color_disable} T1} • "
            fi
        #case "$SPACE_NUM" in
         #   "0")
          #      WORKSPACE='  •  •  •  •';;
          #  "1")
          ##      WORKSPACE='•    •  •  •';; #WORKSPACE='◦ • ◦ ◦ ◦ ◦';;
           # "2")
           #     WORKSPACE='•  •    •  •';; #WORKSPACE='◦ ◦ • ◦ ◦ ◦';;
           # "3")
           #     WORKSPACE='•  •  •    •';; #WORKSPACE='◦ ◦ ◦ • ◦ ◦';;
           # "4")
           #     WORKSPACE='•  •  •  •  ';; #WORKSPACE='◦ ◦ ◦ ◦ • ◦';;            

        #esac
        done
        echo "WORKSPACES ${seq}%{F${color_wsp} B${color_sec_b2}}${sep_right}%{F- B- T1}"
        sleep ${WORKSPACE_SLEEP}
    done
}

#work > "${PANEL_FIFO}" &

clock() 
{
    while true; do        
        local time="$(date +'%I:%M%P')"
        # time
        echo "CLOCK %{F${color_head}}${sep_left}%{F${color_back} B${color_head}} ${time} %{F${color_back} B${color_head}}${sep_left}%{F- B-}"
        sleep ${TIME_SLEEP}
    done
}

clock > "${PANEL_FIFO}" &

datez() 
{
    while true; do
        local dates="$(date +'%a %d %b')"        
        echo "DATE %{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_clock}%{F- T1} ${dates}"
        sleep ${DATE_SLEEP}
    done
}

datez > "${PANEL_FIFO}" &


volume()
{
    cnt_vol=${upd_vol}

    while true; do
        local vol="$(amixer get Master | grep -E -o '[0-9]{1,3}?%' | head -1 | cut -d '%' -f1)"
        local mut="$(amixer get Master | grep -E -o 'off' | head -1)"

        if [[ ${mut} == "off" ]]; then
            echo "VOLUME %{F${color_yay}}${sep_left}%{F${color_back} B${color_yay}} %{T2}${icon_vol_mute} %{T1}MUTE %{F${color_sec_b1} B${color_yay}}${sep_left}%{F- B- T1} "
        elif (( vol == 0 )); then
            echo "VOLUME %{F${color_yay}}${sep_left}%{F${color_back} B${color_yay}} %{T2}${icon_vol_mute} %{T1}${vol}% %{F${color_sec_b1} B${color_yay}}${sep_left}%{F- B- T1} "
        elif (( vol > 70 )); then
            echo "VOLUME %{F${color_vol_alert}}${sep_left}%{F${color_back} B${color_vol_alert}} %{T2}${icon_vol} %{T1}${vol}% %{F${color_sec_b1} B${color_vol_alert}}${sep_left}%{F- B- T1} "
        elif (( vol > 55 )); then
            echo "VOLUME %{F${color_vol_warn}}${sep_left}%{F${color_back} B${color_vol_warn}} %{T2}${icon_vol} %{T1}${vol}% %{F${color_sec_b1} B${color_vol_warn}}${sep_left}%{F- B- T1} "
        elif (( vol > 10 )); then
            echo "VOLUME %{F${color_vol_good}}${sep_left}%{F${color_back} B${color_vol_good}} %{T2}${icon_vol} %{T1}${vol}% %{F${color_sec_b1} B${color_vol_good}}${sep_left}%{F- B- T1} "
        else
            echo "VOLUME %{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_vol}%{F- T1} ${vol}% %{F${color_sec_b1} B${color_sec_b2} T1}${sep_left}%{F- B- T1} "
        fi

        sleep ${VOLUME_SLEEP} 
    done
}

volume > "${PANEL_FIFO}" &

weather(){
    while true; do
        temp=$(perl $HOME/.config/lemonbar/weather.pl)
        
        temp="${temp}%{F${color_sec_b2} B${color_sec_b2}}${sep_left}%{F- B${color_sec_b2} T1}"
        
        echo "WEATHER ${temp}"

        sleep ${WEATHER_SLEEP}
    done

}

weather > "${PANEL_FIFO}" &

get_load(){
    while true; do
        load=$(uptime | awk '{print $(NF-2)}')
        load="${load//,}"

        if (( $(echo "$load < 2.8" | bc -l) ));
        then
            usage="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_load}%{F- T1} ${load} %{F${color_sec_b2} B${color_sec_b2}}${sep_left}"
        elif (( $(echo "$load < 4.8" | bc -l) ));
        then
            usage="%{F${color_head}}${sep_left}%{F${color_back} B${color_head}} %{T2}${icon_load} ${load} %{F${color_sec_b2} B${color_head}}${sep_left}"        
        else
            usage="%{F${color_pacman}}${sep_left}%{F${color_back} B${color_pacman}} %{T2}${icon_load} ${load} %{F${color_sec_b2} B${color_pacman}}${sep_left}"        
        fi
        echo "LOAD ${usage}%{F- B${color_sec_b2} T1}"

        sleep ${LOAD_SLEEP}
    done

}

#get_load > "${PANEL_FIFO}" &

battery() {
    while true; do
        local cap=$(cat /sys/class/power_supply/BAT1/capacity)
        local stat=$(cat /sys/class/power_supply/BAT1/status)

        if [[ "${cap}" -ge "${BATTERY_FULL}" || "${stat}" == "Charging" || "${stat}" == "Unknown" ]]; then
            echo "BATTERY %{F${color_bat_charge}}${sep_left}%{F${color_back} B${color_bat_charge}} %{T2}${icon_bat_full} ${cap}% %{F- B-}"
        elif [[ "${cap}" -le "${BATTERY_FULL}" && "${stat}" == "Discharging" ]]; then
            echo "BATTERY %{F${color_bat_good}}${sep_left}%{F${color_back} B${color_bat_good}} %{T2}${icon_bat_full} ${cap}% %{F- B-}"
        elif [[ "${cap}" -le "70" && "${stat}" == "Discharging" ]]; then
            echo "BATTERY %{F${color_bat_good}}${sep_left}%{F${color_back} B${color_bat_good}} %{T2}${icon_bat_halffull} ${cap}% %{F- B-}"
        elif [[ "${cap}" -le "48" && "${stat}" == "Discharging" ]]; then
            echo "BATTERY %{F${color_bat_warn}}${sep_left}%{F${color_back} B${color_bat_warn}} %{T2}${icon_bat_half} ${cap}% %{F- B-}"
        elif [[ "${cap}" -le "28" && "${stat}" == "Discharging" ]]; then
            echo "BATTERY %{F${color_bat_alert}}${sep_left}%{F${color_back} B${color_bat_alert}} %{T2}${icon_bat_halfflat} ${cap}% %{F- B-}"
        elif [[ "${cap}" -le "28" && "${stat}" == "Discharging" ]]; then
            echo "BATTERY %{F${color_bat_alert}}${sep_left}%{F${color_back} B${color_bat_alert}} %{T2}${icon_bat_flat} ${cap}% %{F- B-}"
        else
            echo "BATTERY %{F${color_bat_alert}}${sep_left}%{F${color_back} B${color_bat_alert}} %{T2}${icon_bat_flat} ${cap}% %{F- B-}"
        fi

        sleep ${BATTERY_SLEEP}
    done
}

battery > "${PANEL_FIFO}" &

connection(){
    while true; do
        wifi=$(nmcli -t -f device,state,connection device | grep connected)
        IFS=':'; wifi=($wifi); unset IFS;
        if [[ "${wifi[2]}" == "" ]]; then
            echo "CON %{F${color_yay}}${sep_left}%{F${color_back} B${color_yay}} %{T2}${icon_wifi} X %{F${color_sec_b1} B${color_yay}}${sep_left}%{F- B- T1}"
        else
            echo "CON %{F#FF47758a}${sep_left}%{F${color_back} B#FF47758a} %{T2}${icon_wifi}%{F${color_sec_b1} B#FF47758a} ${sep_left}%{F- B- T1}"
        fi
        sleep ${WIFI_SLEEP}
    done
}
connection > "${PANEL_FIFO}" &

while read -r line; do
    case $line in
        BATTERY*)
            fn_bat="${line#BATTERY }"
            ;;
        CLOCK*)
            fn_time="${line#CLOCK }"
            ;;
        DATE*)
            fn_date="${line#DATE }"
            ;;
        VOLUME*)
            fn_vol="${line#VOLUME }"
            ;;
        WORKSPACES*)
            fn_work="${line#WORKSPACES }"
            ;;
        WSP*)
            # I3 Workspaces
            wsp="%{F${color_back} B${color_wsp}} %{T1}" #%{F${color_back} B${color_head}} %{T2}${icon_wsp}%{T1}"
            set -- ${line#???}
            while [ $# -gt 0 ] ; do
                case $1 in
                FOC*)
                    wsp="${wsp}%{F${color_wsp} B${color_head}}${sep_right}%{F${color_back} B${color_head} T2} ${1#???} %{F${color_head} B${color_wsp}}${sep_right}"
                    #wsp="${wsp}%{F${color_head} B${color_wsp}}${sep_right}%{F${color_back} B${color_wsp} T1} ${1#???} %{F${color_wsp} B${color_head}}${sep_right}"
                    ;;
                INA*|URG*|ACT*)
                    wsp="${wsp}%{F${color_disable} T2} ${1#???} "
                    ;;
                esac
                shift
            done
            fn_work="${wsp}%{F${color_wsp} B${color_sec_b2}}${sep_right}%{F- B- T1}"
            ;;          
        MUSIC*)
            fn_music="${line#MUSIC }"
            ;;
        UPDATE*)
            fn_update="${line#UPDATE }"
            ;;
        VPN*)
            fn_vpn="${line#VPN }"
            ;;
        LOAD*)
            fn_load="${line#LOAD }"
            ;;
        WEATHER*)
            fn_weather="${line#WEATHER }"
            ;;
        CON*)
            fn_con="${line#CON }"
            ;;
        MEM*)
            fn_mem="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_mem}%{F- T1} ${line#MEM }"
            ;;
        CPU*)
            fn_cpu="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_cpu}%{F- T1} ${line#CPU }"
            ;;
        FREE*)
            fn_space="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_space}%{F- T1} ${line#FREE }"
            ;;
        WIN*)            
            num_title=$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2 | wc -c)

            if (( num_title > 30 )); then
                name="$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2 | head -1 | head -c 30)..."
            else
                name="$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)"
            fi
            title="%{F${color_sec_b2} B${color_sec_b2}}${sep_right}%{F- B${color_sec_b2} T1} ${name} %{F${color_sec_b2} B-}${sep_right}%{F- B- T1} "
            ;;
    esac
    #printf "%s\n" "%{l}${fn_work}${title} %{r}${fn_music}${stab}${fn_space}${fn_mem}${fn_cpu}${fn_vpn}${fn_weather}${fn_update}${fn_vol}${fn_con}${fn_date}${stab}${fn_time}${fn_bat}"
    printf "%s\n" "%{l}${fn_work}${title} %{r}${fn_music}${stab}${fn_vpn}${fn_weather}${fn_update}${fn_vol}${fn_con}${fn_date}${stab}${fn_time}${fn_bat}"
done < "${PANEL_FIFO}" | lemonbar -f "${FONTS}" -f "${ICONFONTS}" -g "${GEOMETRY}" -B "${BBG}" -F "${BFG}"