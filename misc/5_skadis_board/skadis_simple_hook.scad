include <skadis_param.scad>
include <skadis_board.scad>



hook_side = board_hole_x-tolerance*2;
hook_back_height = board_hole_y*0.95-tolerance;
hook_inside_width = skadis_board_width + tolerance * 2;

hook_heiht = hook_back_height + hook_side;
hook_width = hook_inside_width + hook_side*2;
hook_length = hook_side;

module simple_hook()
{
    color("red")
    // Intersection with hole to leave rounded shape
    intersection()
    {
        translate([0,hook_inside_width + hook_side,0])
        union()
        {
            // translate([0,-hook_inside_width - hook_side, 0 - hook_side])
            // cube([hook_side,hook_side,hook_back_height-hook_side]);

            translate([hook_side,-hook_inside_width, hook_back_height-hook_side])
            rotate([90,0,-90])
            rotate_extrude(angle=90, convexity=10)
            square(size = hook_side);

            translate([0,-hook_inside_width,hook_back_height-hook_side])
            cube([hook_side,hook_inside_width,hook_side]);

            translate([0,0,hook_back_height - hook_side])
            rotate([90,0,90])
            rotate_extrude(angle=90, convexity=10)
            square(size = hook_side);

            cube([hook_side,hook_side,hook_back_height-hook_side]);
        }
        translate([-board_hole_x+hook_side+tolerance,hook_width+0.1,0])
        scale([1,10,0.95])
        rotate([90,0,0])
        single_hole();
    }
}

module simple_hook_array(row = 1, column = 1)
{
    union()
    {
        for(x = [0:row-1])
        {
            for (y = [0:column-1])
            {
                tranlate_x = x * (35 + board_hole_x);
                tranlate_y = y * (24.8 + board_hole_y);
                translate([tranlate_x,0,-tranlate_y])
                simple_hook();
            }
        }
    }
}

// simple_hook_array(2,2);
