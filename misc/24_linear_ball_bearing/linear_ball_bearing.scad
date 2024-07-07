// Customizable linear bearing by enheragu
// Date: 18-06-2024

/* [Bearing Sizes] */

// Bearing internal diameter (mm)
internal_diam = 85.8;

// Beargin external diameter (mm) (should be more than internald_diam + ball_diam*2 + wall_width*2)
external_diam = 125;

// Diameter of the balls (mm)
ball_diam = 16;

// Number of balls on each row
ball_num = 6;

// Row height (mm) (should be more than ball diam...)
row_height = 20;

// Minimum wall width (mm)
wall_width = 2;

// Width of lateral insertion if needed (mm)
insertion_width = 40.8;

/* [Printer settings] */

// Printer tolerance (mm). Printers are not perfect, pieces need a bit of margin to fit.
tolerance=0.4;

/* [Screw settings] */
        
M3 = 3;
M3_head_diam = 5.7;

// Height of the screw head (mm)
M3_head_height = 4;

// Diam of the bolt (mm)
M3_nut_diam = 6.4;

// Height of the bolt slot (mm  )
M3_nut_height = 2.4;

// number of screws to fix each part
screws_fixation = 6;

/* [Other]  */


export = "A"; //[U:Upper Side, L:Lower Side, I:Intermediate,A:Assembly]

// $fn resolution
fn = 180;

// Small cuantity to ensure cutting though
epsilon = 0.1;




module balls(tolerance = 0)
{
    angle = atan2(insertion_width/2, external_diam/2);
    angle_total = 360-angle*2;
    for (i = [0 : ball_num-1])
    {
        rotate([0,0,angle_total/screws_fixation*i+angle_total/ball_num/2+angle])
        translate(v = [internal_diam/2+ball_diam/2+tolerance,0,0]) 
        sphere(d = ball_diam+tolerance*2, $fn=fn); 
    }
}

module screw_fixation()
{

    angle = atan2(insertion_width/2, external_diam/2);
    angle_total = 360-angle*2;
    for (i = [0 : screws_fixation])
    {
        rotate([0,0,angle_total/ball_num*i+angle])
        translate(v = [internal_diam/2+ball_diam/2+tolerance,0,0])
        union()
        { 
            cylinder(h=row_height+epsilon*2, d=M3+tolerance, $fn=fn, center=true);

            // Nut/Bolt up and down are intercalated
            nut_screw = (i % 2 == 1) ? 1 : -1;

            translate(v = [0,0,nut_screw*(-row_height/2-epsilon)]) 
            cylinder(h=M3_nut_height+tolerance*4, d=M3_nut_diam+tolerance, $fn=6, center=true);
            
            translate(v = [0,0,nut_screw*(+row_height/2+epsilon)]) 
            cylinder(h=M3_head_height+tolerance*4, d=M3_head_diam+tolerance, $fn=fn, center=true);
        }
    }
}


module linear_bearing()
{
    difference() 
    {
        cylinder(h = row_height, d = external_diam, $fn = fn, center=true);
        cylinder(h = row_height+epsilon*2, d = internal_diam+wall_width*2+tolerance, $fn = fn, center=true);

        balls(tolerance);
        screw_fixation();      

        if (insertion_width != 0)
        {
            translate(v = [external_diam/2,0,0]) 
            cube(size = [external_diam+epsilon,insertion_width,row_height+epsilon*2], center=true);  
        }
    }
}


module lower_side()
{
    difference() 
    {
        linear_bearing();
        translate(v = [0,0,row_height/2]) 
        cylinder(h = row_height, d = external_diam+epsilon, $fn = fn, center=true);
    }

}


module upper_side()
{
    difference() 
    {
        linear_bearing();
        translate(v = [0,0,-row_height/2]) 
        cylinder(h = row_height, d = external_diam+epsilon, $fn = fn, center=true);
    }
}

module intermediate_side()
{   
    difference() 
    {
        union()
        {
            translate(v = [0,0,row_height]) 
            lower_side();
            upper_side();
        }
        translate(v = [0,0,row_height/2]) 
        screw_fixation();
    }
}

separation = 15;
if (export == "L")
{
    translate([0,0,row_height/2])
    rotate([180,0,0])
    upper_side();   
}
else if (export == "U")
{   
    translate([0,0,row_height/2])
    lower_side();
}
else if (export == "I")
{   
    intermediate_side();
}
else if (export == "A")
{   

    for(i = [0,2])
    {
    rotate([0,0,360/ball_num*i])
    translate([0,0,separation*2*i])
    {
        // color("white")
        // translate([0,0,separation*2+row_height])
        translate([0,0,separation*2+row_height+separation*(i+1)])
        upper_side();  

        color("grey", alpha=0.5)
        translate([0,0,separation*1.5+row_height+separation*(i+1)])
        balls(); 

        // color("white")
        translate([0,0,separation*1+separation*(i+1)])
        intermediate_side();

        color("grey", alpha=0.5)
        translate([0,0,separation*0.5+separation*(i+1)])
        balls(); 

        // color("white")
        translate([0,0,row_height/2+separation*i])
        lower_side();
    }
    }
}