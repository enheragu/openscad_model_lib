
/* [Marker dimension] */

// Diameter of the marker (mm)
diameter = 30; // 0.1

// Height of the marker (mm)
height = 3; // 0.1

/* [Marker design] */

// Text to appear in the marker. Do not forget to adapt the dimensions or the design
text = "+1/+1";

// Sides, set high value for circular marker :)
sides = 150; // [4:150]

// Rotation of base shape to make text fit in the right direction (deg)
rotation = 0;

// Factor to increment size in one of the axis (to get more rectangled-shapes to fit text (: )
// Note that deformation is applied after rotation.
deformation = 1; // 0.1

// Size of the text
text_size = 5.6;

// Separation between letters
text_spacing = 0.8; // [0.5:0.01:1.5]

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

/* [Other] */
// $fn resolution
fn = 150;


module marker_base(in_diameter, in_height, in_sides)
{
    mid_height = 2*in_height/3;
    round_corner = 0.5;

    hull()
    {
        upper_toroid_diameter = in_diameter - round_corner;
        lowwer_toroid_diameter = in_diameter*0.8 - round_corner;

        translate([0, 0, in_height - round_corner])
        rotate_extrude(convexity = 10, $fn = in_sides)
        translate([upper_toroid_diameter/2, 0, 0])
        circle(d=round_corner, $fn = fn);

        translate([0, 0, mid_height])
        rotate_extrude(convexity = 10, $fn = in_sides)
        translate([upper_toroid_diameter/2, 0, 0])
        circle(d=round_corner, $fn = fn);

        translate([0, 0, round_corner])
        rotate_extrude(convexity = 10, $fn = in_sides)
        translate([lowwer_toroid_diameter/2, 0, 0])
        circle(d=round_corner, $fn = fn);
    }
}

module marker(in_diameter, in_height, in_sides)
{
    // To have squared well oriented
    scale([deformation,1,1])
    rotate([0,0,rotation])
    difference()
    {
        marker_base(in_diameter, in_height, in_sides);
        translate([0,0,in_height*0.5])
        resize([in_diameter+tolerance,0,0], auto=true)
        marker_base(in_diameter, in_height, in_sides);
    }
}

module etruded_text(l, letter_size = 4, letter_height = 0.5, font = "Courier 10 Pitch:style=Bold") {
	// Use linear_extrude() to make the letters 3D objects as they
	// are only 2D shapes when only using text()
    translate([-letter_size/6,0,0])
	linear_extrude(height = letter_height) {
		text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = fn,
        spacing = text_spacing);
	}
}

module marker_text(in_diameter, in_height, in_sides, in_text)
{
    difference()
    {
        marker(in_diameter, in_height, in_sides);
        translate([0,0,-0.1]) // ensure cutting
        etruded_text(in_text, text_size, in_height*1.1);
    }
}

marker_text(diameter, height, sides, text);
