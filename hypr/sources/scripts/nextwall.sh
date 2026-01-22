#!/usr/bin/env bash

# Folder wallpaper
DIR="$HOME/Pictures/Wallpaper/Purplish"

# Ambil semua file gambar (pakai array bash, lebih aman dari ls)
shopt -s nullglob  # Kalau gak ada file, array kosong (gak error)
FILES=("$DIR"/*.{jpg,jpeg,png,webp})

# Cek apakah ada file
if [[ ${#FILES[@]} -eq 0 ]]; then
    notify-send "Error" "No wallpapers found in $DIR"
    exit 1
fi

# Mode "first" → set wallpaper pertama
if [[ $1 == "first" ]]; then
    swww img "${FILES[0]}" \
        --transition-type center \
        --transition-fps 60 \
        --transition-step 200
    exit 0
fi

# Generate list untuk rofi
LIST=""
for img in "${FILES[@]}"; do
    name=$(basename "$img")
    LIST+="$name\x00icon\x1f$img\n"
done

# PERBAIKAN: Hapus \n terakhir
LIST="${LIST%\\n}"  # <-- Ini yang penting! Hapus \n di akhir

# Panggil rofi
SELECTED=$(echo -e "$LIST" | rofi -theme "$HOME/.config/rofi/themes/wallpaper.rasi" -dmenu -p " Wallpaper ")

# Kalau gak ada yang dipilih, exit
[[ -z "$SELECTED" ]] && exit 0

# Set wallpaper
CHOSEN="$DIR/$SELECTED"

# Init swww kalau belum jalan
swww query || swww init

# Set wallpaper dengan transisi
swww img "$CHOSEN" \
    --transition-type center \
    --transition-fps 60 \
    --transition-step 200

# Optional: Simpan pilihan terakhir
# echo "$CHOSEN" > "$HOME/.cache/current_wallpaper"
