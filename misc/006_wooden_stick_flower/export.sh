mkdir -p stl_output
# Strange way to provide string to scad script :)

echo "Export Wooden Stick flower parts"
echo "Export Pot"
openscad -D"mode=\"Pot\""    -o stl_output/Pot.stl    wooden_stick_flower.scad
echo "Export Leaf"
openscad -D"mode=\"Leaf\""   -o stl_output/Leaf.stl   wooden_stick_flower.scad
echo "Export Flower"
openscad -D"mode=\"Flower\"" -o stl_output/Flower.stl wooden_stick_flower.scad
