#!/usr/bin/env bash

# Folder berisi wallpaper
# DIR="$HOME/.dotfiles/themes/current/wallpapers/"
DIR="$HOME/Pictures/Wallpaper/Purplish"

# Ambil semua file gambar
FILES=($(ls "$DIR"/*.{jpg,jpeg,png} 2>/dev/null))
# Generate list dengan icon preview
if [[ $1 == "first" ]]; then
	swww img "${FILES[0]}" --transition-type center --transition-fps 60 --transition-step 200
else
	LIST=""
	for img in "${FILES[@]}"; do
	    # basename (tanpa path) untuk ditampilkan
	    name=$(basename "$img")
	    # tambahkan hint icon supaya muncul thumbnail
	    LIST+="$name\x00icon\x1f$img\n"
	done

	# Panggil rofi dengan preview
	SELECTED=$(echo -e "$LIST" | rofi -dmenu -p "Wallpaper:")
	# SELECTED=$(echo -e "$LIST" | wofi --dmenu --allow-images --prompt "Wallpaper:")


	# Kalau tidak ada pilihan → keluar
	[ -z "$SELECTED" ] && exit

	# Ambil path full sesuai pilihan
	CHOSEN="$DIR/$SELECTED"

	# Set wallpaper dengan transisi
	swww query || swww init
	swww img "$CHOSEN" --transition-type center --transition-fps 60 --transition-step 200
fi
