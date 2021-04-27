include <./../../utils/filleted_cylinder.scad>
include <./../../utils/filleted_rectangle.scad>

/* [Model param] */

cutting_side = 24;

internal_diameter = 89;

external_diameter = internal_diameter + 19;

height = 50;

rounding = 4;

metric = 5;

// $fn resolution
fn = 150;


module half()
{
    difference()
    {
        intersection()
        {
            difference()
            {
                fillete_cylinder(external_diameter, height/2, rounding);
                translate([0,0,-0.1]) cylinder(d = internal_diameter, h = height/2+0.2, $fn = fn);
            }

            cube_side = external_diameter;
            translate([-cube_side/2,0,0])
            filleted_rectangle(cube_side,cube_side,height/2+0.2, rounding);
        }

        cutting_length = 4;
        translate([-cutting_side/2,external_diameter/2-cutting_length,-0.2])
        cube([cutting_side,cutting_length+0.1,height+0.2]);

        translate([0,external_diameter/2+0.2,0])
        rotate ([90,0,0])
        cylinder(d = metric, h = external_diameter - internal_diameter + 0.2, $fn = fn);
    }
}

union()
{
    translate([0,0,-0.05])
    half();
    rotate([180,0,180])
    translate([0,0,0.05])
    half();
}