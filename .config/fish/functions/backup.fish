function backup

    # USB sync
    if test "$hostname" = "fwdb"

        set SANDISKDIR "/media/arismav/ARISSANDISK/"

        if test -d $SANDISKDIR         

            echo "syncing reads with usb drive"
            rsync -au --no-times ~/Documents/reads/ "$SANDISKDIR/reads/"
            echo "syncing music with usb drive"
            rsync -au --no-times ~/Music/ "$SANDISKDIR/Music/"
        else
            echo "sandisk usb drive not connected"
        end
    else

        echo "idk what to do in this machine"

    end

    # Phone sync 
    if not set -q TERMUX_PHONE_IP
        while true 
            echo "What is the phone's IP?"
            echo "(run `ifconfig` and look for wlan)"
            read -l -P  "Enter IP : " IP
            if read_confirm "Is $IP the correct one? "
                set -U TERMUX_PHONE_IP $IP
                echo "Saved $IP in the TERMUX_PHONE_IP universal variable"
                break
            else
                break
            end
        end
    end

    echo "Type sshd on phone terminal to enable ssh connection"

    if read_confirm "Sync phone to PC?"
        echo "Syncing phone to PC"

        # move recent camera files to the other DCIM folder, to have everything in one place
        ssh -p '8022' $TERMUX_PHONE_IP 'mv /storage/emulated/0/DCIM/Camera/  /storage/emulated/0/Pictures/DCIM/Camera/'

        for folder in Pictures Documents Music
            rsync -auv -e 'ssh -p 8022' $TERMUX_PHONE_IP:/storage/emulated/0/$folder/ $HOME/$folder/
        end

    end

    if read_confirm "Sync PC to phone?"
        echo "Syncing PC to phone"

        for folder in Pictures Documents Music
            rsync -auv -e 'ssh -p 8022' $HOME/$folder/ $TERMUX_PHONE_IP:/storage/emulated/0/$folder/
        end

    end

end
