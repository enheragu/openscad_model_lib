


/* [Box Info] */

// Width of printed wall. Take into account that in the insertion this will be half of the value inserted (mm)
wall_width = 3; // 0.1

// Box length (mm)
box_length = 40;

// Box height (mm)
box_height = 40; // 0.1

// Box width (mm)
box_width = 53; // 0.

// Insertion length (mm). Insertion between both parts
insertion = 6;

// Inclination between both parts (degrees)
inclination = 15;

// Parameter to change the size of the lid and base (divides the total height between both of them based on this param). Check that both of the sides have enough space for the insertion to be printed.
base_lid_relation = 0.75;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

/* [Other] */

export = "N"; //[L:Lid, B:Base, A:Assembly, N:None]
// $fn resolution
fn = 150;


module filleted_rectangle(size_x,size_y,size_z, round_rad)
{
    hull()
    {   
        linear_extrude(height = size_z) translate([round_rad,round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([size_x-round_rad,round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([round_rad,size_y-round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([size_x-round_rad,size_y-round_rad,0]) circle(d= round_rad*2, $fn = fn);
    }
}

rotation = inclination; // atan2(insertion*3, box_length);

// Tolerance expands the insertion part
module box_base(box_width_in, box_length_in, box_height_in, wall_width_in, tolerance_in = 0.0)
{
    difference()
    {
        union()
        {
            // Base box
            difference()
            {   
                translate([-tolerance_in,-tolerance_in,-tolerance_in])
                filleted_rectangle(box_width_in+tolerance_in*2, box_length_in+tolerance_in*2, box_height_in+tolerance_in*2, box_length_in/10);

                rotate([0,rotation,0])
                translate([-wall_width_in*200,-wall_width_in*200, box_height_in*base_lid_relation])
                cube([box_width_in*300, box_length_in*300, box_height_in*200]);
            }

            // Insertion extension
            difference()
            {
                insertion_x = box_width_in - wall_width_in + tolerance_in*2; // Half wall width for each side
                insertion_y = box_length_in - wall_width_in + tolerance_in*2; // Half wall width for each side
                insertion_z = box_height_in;

                translate([wall_width_in/2 - tolerance_in, wall_width_in/2 - tolerance_in])
                filleted_rectangle(insertion_x, insertion_y, insertion_z, box_length_in/10);

                rotate([0,rotation,0])
                translate([-wall_width_in*200,-wall_width_in*200, box_height_in*base_lid_relation+insertion])
                cube([box_width_in*300, box_length_in*300, box_height_in*200]);
            }
        }

        // Empty innner of the box
        inner_x = box_width_in - wall_width_in*2 - tolerance_in*2;
        inner_y = box_length_in - wall_width_in*2 - tolerance_in*2;
        inner_z = box_height_in;
        translate([wall_width_in + tolerance_in, wall_width_in + tolerance_in, wall_width_in])
        filleted_rectangle(inner_x, inner_y, box_height_in, inner_y/10);
    }
    
}

module box_lid(box_width_in, box_length_in, box_height_in, wall_width_in, tolerance_in)
{
    difference()
    {
        // Base box
        difference()
        {
            filleted_rectangle(box_width_in, box_length_in, box_height_in, box_length_in/10);

            translate([box_width_in,0,box_height_in])
            rotate([180,0,180])
            box_base(box_width_in, box_length_in, box_height_in, wall_width_in, tolerance_in);
        }

        // Empty innner of the box
        inner_x = box_width_in - wall_width_in*2;
        inner_y = box_length_in - wall_width_in*2;
        inner_z = box_height_in;
        translate([wall_width_in, wall_width_in, wall_width_in])
        filleted_rectangle(inner_x, inner_y, box_height_in, inner_y/10);
    }
}


if (export == "L")
{
    translate([box_width,0,box_height])
    rotate([180,0,180])
    box_lid(box_width, box_length, box_height, wall_width, tolerance);
}
else if (export == "B")
{
    box_base(box_width, box_length, box_height, wall_width, 0);
}
else if (export == "A")
{
    // Display assembly
    color("red", 1)
    // translate([box_width,0,box_height])
    // rotate([180,0,180])
    translate([0,10+box_length,0])
    box_lid(box_width, box_length, box_height, wall_width, tolerance);

    color("orange", 1) box_base(box_width, box_length, box_height, wall_width, 0);
}
else
{

}

// Reference as bounding box
//color("black", 0.1) filleted_rectangle(box_width, box_length, box_height, box_length/10);