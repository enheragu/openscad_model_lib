include <./sliding_lid_box.scad>

/* [Box Info] */

// Dice side in mm
elechtronics_size = [27, 32, 58+wall_width*2+tolerance*2]; 
// exrta margin for wall attatchment

/* [Other] */

export = "AS"; //[DL:Lid, DB:Base, AS:Assembly, DN:None]
// $fn resolution
fn = 80;

module elec_box_base(dimensions, wall_w, r_round)
{
    usb_slot = [11+tolerance,6.5+tolerance];
    hole_width = wall_w*2 + epsilon*4;

    difference()
    {
        box_base(dimensions, wall_w, r_round);

        // Charger slot
        translate(v = [wall_width*3,dimensions[1]/2+usb_slot[0]/4,0]) 
        rotate([0,0,90])
        cube([usb_slot[0], usb_slot[1], hole_width], center = true);
    }
}

module elec_box_lid(dimensions, wall_w, r_doung)
{
    // DHT11 hole
    dht22_position = [0, 0];
    dht22_slot = [8.5, 16.5];

    hole_width = wall_w*2 + epsilon*4;
    difference() 
    {
        box_lid(dimensions, wall_w, r_doung);

        // dht22 slot
        translate(v = [dimensions[0]+wall_w-epsilon,0,dimensions[2]*1/2]) 
        rotate([0,90,0])
        cube([dht22_slot[0], dht22_slot[1], hole_width], center = true);
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