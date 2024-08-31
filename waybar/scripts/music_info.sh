#! /bin/zsh

## Get status
get_status() {
	player_status=$(playerctl status)

	if [[ $player_status == "Playing" ]]; then
		echo "▶"
	else
		echo "⏸"
	fi
}

## Get song
get_song() {
	song=$(playerctl metadata title)
	if [[ $song != "No players found" ]]; then
		echo "$song"
	fi
}

## Get artist
get_artist() {
	artist=$(playerctl metadata artist)
	if [[ $artist != "No players found" ]]; then
		echo "$artist"
	fi
}

get_song_art() {
	art_url=$(playerctl metadata mpris:artUrl)

	if [[ -z $art_url ]]; then
		exit
	fi

	curl -s "${art_url}" --output "/tmp/cover.jpg"
	echo "/tmp/cover.jpg"
}

## Execute accordingly
if [[ "$1" == "--title" ]]; then
	get_song
elif [[ "$1" == "--artist" ]]; then
	get_artist
elif [[ "$1" == "--status" ]]; then
	get_status
elif [[ "$1" == "--art" ]]; then
	get_song_art
elif [[ $1 == "--line" ]]; then
	playerctl status &> /dev/null && echo $(get_status) $(get_artist) - $(get_song)
elif [[ "$1" == "--toggle" ]]; then
	playerctl play-pause
elif [[ "$1" == "--next" ]]; then
	playerctl next
elif [[ "$1" == "--prev" ]]; then
	playerctl previous
fi
