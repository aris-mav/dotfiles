If the window bar is white, you can
`sudo nvim /usr/share/applications/org.pwmt.zathura.desktop`
and edit the exec section to 
`Exec=env GTK_THEME=Adwaita:dark zathura %U`
to make it dark.

On fish shell, do 
`set -Ux GTK_THEME Adwaita:dark`
