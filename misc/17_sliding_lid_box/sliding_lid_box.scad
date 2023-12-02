/* [Box Info] */

// Width of printed wall. Take into account that in the insertion this will be half of the value inserted (mm)
wall_width = 2; // 0.1

// Box length (inner space) (mm)
in_box_length = 55;

// Box height (inner space) (mm)
in_box_height = 70; // 0.1

// Box width (inner space) (mm)
in_box_width = 30; // 0.

// Rounding radius (mm)
rounding = 5;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

/* [Other] */

// Small cuantity to ensure cutting though
epsilon = 0.1;

// Exporting options
export = "L"; //[L:Lid, B:Base, A:Assembly, N:None]

// $fn resolution
fn = 80;




module rounded_cylinder(h,r)
{
    // translate(v = [rounding,rounding,0]) 
    union()
    {
        sphere(r = r, $fn = fn);
        translate([0,0,-h+r])
        cylinder(h = h-r, r = r, $fn = fn);
    }
}

module circled_square(x,y,z,r)
{
    linear_extrude(z)
    {
        hull()
        {
            square([x-r,y]);
            translate([x-r,r])
            circle(r, $fn = fn);
            translate([x-r,y-r])
            circle(r, $fn = fn);
        }
    }
}

module rounded_shape(dimensions, r_round)
{
    translate([dimensions[0]-rounding, dimensions[1]-rounding, dimensions[2]-rounding])
    rotate([0,0,180])
    hull()
    {
        translate(v = [0,-r_round,-dimensions[2]+r_round]) 
        cube(size = [dimensions[0]-r_round, dimensions[1], dimensions[2]-r_round]);
        
        translate([0,dimensions[1]-r_round*2,0])
        rounded_cylinder(dimensions[2],r_round);    
        rounded_cylinder(dimensions[2],r_round);

        rotate([0,-90,0])
        union()
        {
            translate([0,dimensions[1]-r_round*2,0])
            rounded_cylinder(dimensions[0],r_round);    
            rounded_cylinder(dimensions[0],r_round);
        }
        
    }
}


module box_base(dimensions, wall_w, r_round)
{
    circled_square(dimensions[0],dimensions[1]+wall_w*2,wall_w,r_round);
    translate([wall_w,0,0])
    rotate([0,-90,0])
    circled_square(dimensions[2],dimensions[1]+wall_w*2,wall_w,r_round);

    // need sliding parts to attach lid later
    union()
    {
        cube([dimensions[0]/2, wall_w, dimensions[2]*3/4]);
        translate(v = [dimensions[0]/2-wall_w, 0, 0]) 
        rotate([0,0,45])
        translate([0,0,dimensions[2]*3/4/2])
        cube([wall_w, wall_w, dimensions[2]*3/4], center = true);
    }

    translate(v = [0,dimensions[1]+wall_w,0]) 
    union()
    {
        cube([dimensions[0]/2, wall_w, dimensions[2]*3/4]);
        translate(v = [dimensions[0]/2-wall_w, wall_w, 0]) 
        rotate([0,0,45])
        translate([0,0,dimensions[2]*3/4/2])
        cube([wall_w, wall_w, dimensions[2]*3/4], center = true);
    }
}

module box_base_negative(dimensions_in, wall_w, r_round)
{
    dimensions = [dimensions_in[0] + tolerance*2 + epsilon,  
                  dimensions_in[1] +wall_w*2 + tolerance*2, 
                  dimensions_in[2] + tolerance*2 + epsilon];

    // box_base(dimensions, wall_w, r_round);
    translate([-epsilon,-dimensions[1]/2,-epsilon])
    union()
    {
        intersection()
        {
            circled_square(dimensions[0],dimensions[1],dimensions[2],r_round);
            translate([dimensions[0],0,0])
            rotate([0,-90,0])
            circled_square(dimensions[2],dimensions[1],dimensions[0],r_round);
        }
        union()
        {
            cube([dimensions[0]/2, wall_w, dimensions[2]*3/4]);
            translate(v = [dimensions[0]/2-wall_w, 0, 0]) 
            rotate([0,0,45])
            translate([0,0,dimensions[2]*3/4/2])
            cube([wall_w + tolerance*2, wall_w + tolerance*2, dimensions[2]*3/4], center = true);
        }

        translate(v = [0,dimensions[1]-wall_w,0]) 
        union()
        {
            cube([dimensions[0]/2, wall_w, dimensions[2]*3/4]);
            translate(v = [dimensions[0]/2-wall_w, wall_w, 0]) 
            rotate([0,0,45])
            translate([0,0,dimensions[2]*3/4/2])
            cube([wall_w, wall_w, dimensions[2]*3/4], center = true);
        }
    }

}

module box_lid(dimensions, wall_w, r_doung)
{
    external_box_size = [dimensions[0] + wall_w + tolerance*2, 
                         dimensions[1] + wall_w*5 + tolerance*2, 
                         dimensions[2] + wall_w + tolerance*2];
    
    difference()
    {
        translate([0,-external_box_size[1]/2,0])
        rounded_shape(external_box_size, r_doung);

        box_base_negative(dimensions, wall_w, r_doung);
    }
}


// external_lid_size = []
internal_box_size = [in_box_width, in_box_length, in_box_height];

if (export == "L")
{
    // box_lid(external_lid_size);
    box_lid(internal_box_size, wall_width, rounding);
}
else if (export == "B")
{   
    box_base(internal_box_size, wall_width, rounding);
}
else if (export == "A")
{    
    color("Purple")
    box_base(internal_box_size, wall_width, rounding);

    color("Indigo")
    translate(v = [internal_box_size[0], -internal_box_size[1]/2 - 10 , 0]) 
    rotate([0,0,180])
    box_lid(internal_box_size, wall_width, rounding);
}
else
{
}