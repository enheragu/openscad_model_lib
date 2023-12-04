include <./sliding_lid_box.scad>

/* [Box Info] */

// Dice side in mm
elechtronics_size = [50, 101, 101 + wall_width *3]; 
// exrta margin for wall attatchment

/* [Other] */

export = "AS"; //[DL:Lid, DB:Base, AS:Assembly, DN:None]
// $fn resolution
fn = 80;

module elec_box_base(dimensions, wall_w, r_round)
{
    // hole for power cable
    power_cable_center = [23.2, 48.5];
    cable_diam = 11;

    // Wall support
    wall_attach_dim = [7, 7];
    wall_small_diam = 4;
    extra = 2;

    // DHT11 hole
    dht22_position = [23, 74];
    dht22_slot = [4, 11];

    hole_width = wall_w + epsilon*4;
    difference() 
    {
        box_base(dimensions, wall_w, r_round);

        // power cable
        translate(v = [power_cable_center[0], power_cable_center[1], -epsilon]) 
        cylinder(h = hole_width, d = cable_diam);

        // wall support x3
        translate([-epsilon, dimensions[1]/2 + wall_attach_dim[1]/4, dimensions[2]-wall_small_diam-wall_attach_dim[1]-wall_w-extra])
        union()
        {
            translate([(hole_width)/2, 0, (wall_small_diam + wall_attach_dim[1] + extra)/2])
            cube([hole_width, wall_small_diam, wall_small_diam + wall_attach_dim[1] + extra], center = true);
        
            translate([(hole_width)/2, 0, (wall_attach_dim[1])/2])
            cube([hole_width, wall_attach_dim[0], wall_attach_dim[1]], center = true);
        }

        translate([-epsilon, dimensions[1]/8 + wall_attach_dim[1]/4, dimensions[2]-wall_small_diam-wall_attach_dim[1]-wall_w-extra])
        union()
        {
            translate([(hole_width)/2, 0, (wall_small_diam + wall_attach_dim[1] + extra)/2])
            cube([hole_width, wall_small_diam, wall_small_diam + wall_attach_dim[1] + extra], center = true);
        
            translate([(hole_width)/2, 0, (wall_attach_dim[1])/2])
            cube([hole_width, wall_attach_dim[0], wall_attach_dim[1]], center = true);
        }

        translate([-epsilon, dimensions[1]*7/8 + wall_attach_dim[1]/4, dimensions[2]-wall_small_diam-wall_attach_dim[1]-wall_w-extra])
        union()
        {
            translate([(hole_width)/2, 0, (wall_small_diam + wall_attach_dim[1] + extra)/2])
            cube([hole_width, wall_small_diam, wall_small_diam + wall_attach_dim[1] + extra], center = true);
        
            translate([(hole_width)/2, 0, (wall_attach_dim[1])/2])
            cube([hole_width, wall_attach_dim[0], wall_attach_dim[1]], center = true);
        }
        
        // cable holes upper layer
        cable_hole_width = wall_w*3 + epsilon*4;
        cable_hole_diam = 4;
        translate([cable_hole_diam/3, wall_w*13, -cable_hole_width + epsilon *4])
        union()
        {
            translate(v = [0,0,dimensions[2]-epsilon]) 
            cylinder(h = cable_hole_width, d = cable_hole_diam, $fn = fn);
            translate(v = [0,cable_hole_diam+2,dimensions[2]-epsilon]) 
            cylinder(h = cable_hole_width, d = cable_hole_diam, $fn = fn);
            translate(v = [0,cable_hole_diam*2+4,dimensions[2]-epsilon]) 
            cylinder(h = cable_hole_width, d = cable_hole_diam, $fn = fn);
        }

        // dht22 slot
        translate(v = [dht22_position[0], dht22_position[1], -epsilon]) 
        cube([dht22_slot[0], dht22_slot[1], hole_width]);
    }

}

module elec_box_lid(dimensions, wall_w, r_doung)
{
    // LED reduction position
    led_position = [29, 7]; // minus half radious!!
    led_diam = 5; // extra margin

    hole_width = wall_w*2 + epsilon*4;
    hole_diam = 4;
    difference() 
    {
        box_lid(dimensions, wall_w, r_doung);

        translate(v = [dimensions[0]-epsilon,led_position[0]-dimensions[1]/2,led_position[1]]) 
        rotate([0,90,0])
        cylinder(h = wall_w*1,2+epsilon, d = led_diam, $fn = fn);

        // cable holes upper layer
        translate([0, -dimensions[1]/2 + wall_w*13, 0])
        union()
        {
            translate(v = [0,0,dimensions[2]-epsilon]) 
            cylinder(h = hole_width, d = hole_diam, $fn = fn);
            translate(v = [0,hole_diam+2,dimensions[2]-epsilon]) 
            cylinder(h = hole_width, d = hole_diam, $fn = fn);
            translate(v = [0,hole_diam*2+4,dimensions[2]-epsilon]) 
            cylinder(h = hole_width, d = hole_diam, $fn = fn);
        }
    }
}

if (export == "DL")
{
    // box_lid(external_lid_size);
    color("Indigo")
    elec_box_lid(elechtronics_size, wall_width, rounding);
}
else if (export == "DB")
{   
    color("Purple")
    elec_box_base(elechtronics_size, wall_width, rounding);
}
else if (export == "AS")
{    
    color("Purple")
    elec_box_base(elechtronics_size, wall_width, rounding);

    color("Indigo")
    translate(v = [elechtronics_size[0], -elechtronics_size[1]/2 - 10 , 0]) 
    rotate([0,0,180])
    elec_box_lid(elechtronics_size, wall_width, rounding);
}
else
{
}