
include <./../../utils/filleted_rectangle.scad>

/* [Holder Info] */

// Height of the piece (mm)
magnet_height = 4;

// Width of the piece (mm)
magnet_width = 9.5;

// Full length of piece (mm)
magnet_length = 59.4;

// Space below magnet
spacer_height = 8.6;

// corner round diameter (mm)
rounding = 3;

// Width of printed wall (mm)
wall_width = 4;

// tube diameter (mm) used in the vertical version
tube_diameter = 25.89;

/* [Mechanical parts] */

// Diameter of the hole (metric?) (mm)
screw_hole_diam = 3.85;

// Diameter of the screw head (mm)
screw_head_diam = 7.16;

screw_head_heigth = 2.6;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.5;

/* [Other] */
// $fn resolution
fn = 150;

module screw_hole(z, screw_heitght = wall_width)
{
    diameter_head = screw_head_diam+tolerance*2;
    union()
    {
        cylinder(d = screw_hole_diam+tolerance*2, h = z, $fn = fn);
        translate([0,0,screw_heitght])
        cylinder(d = diameter_head, h = z, $fn = fn);
    }
}

module horizontal_holder()
{
    mag_x = magnet_width + tolerance;
    mag_y = magnet_length + tolerance;
    mag_z = magnet_height;

    x = mag_x + wall_width*2;
    y = mag_y + wall_width*2;
    z = spacer_height + mag_z;

    difference()
    {
        filleted_rectangle(x,y,z,rounding);  
        // space for magnet
        translate([x/2-mag_x/2,y/2-mag_y/2,spacer_height])
        cube([mag_x, mag_y, mag_z+0.1]);

        
        // space for screws
        diameter_head = screw_head_diam+tolerance*2;
        translate([x/2,y/4,-0.1]) screw_hole(z);
        translate([x/2,3*y/4,-0.1]) screw_hole(z);
    }
}

module vertical_holder()
{
    // Note that is later rotated :)
    mag_x = magnet_width + tolerance;
    mag_y = magnet_length + tolerance;
    mag_z = magnet_height;

    magnet_displacement_z = spacer_height + mag_z*2 + tube_diameter/2;

    x = mag_x + wall_width*2;
    y = mag_y + wall_width*2;
    z = magnet_displacement_z + mag_x/2 + wall_width;
    
    difference()
    {
        filleted_rectangle(x,y,z,rounding);  
        
        // space for magnet
        translate([x-mag_z/2,y/2,magnet_displacement_z])
        rotate([0,90,0])
        cube([mag_x, mag_y, mag_z+0.1], center = true);

        // space for screws
        diameter_head = screw_head_diam+tolerance*2;
        translate([x/2,y/4,-0.1]) screw_hole(z,wall_width*3);
        translate([x/2,3*y/4,-0.1]) screw_hole(z,wall_width*3);
    }
}

vertical_holder();