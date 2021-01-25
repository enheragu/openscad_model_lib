
// Tube diameter (mm)
tube_diameter = 20;

// Wall width (mm)
wall_width = 3;

// Hole diameter for the screws
hole_diameter = 2;

support_height = 15;

/* [Other] */
// $fn resolution
fn = 120;

module toroid(diameter, section_diameter)
{
    rotate_extrude(convexity = 10, $fn = fn)
    translate([diameter/2, 0, 0])
    circle(d=section_diameter);
}

module fillete_cylinder(diameter, height, round_rad)
{
    rotate_extrude(angle = 360, convexity = 10, $fn = fn)
    {
        side = diameter/2;
        round_diam = round_rad*2;
        translate([side-round_diam,0,0])
        union()
        {
            translate([round_rad,height-round_rad,0])
            circle(r = round_rad, $fn = fn);
            square([round_diam, height-round_rad]);
        }
        square([side-round_rad, height]);
    }
}

module tube_support()
{
    round_rad = wall_width/2;
    diameter = tube_diameter+wall_width*2;
    diameter_support = diameter + wall_width*4 + hole_diameter*2 + round_rad*2;
    fillete_cylinder(diameter_support, wall_width, round_rad);
    fillete_cylinder(diameter, support_height, round_rad);

    // fillet
    translate([0,0,round_rad])
    difference()
    {
        cylinder(d = diameter+wall_width, h = wall_width, $fn = fn);
        translate([0,0,wall_width])
        rotate_extrude(angle = 360, convexity = 10, $fn = fn)
        translate([diameter/2+round_rad,0,0])
        circle(r = round_rad, $fn = fn);
    } 
}

tube_support();

    