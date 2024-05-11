
/* [Design settings] */
// Number of helix in the spiral
helix = 2;

// Minimum wall thickness (mm)
wall_width = 2; // 0.1

// Inclination of the fingers (degrees)
inclination = 40;

// Diameter of tube used (inside, minimum) (mm)
in_diameter = 35.14; // 0.1

// Diameter of the insertion in the tube (mm)
insertion_diameter = 40;

// external diameter of the tube
ext_diameter = 45.5;

// insertion on the edges
insertion = 28;

// Height inside the tube (mm)
in_height = 125;

// Axis diameter to fix the helix
axis_diam = 2.4;

/* [Screw settings] */
        
M_3 = 3;
M_3_head = 5;


/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

// tolerance in degrees to fit screw parts (deg)
tolerance_deg = 1; // 0.1

/* [Other] */

export = "A"; //[L:Lid, H:Helix, M:Motor base,A:Assembly, N:None]

// $fn resolution
fn = 180;

// pi :)
pi = 3.1415;

// Small cuantity to ensure cutting though
epsilon = 0.1;


module spiral_finger(hole_diameter, hole_height, wall, n_finger)
{
    // Circunference * tan(inclination)
    height_per_turn = 2 * pi * (hole_diameter/2) * tan(inclination);
    num_turns = hole_height / height_per_turn;
    twist_angle = num_turns * 360;

    linear_extrude(height = hole_height, convexity = 10, twist = -twist_angle, $fn = fn)
    translate([-wall/2,-wall/2])
    square([hole_diameter/2, wall*2]);
}

module spiral_fingers(hole_diameter, hole_height, wall, n_finger)
{
    union()
    {
        for(x = [0:n_finger])
        {
            angle = (360/n_finger) * x;
            // echo("x: ", x, "; angle: " , angle);
            rotate([0,0,angle])
            spiral_finger(hole_diameter, hole_height, wall, n_finger);
        }
    }
}


module cat_feeder_helix(height)
{
    difference() 
    {
        union() 
        {
            cylinder(h = height, d = axis_diam + wall_width*2 + tolerance, $fn = fn);
            cylinder(h = wall_width, d = in_diameter, $fn = fn);
            spiral_fingers(in_diameter, height, wall_width, helix);

            difference() 
            {
                cylinder(h = insertion, d = insertion_diameter-tolerance*2, $fn=fn);
                translate(v = [0,0,wall_width]) 
                cylinder(h = insertion, d = insertion_diameter-tolerance*2-wall_width*2, $fn=fn);
            }
        }
        translate(v = [0,0,-epsilon]) 
        intersection()
        {
            motor_fix_diam = 5 + tolerance;
            motor_fix_heigth = 30 + epsilon;
            motor_fix_side = 3 + tolerance;
            motor_slot = 10;

            cylinder(h = motor_slot-tolerance*2 + epsilon*2, d = motor_fix_diam, $fn = fn);
            translate([0,0,(motor_slot-tolerance*2 + epsilon*2)/2])
            cube(size = [motor_fix_diam, motor_fix_side, motor_slot-tolerance*2 + epsilon*2], center = true);
        }
        cylinder(h = height+epsilon, d = axis_diam + tolerance, $fn = fn);
    }
}

module cat_feeder_outer_lid() 
{
    difference() 
    {
        cylinder(h = insertion, d = insertion_diameter-tolerance, $fn=fn);
        translate(v = [0,0,wall_width]) 
        cylinder(h = insertion, d = insertion_diameter-tolerance-wall_width*2, $fn=fn);
        translate(v = [0,0,-epsilon]) 
        cylinder(h = wall_width+epsilon*2, d = axis_diam + tolerance, $fn = fn);
    

        // arc
        translate(v = [0,0,-epsilon]) 
        difference() 
        {
            cylinder(h = wall_width+epsilon*2, d = in_diameter, $fn = fn);
            translate(v = [0,0,-epsilon]) 
            cylinder(h = wall_width+epsilon*4, d = axis_diam + tolerance + wall_width*2, $fn = fn);

            rotate([0,0,360/2])
            translate(v = [-in_diameter/2,0,-epsilon]) 
            cube([in_diameter, in_diameter, wall_width+epsilon*4]);

            rotate([0,0,-360/2])
            translate(v = [-in_diameter/2,0,-epsilon]) 
            cube([in_diameter, in_diameter, wall_width+epsilon*4]);
        }
    }
}



module cat_feeder_motor_lid() 
{
    external_motor_diam = 28.2 + tolerance*2;
    motor_hole = 9 + tolerance*2;
    motor_height = 19.3;
    base_h = motor_height + wall_width;
    lid_h = 3;

    //distance between motor axis and motor center
    motor_axis_to_center = 12.5;

    motor_fix_diam = 7 + tolerance*2;
    motor_fix_h = 1.5 + tolerance;
    
    external_diam = ext_diameter+wall_width*2+tolerance*2;

    // Hole for the motor cables and extra
    hole_side = 19;
    // Outer tube part
    union()
    {
        translate(v = [0,0,-tolerance-epsilon]) 
        difference() 
        {
            cylinder(h = wall_width*8+epsilon, d = external_diam, $fn=fn);
            translate(v = [0,0,-epsilon]) 
            cylinder(h = wall_width*8+epsilon*3, d = ext_diameter, $fn=fn);
            translate(v = [0, -hole_side/2, -epsilon]) 
            cube(size = [hole_side*10, hole_side, motor_height+epsilon]);
        }

        // Motor part
        translate(v = [0,0,-base_h-tolerance]) 
        difference() 
        {
            cylinder(h = base_h, d = external_diam, $fn = fn);
            // // motor hole
            // rotate([0,0,90])
            union()
            {
                translate(v = [motor_axis_to_center - (motor_hole-tolerance*2)/2, 0, wall_width]) 
                cylinder(h = motor_height+epsilon, d = external_motor_diam, $fn = fn);

                // Lid screw holes
                lid_screw_trans_y = 31/2 + M_3/2;
                translate(v = [motor_axis_to_center - (motor_hole-tolerance*2)/2, lid_screw_trans_y, wall_width]) 
                union() 
                {
                    cylinder(h = base_h + epsilon*2, d = M_3, $fn = fn);
                    translate(v = [0,0,base_h-wall_width-motor_fix_h]) 
                    cylinder(h = motor_fix_h + epsilon, d = motor_fix_diam, $fn = fn);
                }

                translate(v = [motor_axis_to_center - (motor_hole-tolerance*2)/2, -lid_screw_trans_y, wall_width]) 
                union() 
                {
                    cylinder(h = base_h + epsilon*2, d = M_3, $fn = fn);
                    translate(v = [0,0,base_h-wall_width-motor_fix_h]) 
                    cylinder(h = motor_fix_h + epsilon, d = motor_fix_diam, $fn = fn);
                }
            
                translate(v = [motor_axis_to_center - (motor_hole-tolerance*2)/2,0, base_h - motor_fix_h/2 + epsilon]) 
                cube(size = [motor_fix_diam, lid_screw_trans_y*2, motor_fix_h + epsilon], center = true);

                translate(v = [0, -hole_side/2, wall_width]) 
                cube(size = [hole_side*10, hole_side, motor_height+epsilon]);
            }
        }
    }
}


separation = 30;
if (export == "L")
{   
    cat_feeder_outer_lid();
}
else if (export == "H")
{   
    cat_feeder_helix(in_height-wall_width-tolerance*2);
}
else if (export == "M")
{   
    cat_feeder_motor_lid();
}
else if (export == "A")
{    
    color("#D60270")
    translate([0,0,separation+in_height])
    rotate([0,180,0])
    cat_feeder_outer_lid();

    color("#9B4F96")
    cat_feeder_helix(in_height-wall_width-tolerance*2);

    color("#0038A8")
    translate(v = [0,0,-separation]) 
    cat_feeder_motor_lid();
}
else
{
}
