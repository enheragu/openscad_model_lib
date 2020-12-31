
/* [Design settings] */
// Number of "fingers" in the spiral
fingers = 3;

// Minimum wall thickness (mm)
wall_thickness = 2;

// Percentage of inside part that is covered by each side. Nominal is printing to pieces at 48%,
// but you can combine them as long as they sum less than 100% (leave a bit of margin :) just in case) (%)
percentage = 48; // [5:1:95]

// Inclination of the fingers, note that is a factor to control the inclination, not the exact inclination
inclination = 5;

/* [Inside Space Measures] */

// Diameter of the inside space (mm)
in_diameter = 10;

// Height inside the box (mm)
in_height = 30;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance_mm = 0.4;

// Tolerance in degrees to fit screw parts (deg)
tolerance_deg = 1;

/* [Other] */
// $fn resolution
fn = 150;

module inner_space(hole_diameter, hole_height, wall)
{
    diam_inner_space = hole_diameter + tolerance_mm*2 + wall*2;
    diam_spiral_base = diam_inner_space + wall*2;
    union()
    {
        difference()
        {   
            cylinder(d = diam_inner_space, h = hole_height, $fn = fn);
            translate([0,0,wall])
            cylinder(d = diam_inner_space-wall*2, h = hole_height, $fn = fn); // Add 0.1 to ensure cutting
        }
        cylinder(d = diam_spiral_base, h = wall_thickness, $fn = fn);
    }
}

module spiral_finger(hole_diameter, hole_height, wall, n_finger)
{
    diam_inner_space = hole_diameter + tolerance_mm*2 + wall*2;
    diam_spiral_base = diam_inner_space + wall*2;

    function arcAngle(radious, angle,step) = [ for (a = [0 : step : angle]) [radious*cos(-a),radious*sin(-a)] ];
    function arcAngleInverse(radious, angle,step) = [ for (a = [angle : -step : 0]) [radious*cos(-a),radious*sin(-a)] ];
    
    step = 3; // degrees
    angle = 360 / (n_finger*2) - tolerance_deg;
    arc1 = arcAngle(diam_spiral_base/2, angle, step);
    arc2 = arcAngleInverse(diam_inner_space/2, angle, step);
    polygon_points = concat(arc1,arc2);

    linear_extrude(height = hole_height, convexity = 10, twist = -hole_height*inclination, $fn = fn)
    polygon(points = polygon_points);
}

module spiral_fingers(hole_diameter, hole_height, wall, n_finger)
{
    union()
    {
        for(x = [0:n_finger])
        {
            angle = (360/n_finger) * x;
            // echo("x: ", x, "; angle: " , angle);
            rotate([0,0,angle])
            spiral_finger(hole_diameter, hole_height, wall, n_finger);
        }
    }
}

module spiral_fingers_margin(hole_diameter, hole_height, complete_height, wall)
{
    diam_inner_space = hole_diameter + tolerance_mm*2 + wall*2;
    translate([0,0,hole_height])
    cylinder(d = diam_inner_space + tolerance_mm*2, h = complete_height);
}


module scre_box_side(in_percentage)
{
    difference()
    {
        height = in_height * in_percentage /100;
        union()
        {
            inner_space(in_diameter, height, wall_thickness);
            spiral_fingers(in_diameter, in_height,wall_thickness, fingers);
        }
        spiral_fingers_margin(in_diameter, height, in_height, wall_thickness);
    }
}


scre_box_side(percentage);


// module scre_box_side_tagged(l, in_percentage, letter_size = 4, letter_height = 0.5, font = "Liberation Sans") {
// 	// Use linear_extrude() to make the letters 3D objects as they
// 	// are only 2D shapes when only using text()
//     color("black")
//     translate([0,-in_diameter*1.5,0])
// 	linear_extrude(height = letter_height) {
// 		text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
// 	}
//     scre_box_side(in_percentage);
// }


// // translate([-in_diameter*3,0,0])
// // scre_box_side_tagged("1 (13%)", 13);

// color("black",0.8)
// translate([0,0,in_height+wall_thickness])
// rotate([180,0, -16])
// scre_box_side(13);
// color("black")
// translate([0,2*-in_diameter*1.5,0])
// linear_extrude(height = 0.5) {
//     text("1 (13%)", size = 4, font = "Liberation Sans", halign = "center", valign = "center", $fn = 16);
// }
// color("red",0.5)
// scre_box_side_tagged("2 (83%)", 83);

// translate([in_diameter*3,0,0])
// scre_box_side_tagged("3 (48%)", 48);

// translate([2*in_diameter*3,0,0])
// scre_box_side_tagged("4 (48%)", 48);
