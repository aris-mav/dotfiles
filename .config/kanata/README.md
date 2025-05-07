# INSTRUCTIONS TO RUN IN BACKGROUND (linux)

Follow steps here : https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md 
(so that the keyboard is recognised without sudo)

Add the following to a file in ~/.config/systemd/user/kanata.service

------------------------------------------------------

[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Environment=PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:${HOME}/.local/bin
Environment=DISPLAY=:0
Type=simple
ExecStart=/usr/bin/sh -c "exec $HOME/software/kanata/target/debug/kanata --cfg $HOME/.config/kanata/config.kbd"

Restart=no

[Install]
WantedBy=default.target

------------------------------------------------------
(of course, edit paths in ExecStart if needed)

Run systemctl --user start kanata.service to start kanata daemon
Run systemctl --user enable kanata.service so it may autostart whenever the current user logs in.
Run systemctl --user status kanata.service to check if kanata daemon is running or not.
Run systemctl --user restart kanata.service to restart.
