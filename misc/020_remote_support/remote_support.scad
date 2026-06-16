/* [Support Info] */

// Width of printed wall. Take into account that in the insertion this will be half of the value inserted (mm)
wall_width = 2; // 0.1

// Sice of the remote (depth, width and height (mm)
remote_size = [20, 40, 150];

// Rounding radius (mm)
rounding = 5;

// Screw metriz size (diam) (mm)
screw_metric = 4;

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
    extra_wall = wall_w + tolerance;

    difference() 
    {
        union()
        {
            difference()
            {
                translate([wall_w+r_round,0,0])
                rotate([0,-90,0])
                circled_square(dimensions[2]*2/3,dimensions[1]+extra_wall*2,wall_w+r_round,r_round);

                translate([dimensions[0]+extra_wall*2+wall_w,-epsilon,dimensions[2]*2/5-r_round])
                rotate([90,0,180])
                circled_square(dimensions[0]+extra_wall*2,dimensions[1]*2+extra_wall*2,dimensions[1]+extra_wall*2+epsilon*2,r_round);   
            }
            intersection() 
            {
                circled_square(dimensions[0]+extra_wall*2,dimensions[1]+extra_wall*2,dimensions[2]*2/5,r_round);
                translate([wall_w,0,0])
            
                translate(v = [-wall_width,dimensions[1]*1.5,-r_round]) 
                rotate([90,0,0])
                circled_square(dimensions[0]+extra_wall*2,dimensions[2]*2/5,dimensions[1]*2,r_round);
            }
        }
        translate(v = [wall_w, wall_w, wall_w]) 
        circled_square(dimensions[0]+tolerance*2,dimensions[1]+tolerance*2,dimensions[2]+tolerance*2,r_round);
    
        y_translate = (dimensions[1] + extra_wall*2 - dimensions[1]*2/4)/2;
        translate(v = [dimensions[0], y_translate,dimensions[2]+dimensions[2]*1/14]) 
        rotate([0,90,0])
        circled_square(dimensions[2],dimensions[1]*2/4,wall_w*3,r_round);
    
        translate(v = [-epsilon,(dimensions[1] + extra_wall*2)/2,dimensions[2]*2/3-wall_w*8]) 
        rotate([0,90,0])
        cylinder(h = wall_w*3, d = screw_metric, $fn = fn);

        translate(v = [-epsilon,(dimensions[1] + extra_wall*2)/2,dimensions[2]*1/3-wall_w*8]) 
        rotate([0,90,0])
        cylinder(h = wall_w*3, d = screw_metric, $fn = fn);
    } 
}       


// translate([wall_width+tolerance,wall_width+tolerance,wall_width+tolerance])
// color("Indigo", alpha = 0.6)
// cube(remote_size);
box_base(dimensions = remote_size, wall_w = wall_width, r_round = rounding);