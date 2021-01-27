
/* [Support Info] */

// Width of printed wall (mm)
wall_width = 3;

// Support length (mm)
support_length = 50;

scre_hole_diam = 3;

screw_head_diam = 5;

nut_diam = 5;

/* [Power strip Info] */

// Power outlet height
ps_height = 40;

// Power outlet width (mm)
ps_width = 53;

// Whether to perform hole for the cable or not
cable_hole = false;

// Diameter of the cable (set to 0 if no cable hole is needed) (mm)
ps_cable_diameter = 12.1;

// Border on each side up to the power outlet slot (mm)
border_side = 3;

// Border on the end of the power strip to the first power outlet slot (mm)
border_end = 3;

/* [Leg Info] */
// Leg dimensions, take into account to add rubbers here (mm,mm)
leg_size = [37.31, 65.8];

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.5;

/* [Other] */
// $fn resolution
fn = 150;


module filleted_rectangle(size_x,size_y,size_z, round_rad)
{
    hull()
    {   
        linear_extrude(height = size_z) translate([round_rad,round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([size_x-round_rad,round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([round_rad,size_y-round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([size_x-round_rad,size_y-round_rad,0]) circle(d= round_rad*2, $fn = fn);
    }
}

module base_stand()
{
    size_x = support_length + wall_width*2 + tolerance*2;
    size_y = ps_width + wall_width*2 + tolerance*2;
    size_z = ps_height + wall_width*2 + tolerance*2;

    // Center in Y for easyer handling
    translate([0,-size_y/2,0])
    difference()
    {
        filleted_rectangle(size_x,size_y,size_z, wall_width/2);
        translate([wall_width, size_y/2 - ps_width/2, size_z/2 - ps_height/2])
        cube([size_x*tolerance*2,ps_width*tolerance*2,ps_height*tolerance*2]); // Use size_x to ensure complete cutting

        hole_width = ps_width-border_side*2;
        translate([wall_width + border_end, size_y/2 - hole_width/2, ps_height])
        filleted_rectangle(size_x, ps_width-border_side*2, ps_height, wall_width/2);
    }
}

module table_support()
{
    length = max(screw_head_diam, nut_diam) + wall_width*2 + tolerance*2;
    size_x = leg_size.x + wall_width*2 + tolerance*2;
    size_y = leg_size.y + wall_width*2 + tolerance*2;
    rotate([0,90,0])
    translate([-wall_width-tolerance,-size_y/2,0])
    difference()
    {
        filleted_rectangle(size_x, size_y, length, wall_width/2);
        
        translate([wall_width, size_y/2 - leg_size.y/2, -0.1])
        cube([leg_size.x,leg_size.y,length+0.2]);
    }
}

base_stand();
table_support();