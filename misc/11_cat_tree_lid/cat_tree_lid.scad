include <./../../utils/filleted_cylinder.scad>

/* [Tube settings] */
outer_diameter = 75;

inner_diameter = 69;

wall_width = 4;

insert_length = 26;

/* [Mechanical/extra parts] */

// Nut and head screw (both hexagonal) circunscribed circunference diameter (mm)
head_nut_diam = 14.6;

head_nut_heigth = 7;

screw_metric_diam = 7.8;

rope_diam_width = 7;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.5;

/* [Other] */
// $fn resolution
fn = 150;

module base_obj()
{
    union()
    {
        fillete_cylinder(outer_diameter, wall_width, wall_width/2);

        translate([0,0,0.1])
        difference()
        {
            rotate([180,0,0])
            fillete_cylinder(inner_diameter, insert_length, wall_width/2);

            translate([0,0,-wall_width])
            rotate([180,0,0])
            cylinder(d = inner_diameter-wall_width, h = insert_length+0.1, $fn = fn);
        }
    }
}


difference()
{
    union()
    {
        base_obj();
        // screw/nut support
        translate([0,0,-wall_width+0.2])
        rotate([180,0,0])
        difference()
        {
            cylinder(d = head_nut_diam+wall_width*2, h = head_nut_heigth, $fn = 6);
            translate([0,0,-0.1])
            cylinder(d = head_nut_diam+tolerance, h = head_nut_heigth+0.2, $fn = 6);
        }
    }
    
    rotate([180,0,0])
    translate([0,0,-wall_width-0.1])
    cylinder(d = screw_metric_diam+tolerance, h = wall_width*2+0.2, $fn = fn);

    hole_heigth = insert_length+wall_width;
    hole_width = rope_diam_width+tolerance*3;
    translate([0,-hole_width/2,-hole_heigth+tolerance*2])
    cube([outer_diameter+wall_width*2,hole_width,hole_heigth]);
}