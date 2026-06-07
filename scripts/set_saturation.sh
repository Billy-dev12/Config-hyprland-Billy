#!/usr/bin/env bash

# Lokasi file shader
FRAG_FILE="$HOME/.config/hypr/saturate.frag"

# Cek apakah user memberikan input atau tidak
if [ -z "$1" ]; then
    echo "Cara pakai: $0 <nilai_saturasi>"
    echo "Contoh: $0 1.5"
    echo "Contoh: $0 2"
    exit 1
fi

# Pastikan input selalu menjadi angka desimal (kalau input 5, diubah ke 5.0 karena GLSL butuh desimal)
VALUE=$(awk -v num="$1" 'BEGIN { printf "%.2f", num }')

# Ganti nilai "float saturation = ...;" di dalam saturate.frag menggunakan sed
sed -i -E "s/float saturation = [0-9.]*;/float saturation = ${VALUE};/" "$FRAG_FILE"

# Paksa Hyprland menggunakan shader yang sudah di update ini langsung (Tanpa perlu restart / reload manual)
hyprctl keyword decoration:screen_shader "$FRAG_FILE"

# Menampilkan notifikasi popup (opsional, karena kulihat kamu pakai dunst di config)
notify-send "Saturasi Diubah" "Tingkat saturasi layar sekarang: $VALUE" -i video-display -t 2000

echo "✅ Saturasi berhasil diubah ke $VALUE"
