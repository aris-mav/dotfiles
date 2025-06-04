function ytd

    argparse 's/song' 'p/playlist' -- $argv
    
    if set -ql _flag_s

        if not type -q yt-dlp
            echo "oi, you need to install yt-dlp"
            return 1
        else if not type -q eyeD3
            echo "oi, you need to install eyeD3"
            return 1
        end

        read -l -P  "YouTube url : " url
        read -l -P  "file name : " filename
        read -l -P  "Song name : " songname
        read -l -P  "Artist : " artist
        read -l -P  "Album : " album

        yt-dlp -x --audio-format mp3 --audio-quality 0 -o $filename $url
        eyeD3 -a $artist -t $songname -A $album $filename

    else if set -ql _flag_p
        yt-dlp -f "bv[ext=webm][height=720]+ba[ext=webm]" \
        -o "%(playlist_index)03d - %(title)s.%(ext)s" \
        $argv
    end
end
