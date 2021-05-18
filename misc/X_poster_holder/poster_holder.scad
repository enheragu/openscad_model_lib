

/* [Holder Info] */


// Height of the piece (mm)
height = 30;

// Width of the piece (mm)
width = 19.5;

// Full length of piece (mm)
length = 30;

// corner round diameter (mm)
rounding = 3;

// cable diameter (mm)
cable_diameter = 4;

// Width of printed wall (mm)
wall_width = 4;

// width of slot for poster (mm)
poster_slot = 2;

/* [Mechanical parts] */

// Diameter of the hole (metric?) (mm)
screw_hole_diam = 3.85;

// Diameter of the screw head (mm)
screw_head_diam = 7.16;

screw_head_heigth = 2.6;

// Nut circunscribed circunference diameter (mm)
nut_diam = 7.88;

// nut height
nut_height = 3.07;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.5;

/* [Other] */
// $fn resolution
fn = 150;

module base()
{
    // Hole for cable
    difference()
    {
        // Base piece
        hull()
        {
            linear_extrude(height = height) translate([0,0,0]) circle(d= width, $fn = fn);
            linear_extrude(height = height) translate([length-rounding,-width/2+rounding,0]) circle(d= rounding*2, $fn = fn);
            linear_extrude(height = height) translate([length-rounding,width/2-rounding,0]) circle(d= rounding*2, $fn = fn);
        }
        linear_extrude(height = height+0.2) translate([0,0,-0.1]) circle(d= cable_diameter + tolerance, $fn = fn);
    }
}

//Screw/Nut holes
module scre_nut_hole()
{
    rotate([90,0,0])
    translate([0,0,-width/2])
    union()
    {
        translate([0,0,-0.1])
        cylinder(d = nut_diam+tolerance*2, h = nut_height+0.1, $fn = 6);

        translate([0,0,0])
        cylinder(d = screw_hole_diam+tolerance, h = width, $fn = fn);

        translate([0,0,width-screw_head_heigth])
        cylinder(d = screw_head_diam+tolerance, h = screw_head_heigth+0.1, $fn = fn);
    }
}

difference()
{
    base();

    translate([length-rounding-screw_head_heigth-wall_width,0,screw_head_heigth+wall_width])
    scre_nut_hole();

    translate([length-rounding-screw_head_heigth-wall_width,0,height-screw_head_heigth-wall_width])
    scre_nut_hole();

    translate([cable_diameter+wall_width,-poster_slot/2,-0.1])
    cube([length,poster_slot,height+0.2]);
}