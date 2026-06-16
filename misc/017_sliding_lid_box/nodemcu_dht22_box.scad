include <./sliding_lid_box.scad>

/* [Box Info] */

// Dice side in mm
elechtronics_size = [27, 32, 58+wall_width*2+tolerance*2]; 
// exrta margin for wall attatchment

/* [Other] */

export = "AS"; //[DL:Lid, DB:Base, B:Both, BAS:Box assembly, AS:Assembly, DN:None]
// $fn resolution
fn = 80;


// DHT22 model from kolergy https://www.thingiverse.com/thing:3262663/files
q=4;

module rcube(siz, rad) {
    xi = max(0,siz[0]/2-rad);
    yi = max(0,siz[1]/2-rad);
    hi =  siz[2];

    hull() {
        translate([ xi, yi,0]) cylinder(r=rad,h=hi, center=true, $fn=10*q);
        translate([-xi, yi,0]) cylinder(r=rad,h=hi, center=true, $fn=10*q);
        translate([ xi,-yi,0]) cylinder(r=rad,h=hi, center=true, $fn=10*q);
        translate([-xi,-yi,0]) cylinder(r=rad,h=hi, center=true, $fn=10*q);
  }
}

module DHT22() {
    difference() {
        color([0.99,0.99,0.99]) union(){
            rcube([15.4,20.2,8],0.5);
            hull() {
                translate([ 7.2, -9.6,-4]) cylinder(d=1,h=1.5,$fn=5*q);
                translate([-7.2, -9.6,-4]) cylinder(d=1,h=1.5,$fn=5*q);
                translate([ 4.5,-14.5,-4]) cylinder(d=2,h=1.5,$fn=5*q);
                translate([-4.5,-14.5,-4]) cylinder(d=2,h=1.5,$fn=5*q);
            }
        }
        translate([ 0.0,-13,-4]) cylinder(d=2.5,h=10,center=true, $fn=5*q);
        for(i = [1:5]) {
            translate([ 0  , -9+2.5*i,4]) cube([1.25,1.25,6], center=true);
            translate([ 2.5, -9+2.5*i,4]) cube([1.25,1.25,6], center=true);
            translate([-2.5, -9+2.5*i,4]) cube([1.25,1.25,6], center=true);
            translate([ 6  , -9+2.5*i,4]) cube([3.1,1.25,6], center=true);
            translate([-6  , -9+2.5*i,4]) cube([3.1,1.25,6], center=true);
        }
            translate([ 0  , -10,4]) cube([1.25,3,6], center=true);
            translate([ 2.5, -10,4]) cube([1.25,3,6], center=true);
            translate([-2.5, -10,4]) cube([1.25,3,6], center=true);           
    }
    color("Grey"     ) for(i = [1:4]) {
        translate([ 6-2.5*i  , 10,-1.5]) cube([0.5,7.5,0.3]);
    }
}


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
else if (export == "B")
{    
    color("Purple")
    elec_box_base(elechtronics_size, wall_width, rounding);

    color("Indigo")
    translate(v = [elechtronics_size[0], -elechtronics_size[1]/2 - 10 , 0]) 
    rotate([0,0,180])
    elec_box_lid(elechtronics_size, wall_width, rounding);
}
else if (export == "AS")
{    
    color("Purple")
    elec_box_base(elechtronics_size, wall_width, rounding);
    translate(v = [0, elechtronics_size[1]/2 + wall_width, 0]) 
    elec_box_lid(elechtronics_size, wall_width, rounding);
    
    translate([35,elechtronics_size[1]/2 + wall_width,elechtronics_size[2]/2])
    rotate([0,-180,90])
    DHT22();
}
else if (export == "BAS")
{    
    color("Purple")
    elec_box_base(elechtronics_size, wall_width, rounding);
    translate(v = [0, elechtronics_size[1]/2 + wall_width, 0]) 
    elec_box_lid(elechtronics_size, wall_width, rounding);
}
else 
{
    DHT22();
    
}