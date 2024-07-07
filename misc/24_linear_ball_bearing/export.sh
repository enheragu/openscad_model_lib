mkdir -p stl
# Strange way to provide string to scad script :)


echo "Export Screen Clips"
openscad -D"export=\"L\"" -o stl/lower_side.stl linear_ball_bearing.scad &
openscad -D"export=\"U\"" -o stl/upper_side.stl linear_ball_bearing.scad &