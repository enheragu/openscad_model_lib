include <skadis_param.scad>



side = board_hole_x-tolerance*2;
hook_back_height = board_hole_y-tolerance;
hook_inside_width = board_width + tolerance * 2;

hook_heiht = hook_back_height + side;
hook_width = hook_inside_width + side*2;
hook_length = side;

module simple_hook()
{
    color("red")
    translate([0,hook_inside_width + side,0])
    union()
    {
        // translate([0,-hook_inside_width - side, 0 - side])
        // cube([side,side,hook_back_height-side]);

        translate([side,-hook_inside_width, hook_back_height-side])
        rotate([90,0,-90])
        rotate_extrude(angle=90, convexity=10)
        square(size = side);

        translate([0,-hook_inside_width,hook_back_height-side])
        cube([side,hook_inside_width,side]);

        translate([0,0,board_hole_y - tolerance - side])
        rotate([90,0,90])
        rotate_extrude(angle=90, convexity=10)
        square(size = side);

        cube([side,side,hook_back_height-side]);
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
