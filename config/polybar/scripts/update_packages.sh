#!/usr/bin/sh

NOTIFY_ICON=/usr/share/icons/Adwaita/32x32/ui/radio-mixed-symbolic.symbolic.png

# get number of packages to update
get_updates() {
    PACUPDATES=$(checkupdates 2>/dev/null | wc -l)
    AURUPDATES=$(pacaur -Qu | wc -l)
}

while true;
do
    get_updates
    UPDATES=$(($PACUPDATES + $AURUPDATES))

    # on startup send notification to user
    # FIXME: Use notify-send insted of dunstify becouse possible later swap of notifying services
    if hash notify-send &>/dev/null; then
        if (( $UPDATES > 50 )); then
            notify-send -u critical -i $NOTIFY_ICON "You really need to update!!" "$UPDATES New packages"
        elif (( $UPDATES > 25 )); then
            notify-send -u normal -i $NOTIFY_ICON "You should update soon" "$UPDATES New packages"
        elif (( $UPDATES > 0 )); then
            notify-send -u low -i $NOTIFY_ICON "New update" "$UPDATES New packages"
        fi
    fi

    # just for testing
    echo "$PACUPDATES  $AURUPDATES"

    # if there are updates available
    # test every 1 minute for another check
    # FIXME: For some reason nothing will outputs
    while (( $UPDATES > 0 )); do
        echo "$PACUPDATES  $AURUPDATES this is it"
        sleep 60
        get_updates
    done

    # if there aren't any updates
    # check for them after 1 hour to save CPU
    while (( $UPDATES == 0 )); do
        echo "$PACUPDATES  $AURUPDATES"
        sleep 3600
        get_updates
    done
done
