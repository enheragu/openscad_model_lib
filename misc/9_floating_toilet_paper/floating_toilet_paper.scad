
/* [Floating paper support Info] */

// Support height (mm)
support_height = 55;

// Diameter of the insertable part (mm)
support_diameter = 36; // 0.1

// Base height (mm)
base_height = 3.0; // 0.1

// Base diameter (mm)
base_diameter = 60; // 0.1

/* [Other] */
// $fn resolution
fn = 150;


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

module floating_toilet_paper()
{
    color("white")
    union()
    {
        fillete_cylinder(base_diameter, base_height, base_height/3);
        fillete_cylinder(support_diameter, support_height, (support_diameter/2)/3);
    }
}


floating_toilet_paper();