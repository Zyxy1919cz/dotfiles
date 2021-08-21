#!/usr/bin/sh

NOTIFY_ICON=/usr/share/icons/Adwaita/32x32/ui/radio-mixed-symbolic.symbolic.png

# get number of packages to update
get_updates() {
    PACUPDATES=$(checkupdates 2>/dev/null | wc -l)
    AURUPDATES=$(pacaur -Qu | wc -l)
}

send_notify() {
    # Uncomment if you don't want to use dunst as notification helper
    # notify-send -u $1 -i $NOTIFY_ICON "$2" "$3"
    dunstify -u $1 -i $NOTIFY_ICON "$2" "$3"
}

while true;
do
    get_updates
    UPDATES=$(($PACUPDATES + $AURUPDATES))

    # on startup send notification to user
    if hash notify-send &>/dev/null; then
        if (( $UPDATES > 50 )); then
            send_notify critical "You really need to update!!" "$UPDATES New packages"
        elif (( $UPDATES > 25 )); then
            send_notify normal "You should update soon" "$UPDATES New packages"
        elif (( $UPDATES > 0 )); then
            send_notify low "New update" "$UPDATES New Packages"
        fi
    fi

    # if there are updates available
    # test every 1 minute for another check
    while (( $UPDATES > 0 )); do
        echo "$PACUPDATES  $AURUPDATES"
        sleep 60
        get_updates
    done

    # if there aren't any updates
    # check for them after 1 hour to save CPU
    while (( $UPDATES == 0 )); do
        echo "$PACUPDATES  $AURUPDATES"
        sleep 3600
        get_updates
    done
done
