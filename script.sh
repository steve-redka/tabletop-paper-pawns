#!/bin/bash

rm -f output.jpg

# Function to resize an image based on its filename
resize_image() {
  local input_file="$1"
  local output_file="$2"

  if [[ "$input_file" =~ "big" ]]; then
    convert "$input_file" -resize 710x1420 -gravity North -extent 710x1420 \
      -gravity South -pointsize 24 -annotate +0+150 "%t" \
      -resize 710x1420 -gravity North -extent 710x -append -rotate 180  \( +clone -rotate 180 \) \
      -bordercolor black -border 1 -append \
      "$output_file"
  else
    convert "$input_file" -resize 355x710 -gravity North -extent 355x710 \
      -gravity South -pointsize 24 -annotate +0+120 "%t" \
      -resize 355x730 -gravity North -extent 355x -append -rotate 180  \( +clone -rotate 180 \) \
      -bordercolor black -border 1 -append \
      "$output_file"
  fi
}

# Find all images in the current directory
find . -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | while IFS= read -r -d '' image_file; do
  # Create intermediate files
  output_file="${image_file%.jpg}_resized.jpg"

  # Resize the image
  resize_image "$image_file" "$output_file"
done

montage -geometry +0+0 -tile 6x8 *_resized.jpg output.jpg

# Delete intermediate resized images
rm *_resized.jpg
