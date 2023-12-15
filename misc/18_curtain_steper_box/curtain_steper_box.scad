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


        
M_3 = 3;
M_3_head = 5;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

/* [Other] */

// Small cuantity to ensure cutting though
epsilon = 0.1;

// Exporting options
export = "L"; //[L:Lid, B:Base, G:Gear ,A:Assembly, N:None]

// $fn resolution
fn = 120;


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

module motor_gear()
{
    base_h = 2.6;
    base_diam = 30;
    translate(v = [0,0,wall_width+ball_gear[0]-base_h]) 
    difference() 
    {
        union()
        {
            cylinder(h = base_h, d = base_diam, $fn = fn);
            cylinder(h = base_h + insertion_gear[0], d1 = insertion_gear[1]-tolerance*3, d2 = insertion_gear[2]-tolerance*2, $fn = fn);
            cylinder(h = base_h + insertion_gear[0], d1 = insertion_gear[1]-tolerance, d2 = insertion_gear[2]-tolerance, $fn = 6);
        }

        motor_fix_diam = 5 + tolerance*2;
        motor_fix_heigth = 30 + epsilon;
        motor_fix_side = 3 + tolerance*2;

        translate(v = [0,0,-epsilon]) 
        intersection()
        {
            cylinder(h = motor_fix_heigth, d = motor_fix_diam, $fn = fn);
            cube(size = [motor_fix_diam, motor_fix_side, motor_fix_heigth], center = true);
        }
    }
}


module motor_lid()
{
    lid_h = 5.7;
    motor_gear_base_h = 2.6 + tolerance + epsilon;
    motor_gear_base_diam = 30 + tolerance*2;

    motor_hole = 9 + tolerance*2;

    translate(v = [0,0,wall_width+ball_gear[0]-lid_h]) 
    difference()
    {
        union()
        {
            // translate(v = [0,-support_side/2,0])
            // cube(size = [total_heigth-support_side/2, support_side, lid_h]);
            cylinder(h = lid_h, d = support_side, $fn = fn);
        }

        translate(v = [0,0,lid_h-motor_gear_base_h-epsilon]) 
        cylinder(h = motor_gear_base_h + tolerance, d = motor_gear_base_diam, $fn = fn);

        translate(v = [0,0,-epsilon]) 
        cylinder(h = lid_h + epsilon*2, d = motor_hole, $fn = fn);

        
        // Lid screw holes
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
}

module motor_base ()
{
    external_motor_diam = 28 + tolerance*2;
    motor_hole = 9 + tolerance*2;
    motor_height = 19.3;
    base_h = motor_height + wall_width;
    lid_h = 5.7;

    motor_fix_diam = 7;
    motor_fix_h = 1;

    extra_h_piece = wall_width+ball_gear[0]-lid_h-base_h;

    // extra upper tongue and its base
    space = 27.6 - tolerance;

    translate_z = wall_width+ball_gear[0]-lid_h-base_h;
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
                    // cube(size = [total_heigth-support_side/2, support_side, base_h-2.5]);
                    cube(size = [total_heigth-support_side/2 + wall_width + tolerance, support_side, base_h]);
                    cylinder(h = base_h, d = support_side, $fn = fn);
                }

                // motor hole
                translate(v = [12.5 - (motor_hole-tolerance*2)/2, 0, wall_width]) 
                cylinder(h = motor_height+epsilon, d = external_motor_diam, $fn = fn);

                // Lid screw holes
                lid_screw_trans_y = 31/2 + M_3/2;
                translate(v = [12.5 - (motor_hole-tolerance*2)/2, lid_screw_trans_y, wall_width]) 
                union() 
                {
                    cylinder(h = base_h + epsilon*2, d = M_3, $fn = fn);
                    translate(v = [0,0,base_h-wall_width-motor_fix_h]) 
                    cylinder(h = motor_fix_h + epsilon, d = motor_fix_diam, $fn = fn);
                }

                translate(v = [12.5 - (motor_hole-tolerance*2)/2, -lid_screw_trans_y, wall_width]) 
                union() 
                {
                    cylinder(h = base_h + epsilon*2, d = M_3, $fn = fn);
                    translate(v = [0,0,base_h-wall_width-motor_fix_h]) 
                    cylinder(h = motor_fix_h + epsilon, d = motor_fix_diam, $fn = fn);
                }
            
                translate(v = [12.5 - (motor_hole-tolerance*2)/2,0, base_h - motor_fix_h/2 + epsilon]) 
                cube(size = [motor_fix_diam, lid_screw_trans_y*2, motor_fix_h + epsilon], center = true);

                // Hole for the motor cables and extra
                hole_side = 19;
                translate(v = [0, -hole_side/2, wall_width]) 
                cube(size = [total_heigth, hole_side, motor_height+epsilon]);
            }

            tongue_y = support_side/2 - fix_tongue_middle_separation/2 - fix_tongue_edge_margin;

            translate_x = total_heigth-support_side/2 - fix_tongue_edge_margin - wall_width + tolerance/2;
            translate_y_t1 = fix_tongue_middle_separation/2 + tolerance/2;
            translate_y_t2 = tongue_y + fix_tongue_middle_separation/2 - tolerance/2;
            // Bigger tongues for better sujection
            tongue_length = fix_tongue_length*1.5;
            translate(v = [translate_x, translate_y_t1, 0]) 
            cube(size = [wall_width-tolerance, tongue_y-tolerance, tongue_length]);
            translate(v = [translate_x, -translate_y_t2, 0]) 
            cube(size = [wall_width-tolerance, tongue_y-tolerance, tongue_length]);

            translate(v = [total_heigth-support_side/2 + tolerance, -space/2, 0]) 
            cube(size = [wall_width, space, tongue_length]);

            translate(v = [translate_x,-support_side/2,0]) 
            cube(size = [wall_width*2, support_side, wall_width]);
        }
    
        // Hueco tornillo lenguas
        // 19.5 + M_3/2 // largo desde el extremo!!
        // 14.08 + M_3/2 // ancho desde el ladito
        translate(v = [0,14.08 + M_3/2,motor_height+wall_width+19.5 + M_3/2]) 
        translate(v = [total_heigth-support_side/2-wall_width*2,-support_side/2,translate_z])
        rotate([0,90,0]) 
        cylinder(h = wall_width*4, d = M_3 + tolerance*2, $fn = fn);
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
else if (export == "G")
{   
    motor_gear();
}
else if (export == "A")
{    
    // translate(v = [0,0,15])
    color("grey") motor_lid();

    // translate(v = [0,0,30]) 
    color("white") motor_gear();

    color("darkgrey") motor_base();


    // color("Olive", 0.4) original_piece();
}
else
{
}
