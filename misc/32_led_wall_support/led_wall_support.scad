
/** [Light Info] **/

diameter = 90;

height = 13;

cable_diam = 4;


/** [Other] **/

fn=150;

tolerance = 0.4;

$fn = fn;



module ring_profile_2d(diameter) {
    cable_clear = cable_diam + tolerance*2;
	difference()
    {
        circle(r = diameter/2+tolerance);

        translate([diameter/2-cable_clear/2, 0])
		union()
        {   
            translate([0, -cable_clear / 2])
            square([cable_clear, cable_clear]);
            circle(r = cable_clear / 2);
		}
	}
}

module profile(diameter) {
	linear_extrude(height = height/2, center = false)
		ring_profile_2d(diameter);
}

module led_wall_support() {
	hull()
    {
		translate([0,-diameter/3-9.8, diameter/2])
        rotate([90, 0, 0])
        profile(diameter*3/4);

        rotate([6, 0, 0])
        profile(diameter);
	}
}

led_wall_support();

