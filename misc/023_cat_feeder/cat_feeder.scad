
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

// Height of the dispensation cone (mm)
cone_height = 60;

// Upper diam of dispensation cone (mm)
cone_diam = 80;

/* [Screw settings] */
        
M_3 = 3;
M_3_head = 5;


/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

// tolerance in degrees to fit screw parts (deg)
tolerance_deg = 1; // 0.1

/* [Other] */

export = "A"; //[L:Lid, H:Helix, M:Motor base,A:Assembly, C:Dispensation Cone, S: Dispensation Slide, N:None]

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


module empty_cylinder(h, d_ext, d_int, wall_width = 0)
{
   difference() 
    {
        cylinder(h = h, d = d_ext, $fn=fn);
        translate(v = [0,0,-epsilon+wall_width]) 
        cylinder(h = h+epsilon*2, d = d_int, $fn=fn);
    } 
}

module chamfered_cone(h, d1, d2)
{
    internal_diam = insertion_diameter-tolerance-wall_width*2;
    difference() 
    {
        cylinder(h = h, d1 = d1, d2 = d2, $fn = fn);
        translate(v = [d1+(d2-d1)*0.6,0,d2/2]) 
        cube([d2,d2,d2], center=true);

        d1_inside = d1-wall_width*1.5-tolerance*2;
        d2_inside = d2-wall_width*1.5-tolerance*2;
        translate(v = [0,0,-epsilon]) 
        difference() 
        {
            cylinder(h = h+epsilon*2, d1 = internal_diam, d2 = d2_inside, $fn = fn);
            translate(v = [d1_inside+(d2_inside-d1_inside)*0.6,0,d2_inside/2]) 
            cube([d2_inside,d2_inside,d2_inside], center=true);
        }
    }
}

module elbow(innerDiam, outerDiam, bendRadius, angle = 45)
{
    translate(v = [0,bendRadius,0]) 
    rotate([90,0,-90])
    intersection()
    {
        rotate_extrude(angle = angle, $fn = fn)
        translate([bendRadius, 0, 0]) 
        difference() 
        {
            circle(d = outerDiam, $fn = fn);
            circle(d = innerDiam, $fn = fn);
        }
        translate([0, 0, -outerDiam/2]) 
        cube([bendRadius + outerDiam/2, bendRadius + outerDiam/2, outerDiam]);
    }
}


module cat_feeder_dispensation_cone()
{
    external_diam = ext_diameter+wall_width*2+tolerance*3;
    external_insertion_height = wall_width*8;
    internal_diam = insertion_diameter-tolerance-wall_width*2;
    
    difference() 
    {
        union() 
        {
            translate(v = [0,internal_diam-wall_width*2,-insertion-internal_diam/2+epsilon]) 
            rotate([45,0,0])
            union()
            {
                translate(v = [0,0,insertion-external_insertion_height]) 
                empty_cylinder(external_insertion_height, d_ext=external_diam, d_int=ext_diameter);

                translate(v = [0,0,insertion]) 
                empty_cylinder(wall_width, d_ext=external_diam, d_int=internal_diam);

                translate(v = [0,0,insertion+wall_width]) 
                elbow(internal_diam, external_diam, bendRadius = internal_diam, angle = 45);
            }
            chamfered_cone(h = cone_height, d1 = external_diam, d2 = cone_diam); 
        }

        
        // Wall support
        wall_attach_dim = [7, 7];
        wall_small_diam = 4;
        extra = 2;
        hole_width = wall_width*4 + epsilon*4;
        translate(v = [external_diam/2-wall_width,0,cone_height*0.8-max(wall_attach_dim)]) 
        union()
        {
            translate([(hole_width)/2, 0, (wall_small_diam + wall_attach_dim[1] + extra)/2])
            cube([hole_width, wall_small_diam, wall_small_diam + wall_attach_dim[1] + extra], center = true);
        
            translate([(hole_width)/2, 0, (wall_attach_dim[1])/2])
            cube([hole_width, wall_attach_dim[0], wall_attach_dim[1]], center = true);
        }
    }
     

}

module cat_feeder_dispensation_ramp()
{
    internal_diam = insertion_diameter-tolerance-wall_width*2;
    internal_diam_wall = internal_diam-tolerance-wall_width*2;
    empty_cylinder(h=insertion, d_ext=insertion_diameter-tolerance, d_int=in_diameter-tolerance);


    translate(v = [0,0,wall_width]) 
    rotate([0,180,0])
    difference() 
    {
        cylinder(h=wall_width, d1=insertion_diameter-tolerance, d2=in_diameter-tolerance, $fn = fn);
        translate([0,0,-epsilon])
        cylinder(h=wall_width+epsilon*2, d1=insertion_diameter-tolerance-wall_width*2, d2=in_diameter-tolerance-tolerance-wall_width*2, $fn = fn);

        translate(v = [-insertion_diameter/2,0,0]) 
        cube([insertion_diameter,insertion_diameter,insertion_diameter]);
    }

    difference() 
    {
        union()
        {
            difference() 
            {
            
                translate([0,0,-insertion])
                empty_cylinder(h=insertion, d_ext=in_diameter-tolerance, d_int=in_diameter-wall_width*2-tolerance);

                translate([0,0,-insertion*1.5])
                rotate([45,0,0])
                empty_cylinder(h=insertion*2, d_ext=in_diameter-tolerance*2, d_int=0);
            }
            intersection()
            {
                translate([0,0,-insertion])
                empty_cylinder(h=insertion, d_ext=in_diameter-tolerance, d_int=0);

                translate([0,0,-insertion*1.5])
                rotate([45,0,0])
                empty_cylinder(h=insertion*2, d_ext=in_diameter-tolerance*2, d_int=in_diameter-wall_width*2-tolerance*2);
            }
        }
        
        translate([0,0,-insertion-epsilon])
        translate(v = [-in_diameter/2,0,0]) 
        cube([in_diameter,in_diameter,in_diameter]);
    }

    
    
    
    // angle = 40;
    // translate(v = [0,internal_diam*cos(3.1415/180*angle),-internal_diam*cos(3.1415/180*angle)])
    // rotate([angle,0,0])
    // cube([internal_diam*2,internal_diam*2,internal_diam*2],center=true);
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
else if (export == "C")
{   
    cat_feeder_dispensation_cone();
}
else if (export == "S")
{   
    cat_feeder_dispensation_ramp();
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


    color("#9DC209")
    translate([0,in_diameter,separation*2.5])
    rotate([-45,0,0])
    cat_feeder_dispensation_ramp();

    color("#11C39C", alpha=1)
    translate([0,in_diameter*2.5,separation*3.8])
    rotate([-90,0,0])
    cat_feeder_dispensation_cone();
}
else
{
}
