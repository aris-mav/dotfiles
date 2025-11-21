function sc

    argparse 'p/phone' 'u/usb'  -- $argv

    if test (whoami) = "arismav"
        set syncfolders Documents Music Zotero Pictures
    else 
        set syncfolders Documents Music Zotero
    end

    if not set -q UNISON 
        echo "you might want to `set -Ux UNISON .config/unison`"
    end

    if set -ql _flag_usb

        if not set -q FLASH_DRIVE_DIR
            echo "Type:"  
            echo "set -Ux FLASH_DRIVE_DIR /path/to/usb/drive"
            echo "to save the usb path env variable."
        end

        if test -d $FLASH_DRIVE_DIR 
            if read_confirm "Sync with $FLASH_DRIVE_DIR ?"     
                for folder in $syncfolders
                    if type -q unison
                        unison -auto ~/$folder $FLASH_DRIVE_DIR/$folder
                    else if read_confirm "Use rsync?"
                        rsync -auv ~/$folder $FLASH_DRIVE_DIR/$folder
                    end
                end
                rsync -auv ~/Zotero/zotero.sqlite $FLASH_DRIVE_DIR/Zotero/zotero.sqlite
            end
        else
            echo "usb drive not connected"
        end
    end

    # Phone sync 
    if set -ql _flag_p

        if not set -q TERMUX_PHONE_IP
            echo "Run `ifconfig` on termux and look for wlan inet IP address."
            echo "Afterwards, type on the local terminal:"
            echo "`set -Ux TERMUX_PHONE_IP 'IP address'`"
            echo "to save the IP as environment variable, and generate rsa key by typing:"
            echo "`ssh-keygen -t rsa -b 2048 -f id_rsa`"
            echo "`ssh-copy-id -p 8022 -i id_rsa \$TERMUX_PHONE_IP`"
        end

        echo "Make sure phone has sshd and passwd enabled."
        echo "Type sshd on phone terminal to enable ssh connection."
        read -P "Press any key to continue."

        # check connection
        if not ssh -o ConnectTimeout=5 -p 8022 $TERMUX_PHONE_IP ls >/dev/null 2>&1

            echo "ssh connection needs troubleshooting"

        else

            set -l syncfolders Documents Music Zotero Pictures 

            ## move recent camera files to the other DCIM folder, to have everything in one place
            # ssh -p '8022' $TERMUX_PHONE_IP 'mv /storage/emulated/0/DCIM/Camera/  /storage/emulated/0/Pictures/DCIM/Camera/'

            for folder in $syncfolders
                # if type -q unison
                #     unison -auto ~/$folder $TERMUX_PHONE_IP:/storage/emulated/0/$folder/
                # else
                rsync -auv -e 'ssh -p 8022' $TERMUX_PHONE_IP:/storage/emulated/0/$folder/ $HOME/$folder/
                rsync -auv -e 'ssh -p 8022' $HOME/$folder/ $TERMUX_PHONE_IP:/storage/emulated/0/$folder/
                # end
            end

        end
    end

end
