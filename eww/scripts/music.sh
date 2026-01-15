arg=$1

get_music_info() {
  title=$(mpc --format "%title%" current 2>/dev/null)
  file=$(mpc --format "%file%" current)
  artist=$(mpc --format "%artist%" current 2>/dev/null)

  if [[ -z "$file" ]]; then
    echo "No Music"
    exit
  elif [[ -z "$title" ]]; then
    base="${file%.*}"
    artist="${base%% - *}"
    title="${base#* - }"
  fi

  echo "$artist - $title"
}

get_music_status() {
  echo "$(mpc status | awk 'NR==2 {print $1}' | tr -d '[]')"
}

if [[ $arg == "status" ]]; then
  get_music_status
else
    get_music_info
fi

