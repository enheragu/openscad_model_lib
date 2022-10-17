
/* [Export settings] */
// You can use this mode setting to export each of the models or see the final assembly with all of them
export = "I"; // [I:Inner Side, O: Outer Side]

/* [Tube handle Info] */
// Tube diameter (mm)
tube_diameter = 16;

// Wall width (mm)
wall_width = 3.5;

support_height = 15;

/* [Screw and Nut Info] */
// Choose whether this piece will have footprint for screw or nut
option = "N"; //[S:Screw,N:Nut]

// Hole diameter for the screws
hole_diameter = 3;

// Diameter of the screw head or diameter of the circumscribed circle for the nut
head_diameter = 7;

// Depth of the screw/nut footprint
footprint_depth = 1;


/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. Note that some 
// of the pieces do not include this tolerance as they are supposed to fit tight (mm)
tolerance = 0.4;

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

module base_support(round_rad, diameter, diameter_support)
{
    difference()
    {
        fillete_cylinder(diameter_support, wall_width, round_rad);

        // screw holes
        rad_holes = diameter_support/2 - wall_width - round_rad;
        new_fn = (option == "N") ? 6 : fn;
        for (i = [0 : 3])
        {
            rotate([0,0,90*i])
            translate([rad_holes,0,0])
            union()
            {
                translate([0,0,-0.1])
                cylinder(d = hole_diameter+tolerance, h = wall_width+0.2, $fn = fn);
                translate([0,0,wall_width-footprint_depth])
                cylinder(d = head_diameter+tolerance, h = wall_width+0.2, $fn = new_fn);
            }
        }
    }
}

module tube_support(round_rad, diameter, diameter_support)
{
    difference()
    {
        union()
        {
            base_support(round_rad, diameter, diameter_support);
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
        side = tube_diameter+tolerance;
        translate([0,0,wall_width])
        cylinder(d = side, h = support_height+0.2, $fn = fn);

        translate([-side/2,-diameter_support,wall_width])
        cube([side,diameter_support,side+0.2]);
    }
}

    
round_rad = wall_width/2;
diameter = tube_diameter+wall_width*2;
diameter_support = diameter + wall_width*4 + hole_diameter*2 + round_rad*2;

// Exportable modules
if (export == "I") {
    tube_support(round_rad, diameter, diameter_support);
} else if (export == "O") {
    base_support(round_rad, diameter, diameter_support);
}