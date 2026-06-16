
/* [Support Info] */

// Width of printed wall (mm)
wall_width = 3; // 0.1

// Support length (mm)
support_length = 40;

// Diameter of the hole (metric?) (mm)
screw_hole_diam = 5.8;

// Diameter of the screw head (mm)
screw_head_diam = 9.9;

// Nut circunscribed circunference diameter (mm)
nut_diam = 11.1;


/* [Power strip Info] */

// Power strip height
ps_height = 40; // 0.1

// Power strip width (mm)
ps_width = 54.5; // 0.1

// Whether to perform hole for the cable or not
cable_hole = true;

// Diameter of the cable (set to 0 if no cable hole is needed) (mm)
cable_diameter = 26.5;

// Position of the cable hole in the object. Note that 0,0 means centered (mm,mm)
cable_position = [0,0];

// Border on each side up to the power outlet slot (mm)
border_side = 4;

// Border on the end of the power strip to the first power outlet slot (mm)
border_end = 4; 

// This flag lets you change in which piece is the nut and screw holes. If the support is smaller you might not be able to introduce the screw, just switch it :)
invert_nut_screw = false;

/* [Leg Info] */
// Leg dimensions, take into account to add rubbers here to aboid slippery (mm,mm)
leg_size = [30.5, 42.5];

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


// sn -> screw/nut dimension
module screw_nut_support(side, h, sn_diam, hole_metric, fn_input)
{
    rotate([0,90,0])
    translate([-side/2,side/2,0])
    difference()
    {
        // Center in X and Y for easyer with cylinders
        translate([-side/2,-side/2,0])
        //cube([side, side, h]);
        filleted_rectangle(side,side,h, wall_width/2);

        translate([0,0,wall_width])
        cylinder(d = sn_diam+tolerance*2, h = h, $fn = fn_input);

        translate([0,0,-0.1])
        cylinder(d = hole_metric+tolerance, h = h+0.2, $fn = fn);
    }
}

module table_support()
{
    length = max(screw_head_diam, nut_diam) + wall_width*2 + tolerance*2;
    size_x = leg_size.x + wall_width*2 + tolerance*2;
    size_y = leg_size.y + wall_width*2 + tolerance*2;

    cut_width = 2;
    // Add screw/nut support    
    rotate([0,90,0])
    translate([-wall_width,-size_y/2,0])
    union()
    {
        difference()
        {
            filleted_rectangle(size_x, size_y, length, wall_width/2);
            
            translate([wall_width, size_y/2 - leg_size.y/2, -0.1])
            cube([leg_size.x,leg_size.y,length+0.2]);

            // Make cut between both parts of clip
            translate([size_x/2 - cut_width/2, -0.1, -0.1])
            cube([cut_width, size_y+0.2, length + 0.2]);
        }
        
        // Adds lines to invert position of nut and screw on flag
        upper_diam = (invert_nut_screw) ? nut_diam : screw_head_diam;
        lower_diam = (invert_nut_screw) ? screw_head_diam : nut_diam;
        
        n_h = wall_width + nut_diam/2; 
        s_h = wall_width + screw_head_diam/2;
        
        upper_h = (invert_nut_screw) ? n_h : s_h;
        lower_h = (invert_nut_screw) ? s_h : n_h;
        
        upper_fn = (invert_nut_screw) ? 6 : fn;
        lower_fn =(invert_nut_screw) ? fn : 6;
        
        n_side = nut_diam + wall_width*2 + tolerance*2;
        translate([size_x/2+cut_width/2, size_y-wall_width, 0])
        screw_nut_support(n_side, upper_h, upper_diam, screw_hole_diam, upper_fn);

        translate([size_x/2+cut_width/2,wall_width-n_side,0])
        screw_nut_support(n_side, upper_h, upper_diam, screw_hole_diam, upper_fn);

        // Uses nut computed side as nut is bigger thatn screw of same metric:
        // s_side = screw_head_diam + wall_width*2 + tolerance*2;
        translate([size_x/2-cut_width/2, size_y-wall_width, n_side])
        rotate([0,180,0])
        screw_nut_support(n_side, lower_h, lower_diam, screw_hole_diam, lower_fn);

        translate([size_x/2-cut_width/2, wall_width-n_side, n_side])
        rotate([0,180,0])
        screw_nut_support(n_side, lower_h, lower_diam, screw_hole_diam, lower_fn);
    }
}

module support()
{
    size_x = support_length + wall_width*2 + tolerance*2;
    size_y = ps_width + wall_width*2 + tolerance*2;
    size_z = ps_height + wall_width*2 + tolerance*2;

    // Center in Y for easyer handling
    difference()
    {
        union()
        {
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
            table_support();
        }
        translate([0,-size_y/2,0])
        if (cable_hole)
        {
            // Cable hole        
            cable_hole_y = cable_diameter + tolerance*2;
            cable_hole_z = size_z/2 + cable_position.y + cable_hole_y/2;

            translate([-0.1, size_y/2 - cable_hole_y/2  + cable_position.x, -0.1])
            cube([size_x + 0.2,cable_hole_y, cable_hole_z-cable_hole_y/2]);    

            translate([-0.1, size_y/2 + cable_position.x, size_z/2 + cable_position.y])
            rotate([0,90,0])
            cylinder(d = cable_hole_y, h = wall_width + 0.2, $fn = fn);
        }
    }
}


support();