
mkdir -p stl_output
# Strange way to provide string to scad script :)


echo "Wood supports:"
openscad -D"support_height=70" -o stl_output/70mm_wood_support.stl ./wood_support.scad
openscad -D"support_height=74" -o stl_output/74mm_wood_support.stl ./wood_support.scad
openscad -D"support_height=80" -o stl_output/80mm_wood_support.stl ./wood_support.scad
openscad -D"support_height=63" -o stl_output/63mm_wood_support.stl ./wood_support.scad
openscad -D"support_height=60" -o stl_output/60mm_wood_support.stl ./wood_support.scad
openscad -D"support_height=90" -o stl_output/90mm_wood_support.stl ./wood_support.scad
openscad -D"support_height=35" -o stl_output/35mm_wood_support.stl ./wood_support.scad
openscad -D"support_height=80" -o stl_output/80mm_wood_support.stl ./wood_support.scad
openscad -D"support_height=100" -o stl_output/100mm_wood_support.stl ./wood_support.scad