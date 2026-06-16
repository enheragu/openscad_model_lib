include <./../../utils/filleted_cylinder.scad>

/* [Tube settings] */
outer_diameter = 75;

inner_diameter = 69;

wall_width = 4;

insert_length = 56;

/* [Mechanical/extra parts] */

// Nut and head screw (both hexagonal) circunscribed circunference diameter (mm)
head_nut_diam = 9;

head_nut_heigth = 3.9;

screw_metric_diam = 4.8;

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
        fillete_cylinder(outer_diameter, wall_width*2+16, wall_width/2);

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

module basic_lid()
{
    difference()
    {
        base_obj();
        
        //rotate([180,0,0])
        translate([0,0,-16])
        cylinder(d = screw_metric_diam+tolerance, h = 16*3+wall_width*2+0.2, $fn = fn);

        hole_heigth = insert_length+wall_width;
        hole_width = rope_diam_width+tolerance*3;
        translate([wall_width + head_nut_diam/2,-hole_width/2,-hole_heigth+tolerance*2])
        cube([outer_diameter+wall_width*2,hole_width,hole_heigth]);
    }
}

// lid between modules
module upper_part()
{
    difference()
    {
        union()
        {
            basic_lid();
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


        total_heigth = wall_width*2+16;
        rail_width = 25.55;
        support_wall_width = 1.77;

        x_size = rail_width + support_wall_width*2 + tolerance*2;
        y_size = outer_diameter + 0.4;
        z_size = wall_width;
        translate([-x_size/2,-y_size/2,total_heigth - wall_width + 0.1])
        cube([x_size, y_size, wall_width]);

        rail_z_size = 14.5 + tolerance + support_wall_width;
        translate([x_size/2-support_wall_width,-y_size/2,total_heigth-rail_z_size+0.1])
        cube([support_wall_width+tolerance, y_size, rail_z_size]);
        
        translate([-x_size/2,-y_size/2,total_heigth-rail_z_size+0.1])
        cube([support_wall_width+tolerance, y_size, rail_z_size]);

    }
}

upper_part();
