include <./sliding_lid_box.scad>

/* [Box Info] */

// Dice side in mm
elechtronics_size = [50, 82, 80 + wall_width *3]; 
// exrta margin for wall attatchment

// hole for power cable
power_cable_center = [8, 8];
cable_diam = 11;
/* [Other] */

export = "AS"; //[DL:Lid, DB:Base, AS:Assembly, DN:None]
// $fn resolution
fn = 80;

module elec_box_base(dimensions, wall_w, r_round)
{

    // Wall support
    wall_attach_dim = [7, 7];
    wall_small_diam = 4;
    extra = 2;

    // DHT11 hole
    dht22_position = [23, 10];
    dht22_slot = [8.5, 16.5];

    hole_width = wall_w + epsilon*4;
    difference() 
    {
        box_base(dimensions, wall_w, r_round);
        
        // power cable
        translate(v = [power_cable_center[0], dimensions[1] + wall_width*3, power_cable_center[1]]) 
        rotate([90,0,0])
        cylinder(h = hole_width*3, d = cable_diam, $fn = fn);

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
        cable_hole_width = wall_w*4 + epsilon*4;
        cable_hole_diam = 7;
        translate([-epsilon, wall_w*11, -cable_hole_width + epsilon *4])
        translate(v = [0,0,dimensions[2]-epsilon]) 
        cube(size = [wall_width+epsilon*2, cable_hole_width, cable_hole_width]);

        // dht22 slot
        translate(v = [dht22_position[0], dht22_position[1], -epsilon]) 
        cube([dht22_slot[0], dht22_slot[1], hole_width]);


        // Slots to fix calbes
        slot_width = 2;
        translate(v = [-epsilon,dimensions[1]/5,dimensions[2]/6]) 
        cube(size = [wall_width+epsilon*2, slot_width, dimensions[2]/2]);
        translate(v = [-epsilon,dimensions[1]/5+2+slot_width,dimensions[2]/6]) 
        cube(size = [wall_width+epsilon*2, slot_width, dimensions[2]/2]);

        translate(v = [-epsilon,dimensions[1]*4/5,dimensions[2]/6]) 
        cube(size = [wall_width+epsilon*2, slot_width, dimensions[2]/2]);
        translate(v = [-epsilon,dimensions[1]*4/5-2-slot_width,dimensions[2]/6]) 
        cube(size = [wall_width+epsilon*2, slot_width, dimensions[2]/2]);
        
        translate(v = [-epsilon,dimensions[1]*2.5/5 +1 + slot_width/2,dimensions[2]/6]) 
        cube(size = [wall_width+epsilon*2, slot_width, dimensions[2]/2]);
        translate(v = [-epsilon,dimensions[1]*2.5/5-1-slot_width/2,dimensions[2]/6]) 
        cube(size = [wall_width+epsilon*2, slot_width, dimensions[2]/2]);
    }
        

}

module elec_box_lid(dimensions, wall_w, r_doung)
{
    difference() 
    {
        translate([0, wall_width*2 + tolerance*3 + epsilon*2 + dimensions[1]/2, 0])
        box_lid(dimensions, wall_w, r_doung);


        // cable holes upper layer
        cable_hole_width = wall_w*4 + epsilon*4;
        cable_hole_diam = 7;
        translate([-epsilon, wall_w*11, 0])
        translate(v = [0,0,dimensions[2]-epsilon]) 
        cube(size = [wall_width+epsilon*2, cable_hole_width, cable_hole_width]);

        // power cable
        translate(v = [power_cable_center[0], dimensions[1] + wall_width*7, power_cable_center[1]]) 
        rotate([90,0,0])
        cylinder(h = wall_width*5, d = cable_diam, $fn = fn);
        translate(v = [power_cable_center[0], dimensions[1] + wall_width*5, power_cable_center[1]/2-epsilon*4]) 
        cube(size = [cable_diam, wall_width*5, power_cable_center[1]+epsilon*4], center=true);
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
    translate(v = [elechtronics_size[0], - 10 , 0]) 
    rotate([0,0,180])
    elec_box_lid(elechtronics_size, wall_width, rounding);
}
else
{
}