
include <./../../utils/filleted_cylinder.scad>

/* [Adapter Info] */

// External diameter of the tube
ext_diameter = 40;

// Insertion length of the tube adapters
insertion_length = 27;

// Wall width
wall_width = 3;

// Diameter of the insertion adapter of the flexible tube
water_adapter_diam = 13;

tolerance = 0.5;

fn = 150;


water_adapter_offset = water_adapter_diam/2 * 2/3;

module insertion_part()
{
    difference()
    {
        sphere(d = water_adapter_diam, $fn = fn);
        translate([0, 0, -water_adapter_diam])
        cube(size=water_adapter_diam*2, center = true);
    }
}

module insertion()
{   
    difference()
    {
        union()
        {
            insertion_part();
            translate([0, 0, water_adapter_offset])
            insertion_part();
            translate([0, 0, 2*water_adapter_offset])
            insertion_part();
            translate([0, 0, 3*water_adapter_offset])
            insertion_part();
        }
        //Inner hole
        translate([0,0,-0.1])
        cylinder(d =  water_adapter_diam/2, h = water_adapter_offset*5, $fn = fn);
    }
}

module inner_adapter()
{
    union()
    {
        difference()
        {
            fillete_cylinder(ext_diameter, insertion_length, wall_width/2);
            //cylinder(d = ext_diameter, h = insertion_length, $fn = fn);
            translate([0,0,-wall_width])
            cylinder(d = ext_diameter-wall_width*2, h = insertion_length, $fn = fn);
            translate([0,0,-0.1])
            cylinder(d =  water_adapter_diam/2, h = insertion_length*2, $fn = fn);
        }
        translate([0,0,insertion_length])
        insertion();
    }
}

module outer_adapter()
{
    union()
    {
        difference()
        {
            fillete_cylinder(ext_diameter+wall_width*2+tolerance, insertion_length, wall_width/2);
            //cylinder(d = ext_diameter, h = insertion_length, $fn = fn);
            translate([0,0,-wall_width])
            cylinder(d = ext_diameter, h = insertion_length, $fn = fn);
            translate([0,0,-0.1])
            cylinder(d =  water_adapter_diam/2, h = insertion_length*2, $fn = fn);
        }
        translate([0,0,insertion_length])
        insertion();
    }
}

inner_adapter();