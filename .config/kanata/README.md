# INSTRUCTIONS TO RUN IN BACKGROUND (linux)

Follow steps here : https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md 
(so that the keyboard is recognised without sudo)

1. If the uinput group does not exist, create a new group
```
sudo groupadd uinput
```
2. Add your user to the input and the uinput group
```
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
```
Make sure that it's effective by running groups. You might have to logout and login.

3. Make sure the uinput device file has the right permissions.
Add a udev rule (in either /etc/udev/rules.d or /lib/udev/rules.d) with the following content:
```
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
```
4. Make sure the uinput drivers are loaded
You may need to run this command whenever you start kanata for the first time:
```
sudo modprobe uinput
```

Add the following to a file in ~/.config/systemd/user/kanata.service

------------------------------------------------------

[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Environment=PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:${HOME}/.local/bin
Environment=DISPLAY=:0
Type=simple
ExecStart=/usr/bin/sh -c "exec $HOME/.cargo/bin/kanata --cfg $HOME/.config/kanata/kanata.kbd"

Restart=no

[Install]
WantedBy=default.target

------------------------------------------------------
(of course, edit paths in ExecStart if needed)

`systemctl --user start kanata.service` to start kanata daemon
`systemctl --user enable kanata.service` so it may autostart whenever the current user logs in.
`systemctl --user status kanata.service` to check if kanata daemon is running or not.
`systemctl --user restart kanata.service` to restart.

To obtain permissions, run the following:

```
groupadd uinput
sudo usermod -aG input arismav
sudo usermod -aG uinput arismav 
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' > /etc/udev/rules.d/99-input.rules
udevadm control --reload-rules && udevadm trigger
modprobe uinput
```

To make this start before login, run 
`loginctl enable-linger`
or
`sudo loginctl enable-linger <USERNAME>`

