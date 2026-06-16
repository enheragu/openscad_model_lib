include <./sliding_lid_box.scad>

/* [Box Info] */

// Dice side in mm
elechtronics_size = [27, 32, 64+wall_width*2+tolerance*2]; 
// exrta margin for wall attatchment

/* [Other] */

export = "AS"; //[DL:Lid, DB:Base, AS:Assembly, DN:None]
// $fn resolution
fn = 80;

module elec_box_base(dimensions, wall_w, r_round)
{
    box_base(dimensions, wall_w, r_round);
}

module elec_box_lid(dimensions, wall_w, r_doung)
{
    usb_slot = [11+tolerance,6.5+tolerance];
    usb_hole_width = wall_w*2 + epsilon*4;

    // DHT11 hole
    dht22_position = [0, 0];
    dht22_slot = [8.5, 16.5];

    hole_width = wall_w*2 + epsilon*4;
    difference() 
    {
        box_lid(dimensions, wall_w, r_doung);

        // dht22 slot
        translate(v = [dimensions[0]+wall_w-epsilon,0,dimensions[2]*1/2-6]) 
        rotate([0,90,0])
        cube([dht22_slot[0], dht22_slot[1], hole_width], center = true);
        
        // Charger slot
        translate(v = [wall_width*4,0,dimensions[2]+wall_width]) 
        rotate([0,0,90])
        cube([usb_slot[0], usb_slot[1], usb_hole_width], center = true);

        // IR slot
        translate(v = [dimensions[0]-wall_width,0,dimensions[2]+wall_width]) 
        rotate([0,0,90])
        cube([usb_slot[0]*1.2, usb_slot[1]*1.2, usb_hole_width], center = true);
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