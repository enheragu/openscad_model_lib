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