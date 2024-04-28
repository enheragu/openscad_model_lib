/* [Slide/Box Info] */

// Width of printed wall. Take into account that in the insertion this will be half of the value inserted (mm)
wall_width = 3; // 0.1

// Sice of the remote (depth, width and height (mm)
slide_size = [100,130, 2];

// Rounding radius (mm)
rounding = 5;

// Size of tag in each slide (mm)
tag_size = [26,21.67];

// How many slots for slides has the box
slides_in_box = 5;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

/* [Other] */

// Small cuantity to ensure cutting though
epsilon = 0.1;

// $fn resolution
fn = 100;



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

module circled_square(dimensions,r)
{
    x = dimensions[0];
    y = dimensions[1];
    z = dimensions[2];
    linear_extrude(z)
    {
        hull()
        {
            translate([r,r])
            circle(r, $fn = fn);
            translate([r,y-r])
            circle(r, $fn = fn);
            translate([r,r])
            square([x-2*r,y-2*r]);
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


// rounded_shape([40,40,30],5);

module slide_base(tag_index = 0, tag_text = "")
{
    tag_text = str(tag_index+1);
    difference() 
    {   
        union()
        {
            translate(v = [-tag_size[0]+rounding*2,tag_index*tag_size[1],0]) 
            circled_square(dimensions = [tag_size[0],tag_size[1],slide_size[2]], r = rounding);
            circled_square(dimensions = slide_size, r = rounding);
        }
        size_hole = [slide_size[0] - wall_width*2,slide_size[1] - wall_width*2,slide_size[2] + epsilon*2];
        translate(v = [wall_width, wall_width,-epsilon]) 
        circled_square(dimensions = size_hole, r = rounding);

        translate(v = [-tag_size[0]/3,tag_index*tag_size[1]+tag_size[1]/2,-epsilon]) 
        rotate([0,0,90])
        linear_extrude(slide_size[2] + epsilon*2)
        text(tag_text, size=10, halign="center", valign="center");
    }
}

module slide_negative()
{   
    dimensions = [slide_size[0]*2 + tolerance*2, slide_size[1] + tolerance*2, slide_size[2] + tolerance*2];
    translate(v = [-slide_size[0],0,0]) 
    circled_square(dimensions, rounding);
}


module box() {

    n_slides = slides_in_box-1; //iter
    difference() 
    {
        // slide_base(tag_text = tag, tag_index=tag_index);
        box_size = [slide_size[0]+wall_width*2+tolerance*2,
                    slide_size[1]+wall_width*2+tolerance*2,
                    (slide_size[2]+wall_width+tolerance*2)*n_slides+wall_width*2];
        
        translate(v = [0,0,-wall_width]) 
        circled_square(box_size, rounding);
        
        size_hole = [slide_size[0] - wall_width*2,slide_size[1] - wall_width*2,box_size[2] + epsilon*2];
        translate(v = [wall_width*2+tolerance*2, wall_width*2+tolerance*2,-epsilon]) 
        circled_square(dimensions = size_hole, r = rounding);

        translate(v = [wall_width+tolerance, wall_width+tolerance,0]) 
        for(index = [0:n_slides])
        {
            translate(v = [0,0,(wall_width+slide_size[2]+tolerance)*index])
            slide_negative();
        }
    }  
}


color("Indigo")
translate(v = [wall_width+tolerance,wall_width+tolerance,0]) 
slide_base(tag_index = 0);

color("Purple")
translate(v = [wall_width+tolerance,wall_width+tolerance,(wall_width+slide_size[2]+tolerance)*2]) 
slide_base(tag_index = 2);

color("PowderBlue", 1) 
translate(v = [wall_width+tolerance,wall_width+tolerance,(wall_width+slide_size[2]+tolerance)*4]) 
slide_base(tag_index = 4);


color("CadetBlue", 1)
box();

// Animation
// if ($t < 0.6)
// {
//     tag_index = ($t*10);
//     tag = str(tag_index+1);
//     color("Indigo")
//     slide_base(tag_text = tag, tag_index=tag_index);
// }
// else
// {
//     tag_index = 0;
//     tag = str(tag_index+1);
//     color("Indigo")
//     slide_base(tag_text = tag, tag_index=tag_index);
// }