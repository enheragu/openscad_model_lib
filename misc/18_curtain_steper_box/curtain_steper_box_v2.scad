include <./deps/gears.scad>

Gear_type = "None";

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

/* [Box Info] */

// Width of piece
wall_width = 3.25; // 0.1

support_side = 47.7; // 0.1

total_heigth = 62.45; // 0.1

fix_tongue_length = 29.2; // 0.1

fix_tongue_edge_margin = 1.15;

fix_tongue_middle_separation = 1.5;

// Height, diam
ball_gear = [8.17,30.09]; 

// Height, diam_lower, diam_upper
insertion_gear = [43.7,18,15];


/* [Gears settings] */

// Number of theeth in step mottor gear
teeth_step_motor = 14;

// Multiplier to compute curtain gear from motor gear
amplification = 2.5;

// Axis diameter in curtain gear
axis_diam = 2.4+tolerance;

// Width of bot gears
gear_width = wall_width*2;

gear_motor_diam = Module * teeth_step_motor;
gear_curtain_diam = Module * teeth_step_motor*amplification;
gear_center_distance = (gear_motor_diam + gear_curtain_diam)/2;

/* [Screw settings] */
        
M_3 = 3;
M_3_head = 5;


/* [Other] */

// Small cuantity to ensure cutting though
epsilon = 0.1;

// Exporting options
export = "L"; //[L:Lid, B:Base, CG:Curtain Gear, MG:Motor Gear ,A:Assembly, N:None]

// $fn resolution
fn = 120;


// Intermediate params
heigth_with_gear = total_heigth + gear_center_distance;

module original_piece()
{
    translate(v = [0,-support_side/2,0])
    cube(size = [total_heigth-support_side/2, support_side, wall_width]);
    cylinder(h = wall_width, d = support_side, $fn = fn);

    cylinder(h = wall_width + ball_gear[0], d = ball_gear[1], $fn = fn);
    cylinder(h = wall_width + ball_gear[0] + insertion_gear[0], d1 = insertion_gear[1], d2 = insertion_gear[2], $fn = fn);

    tongue_y = support_side/2 - fix_tongue_middle_separation/2 - fix_tongue_edge_margin;

    translate_x = total_heigth-support_side/2 - fix_tongue_edge_margin - wall_width;
    translate_y_t1 = fix_tongue_middle_separation/2;
    translate_y_t2 = tongue_y + fix_tongue_middle_separation/2;
    translate(v = [translate_x, translate_y_t1, 0]) 
    cube(size = [wall_width, tongue_y, fix_tongue_length]);
    translate(v = [translate_x, -translate_y_t2, 0]) 
    cube(size = [wall_width, tongue_y, fix_tongue_length]);
}

module curtain_gear()
{
    base_h = 2.6;
    base_diam = 30;
    axis_length = 40;
    translate(v = [gear_center_distance,0,wall_width+ball_gear[0]-base_h]) 
    union()
    {
        difference() 
        {
            union()
            {
                cylinder(h = base_h + insertion_gear[0], d1 = insertion_gear[1]-tolerance*3, d2 = insertion_gear[2]-tolerance*2, $fn = fn);
                cylinder(h = base_h + insertion_gear[0], d1 = insertion_gear[1]-tolerance, d2 = insertion_gear[2]-tolerance, $fn = 6);

            }
            translate(v = [0,0,-epsilon]) 
            cylinder(h = axis_length, d = axis_diam, $fn = fn);
        }
        translate(v = [0,0,base_h-gear_width]) 
        stirnrad (modul=Module, zahnzahl=teeth_step_motor*amplification, breite=gear_width, bohrung=axis_diam, 
                    nabendurchmesser=0, nabendicke=0, 
                    eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle, 
                    optimiert=optimized);
    }
    
}

module motor_gear()
{
    base_h = 2.6;
    motor_fix_diam = 5 + tolerance*2;
    motor_fix_heigth = 30 + epsilon;
    motor_fix_side = 3 + tolerance*2;

    translate([0,0,wall_width+ball_gear[0]-base_h])
    translate(v = [0,0,base_h-gear_width]) 
    rotate([0,0,6])
    union()
    {
        stirnrad (modul=Module, zahnzahl=teeth_step_motor, breite=gear_width, bohrung=motor_fix_diam+wall_width, 
                nabendurchmesser=0, nabendicke=0, 
                eingriffswinkel=pressure_angle, schraegungswinkel=-finalHelixAngle, 
                optimiert=optimized);

        difference()
        {
            cylinder(h = gear_width, d = motor_fix_diam + wall_width + epsilon*2);
            translate(v = [0,0,-epsilon]) 
            intersection()
            {
                cylinder(h = gear_width + epsilon*2, d = motor_fix_diam, $fn = fn);
                translate([0,0,(gear_width + epsilon*2)/2])
                cube(size = [motor_fix_diam, motor_fix_side, gear_width + epsilon*2], center = true);
            }
        }
    }
}

module motor_lid()
{
    lid_h = 3 - tolerance; // extra espace for gear
    motor_gear_base_h = 2.6 + tolerance + epsilon;
    motor_gear_base_diam = gear_motor_diam + wall_width + tolerance*2;

    motor_hole = 9 + tolerance*2;

    translate(v = [0,0,wall_width+ball_gear[0]-lid_h-gear_width - tolerance]) 
    difference()
    {
        union()
        {
            // translate(v = [0,-support_side/2,0])
            // cube(size = [heigth_with_gear-support_side/2, support_side, lid_h]);
            cylinder(h = lid_h, d = support_side, $fn = fn);
        }

        // translate(v = [0,0,lid_h-motor_gear_base_h-epsilon]) 
        // cylinder(h = motor_gear_base_h + tolerance, d = motor_gear_base_diam, $fn = fn);

        translate(v = [0,0,-epsilon]) 
        cylinder(h = lid_h + epsilon*2, d = motor_hole, $fn = fn);

        
        // Lid screw holes
        rotate([0,0,90])
        union()
        {
            translate(v = [12.5 - (motor_hole-tolerance*2)/2,31/2 + M_3/2, -epsilon]) 
            union() 
            {
                cylinder(h = lid_h + epsilon*2, d = M_3, $fn = fn);
                translate(v = [0,0,lid_h/2]) 
                cylinder(h = lid_h + epsilon*2, d = M_3_head, $fn = fn);
            }

            translate(v = [12.5 - (motor_hole-tolerance*2)/2, -31/2 - M_3/2, -epsilon]) 
            union() 
            {
                cylinder(h = lid_h + epsilon*2, d = M_3, $fn = fn);
                translate(v = [0,0,lid_h/2]) 
                cylinder(h = lid_h + epsilon*2, d = M_3_head, $fn = fn);
            }
        }
        translate(v = [gear_center_distance,0,-epsilon]) 
        cylinder(h = lid_h + epsilon*2, d = axis_diam + wall_width*2 + tolerance*2, $fn = fn);
    }
}

module motor_base ()
{
    external_motor_diam = 28 + tolerance*2;
    motor_hole = 9 + tolerance*2;
    motor_height = 19.3;
    base_h = motor_height + wall_width;
    lid_h = 3;

    //distance between motor axis and motor center
    motor_axis_to_center = 12.5;

    motor_fix_diam = 7;
    motor_fix_h = 1.5;

    extra_h_piece = wall_width+ball_gear[0]-lid_h-base_h;

    // extra upper tongue and its base
    space = 27.6 - tolerance;

    translate_z = wall_width+ball_gear[0]-lid_h-base_h-gear_width;
    difference() 
    {
        union()
        {
            translate(v = [0,0,translate_z]) 
            difference() 
            {
                union()
                {
                    translate(v = [0,-support_side/2,0])
                    // cube(size = [heigth_with_gear-support_side/2, support_side, base_h-2.5]);
                    cube(size = [heigth_with_gear-support_side/2 + wall_width + tolerance, support_side, base_h]);
                    cylinder(h = base_h, d = support_side, $fn = fn);
                }

                // motor hole
                rotate([0,0,90])
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

                    // Hole for the motor cables and extra
                    hole_side = 19;
                    translate(v = [0, -hole_side/2, wall_width]) 
                    cube(size = [heigth_with_gear, hole_side, motor_height+epsilon]);
                }
            }

            tongue_y = support_side/2 - fix_tongue_middle_separation/2 - fix_tongue_edge_margin;

            translate_x = heigth_with_gear-support_side/2 - fix_tongue_edge_margin - wall_width + tolerance/2;
            translate_y_t1 = fix_tongue_middle_separation/2 + tolerance/2;
            translate_y_t2 = tongue_y + fix_tongue_middle_separation/2 - tolerance/2;
            // Bigger tongues for better sujection
            tongue_length = fix_tongue_length*1.5;
            translate(v = [translate_x, translate_y_t1, 0]) 
            cube(size = [wall_width-tolerance, tongue_y-tolerance, tongue_length]);
            translate(v = [translate_x, -translate_y_t2, 0]) 
            cube(size = [wall_width-tolerance, tongue_y-tolerance, tongue_length]);

            translate(v = [heigth_with_gear-support_side/2 + tolerance, -space/2, 0]) 
            cube(size = [wall_width, space, tongue_length]);

            // makes sure of the final aligment
            extra_space = heigth_with_gear-support_side/2 + wall_width + tolerance - translate_x;
            translate(v = [translate_x,-support_side/2,-wall_width]) 
            cube(size = [extra_space, support_side, wall_width*2]);

            // Extra support for curtain gear axis!
            translate(v = [gear_center_distance,0,translate_z]) 
            cylinder(h = base_h+lid_h-tolerance, d = axis_diam + wall_width*2, $fn = fn);
        }
    
        // Hueco tornillo lenguas
        // 19.5 + M_3/2 // largo desde el extremo!!
        // 14.08 + M_3/2 // ancho desde el ladito
        translate(v = [0,14.08 + M_3/2,motor_height+wall_width+19.5 + M_3/2]) 
        translate(v = [heigth_with_gear-support_side/2-wall_width*2,-support_side/2,translate_z])
        rotate([0,90,0]) 
        cylinder(h = wall_width*4, d = M_3 + tolerance*2, $fn = fn);
    
        // Extra hole piece for curtain gear axis!
        translate(v = [gear_center_distance,0,-epsilon+translate_z]) 
        cylinder(h = fix_tongue_length, d = axis_diam + tolerance, $fn = fn);
    }

}

          
if (export == "L")
{
    motor_lid();
}
else if (export == "B")
{   
    motor_base();
}
else if (export == "CG")
{   
    curtain_gear();
}
else if (export == "MG")
{   
    motor_gear();
}
else if (export == "A")
{    
    // translate(v = [0,0,15])
    color("grey") motor_lid();

    // translate(v = [0,0,30]) 
    color("white") curtain_gear();

    color("lightgrey") motor_gear();

    color("darkgrey") motor_base();

    // translate(v = [0,0,-22]) 
    // cylinder(h = 50, d = 2.4);
}
else
{
}
