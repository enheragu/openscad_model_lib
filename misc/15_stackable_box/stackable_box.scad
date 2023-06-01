


/* [Box Info] */

// Width of printed wall. Take into account that in the insertion this will be half of the value inserted (mm)
wall_width = 3; // 0.1

// Box length (inner space) (mm)
box_length = 40;

// Box height (inner space) (mm)
box_height = 40; // 0.1

// Box width (inner space) (mm)
box_width = 53; // 0.

// Insertion length (mm). Insertion between both parts
insertion = 2;


/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

/* [Other] */

export = "N"; //[L:Lid, I:Intermediate box, B:Base, A:Assembly, N:None]
// $fn resolution
fn = 150;


module filleted_rectangle(size_x, size_y, size_z, round_rad)
{
    hull()
    {   
        linear_extrude(height = size_z) translate([round_rad,round_rad,0])  circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([size_x-round_rad,round_rad,0])  circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([round_rad,size_y-round_rad,0])  circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([size_x-round_rad,size_y-round_rad,0])  circle(d= round_rad*2, $fn = fn);
    }
}


// Tolerance expands the insertion part
module box_base(box_width_in, box_length_in, box_height_in, wall_width_in, tolerance_in = 0.0)
{
    difference()
    {
        union()
        {
            // Base box minus insertion  
            box_x = box_width_in + wall_width_in*2 + tolerance_in*2; // Half wall width for each side
            box_y = box_length_in + wall_width_in*2 + tolerance_in*2; // Half wall width for each side
            box_z = box_height_in - insertion + wall_width;

            filleted_rectangle(box_x, box_y, box_z, box_length_in/10);

            // Insertion extension
            insertion_x = box_width_in + wall_width_in + tolerance_in*2; // Half wall width for each side
            insertion_y = box_length_in + wall_width_in + tolerance_in*2; // Half wall width for each side
            insertion_z = box_height_in + tolerance_in + wall_width;

            translate([wall_width_in/2 - tolerance_in, wall_width_in/2 - tolerance_in])
            filleted_rectangle(insertion_x, insertion_y, insertion_z, box_length_in/10);
        }   

        // Empty innner of the box
        inner_x = box_width_in + tolerance_in*2;
        inner_y = box_length_in + tolerance_in*2;
        inner_z = box_height_in + wall_width;
        translate([wall_width_in - tolerance_in, wall_width_in - tolerance_in, wall_width_in])
        filleted_rectangle(inner_x, inner_y, inner_z, box_length_in/10);
    }
    
}

module box_lid(box_width_in, box_length_in, box_height_in, wall_width_in, tolerance_in = 0.0)
{
    // Base box
    difference()
    {
        lid_x = box_width_in + wall_width_in*2 + tolerance_in*2; // Half wall width for each side
        lid_y = box_length_in + wall_width_in*2 + tolerance_in*2; // Half wall width for each side
        lid_z = wall_width_in + insertion + tolerance_in;

        filleted_rectangle(lid_x, lid_y, lid_z, box_length_in/10);
        
        insertion_x = box_width_in + wall_width_in + tolerance_in*2; // Half wall width for each side
        insertion_y = box_length_in + wall_width_in + tolerance_in*2; // Half wall width for each side
        insertion_z = box_height_in + tolerance_in*2;

        translate([wall_width_in/2, wall_width_in/2, wall_width_in])
        filleted_rectangle(insertion_x, insertion_y, insertion_z, box_length_in/10);
    }
}


module box_intermediate(box_width_in, box_length_in, box_height_in, wall_width_in, tolerance_in = 0.0)
{
    difference()
    {
        box_base(box_width_in, box_length_in, box_height_in, wall_width_in, tolerance_in);
        
        insertion_x = box_width_in + wall_width_in + tolerance_in*2; // Half wall width for each side
        insertion_y = box_length_in + wall_width_in + tolerance_in*2; // Half wall width for each side
        insertion_z = insertion + tolerance_in*2;

        translate([wall_width_in/2, wall_width_in/2, -tolerance_in])
        filleted_rectangle(insertion_x, insertion_y, insertion_z, box_length_in/10);
    }
}


if (export == "L")
{
    // translate([box_width,0,box_height])
    // rotate([180,0,180])
    box_lid(box_width, box_length, box_height, wall_width, tolerance);
}
else if (export == "I")
{
    box_intermediate(box_width, box_length, box_height, wall_width, tolerance);       
}
else if (export == "B")
{
    box_base(box_width, box_length, box_height, wall_width, tolerance);
}
else if (export == "A")
{
    // Display assembly
    color("red", 0.5)
    translate([box_width+wall_width*2+tolerance*2,0,box_height*2+wall_width - insertion])
    rotate([180,0,180])
    box_lid(box_width, box_length, box_height, wall_width, tolerance);

    translate([0,0,box_height-insertion])
    color("green", 0.5) box_intermediate(box_width, box_length, box_height, wall_width, tolerance);
    color("grey", 0.5) box_base(box_width, box_length, box_height, wall_width, tolerance);
}
else
{

}

// Reference as bounding box
//color("black", 0.1) filleted_rectangle(box_width, box_length, box_height, box_length/10);