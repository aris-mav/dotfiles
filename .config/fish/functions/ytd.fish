function ytd

    read -l -P  "YouTube url : " url
    read -l -P  "file name : " filename
    read -l -P  "Song name : " songname
    read -l -P  "Artist : " artist
    read -l -P  "Album : " album

    yt-dlp -x --audio-format mp3 --audio-quality 0 -o $filename $url
    eyeD3 -a $artist -t $songname -A $artist $filename

end
