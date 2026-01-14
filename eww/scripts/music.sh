title=$(mpc --format "%title%" current 2>/dev/null)
file=$(mpc --format "%file%" current)
artist=$(mpc --format "%artist%" current 2>/dev/null)
# status=$(mpc status 2>/dev/null)

if [[ -z "$file" ]]; then
  echo "No Music"
  exit
elif [[ -z "$title" ]]; then
  base="${file%.*}"
  artist="${base%% - *}"
  title="${base#* - }"
fi

echo "$artist - $title"
