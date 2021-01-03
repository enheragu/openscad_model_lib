
mkdir -p stl_output
# Strange way to provide string to scad script :)

# Export Screen Clips
openscad -D"mode=\"screen_clip_1\"" -o stl_output/screen_clip_1.stl screen_stuff/screen.scad
openscad -D"mode=\"screen_clip_2\"" -o stl_output/screen_clip_2.stl screen_stuff/screen.scad
openscad -D"mode=\"screen_clip_3\"" -o stl_output/screen_clip_3.stl screen_stuff/screen.scad
openscad -D"mode=\"screen_clip_4\"" -o stl_output/screen_clip_4.stl screen_stuff/screen.scad

# Export Screen keypad Clip
openscad -D"mode=\"clip\"" -o stl_output/screen_buttons_clip.stl screen_stuff/screen_buttons.scad

# Export Screen keypad Clip
openscad -D"mode=\"speaker_clip\"" -o stl_output/screen_speaker_clip.stl screen_stuff/screen_speaker.scad

# Export raspberry py 3A+ Clip
openscad -D"mode=\"rpy_clip\"" -o stl_output/skadis_rpy3aplus_clip.stl skadis_rpy3aplus_clip.scad
