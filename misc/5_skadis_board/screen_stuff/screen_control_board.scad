include <../skadis_param.scad>
include <../skadis_simple_hook.scad>
include <./../../../utils/filleted_rectangle.scad>
include <./../skadis_rpy3aplus_clip.scad>

holes = [[7.4,12.5],
         [35.4,11.35],
         [7.4,117.44],
         [35.4,123]];

hole_diameter = 3.5;
external_diameter = 17;

module base_hole_shape()
{
    // Base shape to cover holes
    hull()
    {
        for(position = holes)
        {
            translate(position) cylinder(d = external_diameter, h = clip_wall_bottom, $fn = fn);
        }
    }
}

module screen_board_clip()
{
    union()
    {
        difference()
        {
            union()
            {
                base_hole_shape();
                // Holes for strips

                // Hooks
                translate([-0.5,100,hook_side])
                rotate([-90,0,0])
                simple_hook_array(2,3);

                for(position = holes)
                {
                    translate(position) cylinder(d = hole_diameter+2, h = clip_wall_bottom+2, $fn = fn);
                }
            }

            union()
            {
                for(position = holes)
                {
                    strip_hole(translation = position, strip_head_size = [5,5,4.12], diameter = hole_diameter, height = clip_wall_bottom+2 + 0.1);
                }
            }
            translate([6,15,-0.1])
            scale([0.7,0.76,1.1])
            base_hole_shape();
        }

    
    }
}

// screen_board_clip();

mode = "none";
// Exportable modules
if (mode == "screen_board_clip") {
    screen_board_clip();
}
