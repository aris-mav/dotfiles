function backup

    argparse 'p/from-phone' 'P/to-phone' 'u/usb' -- $argv


    if set -ql _flag_usb

        set SANDISKDIR "/media/arismav/ARISSANDISK/"

        if test -d $SANDISKDIR         

            echo "syncing reads with usb drive"
            rsync -au --no-times ~/Documents/reads/ "$SANDISKDIR/reads/"
            echo "syncing music with usb drive"
            rsync -au --no-times ~/Music/ "$SANDISKDIR/Music/"
        else
            echo "sandisk usb drive not connected"
        end
    end


    if not set -q TERMUX_PHONE_IP
        while true 
            if not read_confirm "Setup phone IP?"
                break
            else
                echo "What is the phone's IP?"
                echo "(run `ifconfig` and look for wlan)"
                read -l -P  "Enter IP : " IP
                if read_confirm "Is $IP the correct one? "
                    set -Ux TERMUX_PHONE_IP $IP
                    echo "Saved $IP in the TERMUX_PHONE_IP universal variable"
                    break
                end
            end
        end

        if read_confirm "Setup ssh key?"
            echo "make sure phone has sshd and passwd enabled"
            ssh-keygen -t rsa -b 2048 -f id_rsa
            ssh-copy-id -p 8022 -i id_rsa $TERMUX_PHONE_IP
        end
    end

    # Phone sync 
    if set -ql _flag_p && read_confirm "Sync phone to PC?"

        echo "Type sshd on phone terminal to enable ssh connection"

            echo "Syncing phone to PC"

            # move recent camera files to the other DCIM folder, to have everything in one place
            ssh -p '8022' $TERMUX_PHONE_IP 'mv /storage/emulated/0/DCIM/Camera/  /storage/emulated/0/Pictures/DCIM/Camera/'

            for folder in Pictures Documents Music Zotero
                rsync -auv -e 'ssh -p 8022' $TERMUX_PHONE_IP:/storage/emulated/0/$folder/ $HOME/$folder/
            end



    end

    if set -ql _flag_P && read_confirm "Sync PC to phone?"
        echo "Syncing PC to phone"

        for folder in Pictures Documents Music Zotero
            rsync -auv -e 'ssh -p 8022' $HOME/$folder/ $TERMUX_PHONE_IP:/storage/emulated/0/$folder/
        end
    end

end
