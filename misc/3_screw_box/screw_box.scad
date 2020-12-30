
/* [Design settings] */
// Number of "fingers" in the spiral
fingers = 1;

// Minimum wall thickness (mm)
wall_thickness = 2;

/* [Inside Space Measures] */
// Diameter of the inside space (mm)
in_diameter = 10;
// Height inside the box (mm)
in_height = 30;

/* [Printer settings] */
// Printer tolerance (mm). Printers are not perfect, pieces need a bit of margin to fit.
tolerance_mm = 0.4;

// Tolerance in degrees to fit screw parts
tolerance_deg = 5;

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

    linear_extrude(height = hole_height, convexity = 10, twist = -hole_height*2, $fn = fn)
    polygon(points = polygon_points);
}

module spiral_fingers(hole_diameter, hole_height, wall, n_finger)
{
    union()
    {
        for(x = [0:n_finger])
        {
            angle = (360/n_finger) * x;
            echo("x: ", x, "; angle: " , angle);
            rotate([0,0,angle])
            spiral_finger(hole_diameter, hole_height, wall, n_finger);
        }
    }
}


inner_space(in_diameter, in_height/3,wall_thickness);
spiral_fingers(in_diameter, in_height,wall_thickness, fingers);





