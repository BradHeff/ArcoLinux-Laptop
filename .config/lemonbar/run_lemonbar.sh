#!/usr/bin/env bash

. $(dirname $0)/config

[ -e "${PANEL_FIFO}" ] && rm "${PANEL_FIFO}"
mkfifo "${PANEL_FIFO}"

conky -c $(dirname $0)/lemonbar_conky > "${PANEL_FIFO}" &

xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/WIN\1/p' > "${PANEL_FIFO}" &

cnt=0

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

        #echo "MUSIC %{F${color_sec_b2} T3}${sep_left}%{B${color_sec_b2}}%{F${color_sec_b1} T3}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_music}%{F- T1} ${str}"
        echo "MUSIC %{F${color_sec_b1} T3}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_music}%{F- T1} ${str}"
        sleep ${MUSIC_SLEEP}
    done
}

music > "${PANEL_FIFO}" &

get_updates(){
    while true; do
        #if (( ${cnt} == 300 )); then
        #    sudo pacman -Syy            
        #    cnt=0
        #else
        #    cnt=$((cnt + 1))
        #fi
        
        P_updates=`checkupdates | wc -l`
#        Y_updates=`yay -Qu | wc -l`
        
        P_updates=${P_updates%% }
#        Y_updates=${Y_updates%% }
        P_updates=${P_updates## }
#        Y_updates=${Y_updates## }

        if (( "${P_updates}" > 4 )); then
            echo "UPDATE %{F${color_pacman} B${color_sec_b2} T3}${sep_left}%{F${color_back} B${color_pacman} T2} ${icon_pacman} %{T1}${P_updates} %{F${color_sec_b2} B${color_pacman} T3}${sep_left}%{F- B${color_sec_b2} T1}"
        else
 #           if (( "${Y_updates}" > 0 )); then
 #               echo "UPDATE %{F${color_yay} B${color_sec_b2} T3}${sep_left}%{F${color_back} B${color_yay} T2} ${icon_update} %{T1}${Y_updates} %{F${color_sec_b2} B${color_yay} T3}${sep_left}%{F- B${color_sec_b2} T1}"
 #           else
           echo "UPDATE %{F${color_icon} B${color_sec_b2} T2} ${icon_update} %{F- T1}0 %{F- B${color_sec_b2} T1}"
#            fi
        fi
        sleep ${UPDATE_SLEEP}
    done
}

get_updates > "${PANEL_FIFO}" &

work(){
    while true; do
        local ws=$(xprop -root _NET_CURRENT_DESKTOP | sed -e 's/_NET_CURRENT_DESKTOP(CARDINAL) = //' )
        local seq="%{F${color_back} B${color_sec_b1} T1} "
        local total=${DESKTOP_COUNT}
        
        for ((i=0;i<total;i++)); do
            if [[ "$i" -eq "$ws" ]]; then            
                seq="${seq}%{F${color_sec_b1} B${color_head} T3}${sep_right}%{F${color_back} B${color_head} T1}  %{F${color_head} B${color_sec_b1} T3}${sep_right}"
            else            
                seq="${seq}%{F- T1} • "
            fi
        done
        echo "WORKSPACES ${seq}%{F${color_sec_b1} B${color_sec_b2} T3}${sep_right}%{F- B- T1}"
        sleep ${WORKSPACE_SLEEP}
    done
}

work > "${PANEL_FIFO}" &

get_vpn(){
    while true; do
        if [ -d "/proc/sys/net/ipv4/conf/tun0" ]; then
            vpn="%{F${color_head} T3}${sep_left}%{F${color_back} B${color_head}} %{T2}${icon_vpn_on} %{T1}On %{F${color_sec_b2} B${color_head} T3}${sep_left}%{F- B${color_sec_b2} T1}"
        elif [ -d "/proc/sys/net/ipv4/conf/ppp0" ]; then
            vpn="%{F${color_head} T3}${sep_left}%{F${color_back} B${color_head}} %{T2}${icon_vpn_on} %{T1}On %{F${color_sec_b2} B${color_head} T3}${sep_left}%{F- B${color_sec_b2} T1}"
        else
            vpn="%{F${color_sec_b2} T3}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_vpn_off}%{F- T1} Off "
        fi  
        echo "VPN ${vpn}"

        sleep ${VPN_SLEEP}
    done
}

get_vpn > "${PANEL_FIFO}" &

clock() 
{
    while true; do        
        local time="$(date +'%_I:%M%P')"
        # time
        echo "CLOCK %{F${color_head} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_head}} %{T2}${icon_clock} %{T1}${time} %{F${color_sec_b1} B${color_head} T3}${sep_left}%{F- T1}"
        sleep ${TIME_SLEEP}
    done
}

clock > "${PANEL_FIFO}" &

datez() 
{
    while true; do
        local dates="$(date +'%a %d %b')"        
        echo "DATE %{F${color_sec_b1} B${color_sec_b1} T3}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_date} %{F- T1}${dates}"
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
            echo "VOLUME %{F${color_yay} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_yay}} %{T2}${icon_vol_mute} %{T1}MUTE %{F${color_sec_b1} B${color_yay} T3}${sep_left}%{F- B- T1} "
        elif (( vol == 0 )); then
            echo "VOLUME %{F${color_yay} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_yay}} %{T2}${icon_vol_mute} %{T1}${vol}% %{F${color_sec_b1} B${color_yay} T3}${sep_left}%{F- B- T1} "
        elif (( vol > 70 )); then
            echo "VOLUME %{F${color_vol_alert} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_vol_alert}} %{T2}${icon_vol} %{T1}${vol}% %{F${color_sec_b1} B${color_vol_alert} T3}${sep_left}%{F- B- T1} "
        elif (( vol > 55 )); then
            echo "VOLUME %{F${color_vol_warn} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_vol_warn}} %{T2}${icon_vol} %{T1}${vol}% %{F${color_sec_b1} B${color_vol_warn} T3}${sep_left}%{F- B- T1} "
        elif (( vol > 10 )); then
            echo "VOLUME %{F${color_vol_good} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_vol_good}} %{T2}${icon_vol} %{T1}${vol}% %{F${color_sec_b1} B${color_vol_good} T3}${sep_left}%{F- B- T1} "
        else
            echo "VOLUME %{F${color_sec_b2} B${color_sec_b1} T3}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_vol}%{F- T1} ${vol}% %{F${color_sec_b1} B${color_sec_b2} T1}${sep_left}%{F- B- T1} "
        fi

        sleep ${VOLUME_SLEEP} 
    done
}

volume > "${PANEL_FIFO}" &

weather(){
    while true; do
        temp=$(perl $HOME/.config/lemonbar/weather.pl)
        
        #temp="${temp}%{F${color_sec_b2} B${color_sec_b2} T3}${sep_left}%{F- B${color_sec_b2} T1}"
        
        echo "WEATHER ${temp}"

        sleep ${WEATHER_SLEEP}
    done

}

weather > "${PANEL_FIFO}" &

battery() {
    while true; do
        local cap=$(cat /sys/class/power_supply/BAT1/capacity)
        local stat=$(cat /sys/class/power_supply/BAT1/status)

        if [[ "${cap}" -ge "${BATTERY_FULL}" || "${stat}" == "Charging" || "${stat}" == "Unknown" ]]; then
            echo "BATTERY %{F${color_bat_charge} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_bat_charge}} %{T2}${icon_bat_full} %{T1}${cap}% %{F- B-}"
        elif [[ "${cap}" -le "100" ]]; then
            echo "BATTERY %{F${color_bat_good} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_bat_good}} %{T2}${icon_bat_full} %{T1}${cap}% %{F- B-}"
        elif [[ "${cap}" -le "70" ]]; then
            echo "BATTERY %{F${color_bat_warn} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_bat_warn}} %{T2}${icon_bat_half} %{T1}${cap}% %{F- B-}"
        elif [[ "${cap}" -le "45" ]]; then
            echo "BATTERY %{F${color_bat_alert} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_bat_alert}} %{T2}${icon_bat_halfflat} %{T1}${cap}% %{F- B-}"
        else
            echo "BATTERY %{F${color_bat_alert} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_bat_alert}} %{T2}${icon_bat_flat} %{T1}${cap}% %{F- B-}"
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
            echo "CON %{F${color_yay} T3}${sep_left}%{F${color_back} B${color_yay}} %{T2}${icon_wifi} %{T1}X %{F${color_sec_b1} B${color_yay} T3}${sep_left}%{F- B- T1}"
        else
            echo "CON %{F${color_head2} T3}${sep_left}%{F${color_back} B${color_head2}} %{T2}${icon_wifi}%{F${color_sec_b1} B${color_head2} T3} ${sep_left}%{F- B- T1}"
        fi
        sleep ${WIFI_SLEEP}
    done

    
}

connection > "${PANEL_FIFO}" &

get_insync(){
    while true; do
        command=$(insync get_status)

        if [[ "${command}" == "SYNCED" ]]; then
            status="%{F${color_head} T3}${sep_left}%{F${color_back} B${color_head}} %{T2}${icon_synced} %{F- T1}%{F${color_sec_b1} B${color_head} T3}${sep_left}%{F- B- T1}"
        elif [[ "${command}" == "SYNCING" ]]; then
            status="%{F${color_sunset} T3}${sep_left}%{F${color_back} B${color_sunset}} %{T2}${icon_syncing} %{F- T1}%{F${color_sec_b1} B${color_sunset} T3}${sep_left}%{F- B- T1}"
        elif [[ "${command}" == "SHARE" ]]; then
            status="%{F${color_sunset} T3}${sep_left}%{F${color_back} B${color_sunset}} %{T2}${icon_share} %{F- T1}%{F${color_sec_b1} B${color_sunset} T3}${sep_left}%{F- B- T1}"
        else
            status="%{F${color_vol_alert} T3}${sep_left}%{F${color_back} B${color_vol_alert}} %{T2}${icon_sync_error} %{F- T1}%{F${color_sec_b1} B${color_vol_alert} T3}${sep_left}%{F- B- T1}"
        fi

        echo "SYNC ${status}"

        sleep ${SYNC_SLEEP}
    done
}

#get_insync > "${PANEL_FIFO}" &

get_ip() {
    state=$(python $HOME/.config/lemonbar/fetch_vpn.py status)
    ip=$(python $HOME/.config/lemonbar/fetch_vpn.py ip)
    while true; do
        local vpn=$(python $HOME/.config/lemonbar/fetch_vpn.py status)
        if [[ "${vpn}" -ne "${state}" ]]; then
            state="${vpn}"
            ip=$(python $HOME/.config/lemonbar/fetch_vpn.py ip)
        fi
        echo "IP %{F${color_sec_b2} T3}${sep_left}%{F${color_icon} B${color_sec_b2} T2}  %{F- T1}${ip}%{F${color_sec_b2} B${color_sec_b2} T3}${sep_left}%{F- B${color_sec_b2} T1}"

        sleep ${VPN_SLEEP}
    done
}

#get_ip > "${PANEL_FIFO}" &


get_bright() {
    while true; do
        command=$(xbacklight -get)

        status="%{F${color_sec_b1} T3}${sep_left}%{F${color_icon} B${color_sec_b1} T2} ${icon_bright} %{F- T1}${command%.*}% %{F- B- T1}"
        

        echo "BRIGHT ${status}"

        sleep ${VOLUME_SLEEP}
    done

}

get_bright > "${PANEL_FIFO}" &


while read -r line; do
    case $line in
        IP*)
            fn_ip="${line#IP }"
            ;; 
        BRIGHT*)
            fn_bright="${line#BRIGHT }"
            ;; 
        SYNC*)
            fn_sync="${line#SYNC }"
            ;;
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
        MUSIC*)
            fn_music="${line#MUSIC }"
            ;;
        UPDATE*)
            fn_update="${line#UPDATE }"
            ;;
        VPN*)
            fn_vpn="${line#VPN }"
            ;;
        WEATHER*)
            fn_weather="${line#WEATHER }"
            ;;
        CON*)
            fn_con="${line#CON }"
            ;;
        MEM*)
            fn_mem="%{F${color_icon} B${color_sec_b2} T2} ${icon_mem}%{F- T1} ${line#MEM } "
            ;;
        CPU*)
            fn_cpu="%{F${color_icon} B${color_sec_b2} T2} ${icon_cpu}%{F- T1} ${line#CPU } "
            ;;
        FREE*)
            fn_space="%{F${color_icon} B${color_sec_b2} T2} ${icon_space}%{F- T1} ${line#FREE } "
            ;;
        WIN*)            
            num_title=$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2 | wc -c)

            if (( num_title > 30 )); then
                name="$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2 | head -1 | head -c 30)..."
            else
                name="$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)"
            fi
            title="%{F${color_sec_b2} B${color_sec_b2} T3}${sep_right}%{F- B${color_sec_b2} T1} ${name} %{F${color_sec_b2} B- T3}${sep_right}%{F- B- T1} "
            ;;
    esac
    
    printf "%s\n" "%{l}${fn_work}${title} %{r}${fn_music}${stab}${fn_vpn}${fn_space}${fn_mem}${fn_cpu}${fn_update}${fn_weather}${fn_bright}${fn_vol}${fn_con}${fn_date}${stab}${fn_time}${fn_bat}"

done < "${PANEL_FIFO}" | lemonbar -f "${FONTS}" -f "${ICONFONTS}" -f "${FONTS_P}" -g "${GEOMETRY}" -B "${BBG}" -F "${BFG}" -o "${VOFF}" | sh > /dev/null