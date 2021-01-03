
mkdir -p stl_output
# Strange way to provide string to scad script :)

# Export Screen Clips
openscad -D"mode=\"screen_clip_1\"" -o stl_output/screen_clip_1.stl screen.scad
openscad -D"mode=\"screen_clip_2\"" -o stl_output/screen_clip_2.stl screen.scad
openscad -D"mode=\"screen_clip_3\"" -o stl_output/screen_clip_3.stl screen.scad
openscad -D"mode=\"screen_clip_4\"" -o stl_output/screen_clip_4.stl screen.scad

# Export Screen keypad Clip
openscad -D"mode=\"clip\"" -o stl_output/screen_buttons_clip.stl screen_buttons.scad
