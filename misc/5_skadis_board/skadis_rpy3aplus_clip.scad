include <skadis_param.scad>
include <skadis_simple_hook.scad>
include <./../../electronic_parts/raspberry_pi_3a_plus/raspberry_pi_3a_plus.scad>
include <./../../utils/filleted_rectangle.scad>

module strip_hole(translation = [0,0,0], strip_head_size = [4,4,4], diameter = 3, height = 10)
{
    enlarged_side_x = strip_head_size[0]+tolerance;
    enlarged_side_y = strip_head_size[1]+tolerance;
    enlarged_side_z = strip_head_size[2]+tolerance;
    translate(translation)
    // center
    translate([-enlarged_side_x/2,-enlarged_side_y/2,0])
    union()
    {
        translate([enlarged_side_x/2,enlarged_side_y/2,enlarged_side_z/2-0.1])
        rotate([0,0,45])
        cube([enlarged_side_x,enlarged_side_y,enlarged_side_z+0.1], center = true);
        translate([enlarged_side_x/2,enlarged_side_y/2,enlarged_side_z - 0.1])
        cylinder(d = diameter, h = height - strip_head_size[2] + 0.1, $fn = fn);
    }
}

module rpy_clip()
{
    // hole_diameter
    fillet_rad = 10/2;
    size_x = rpy_hole_distance_x+fillet_rad*2;
    size_y = rpy_hole_distance_y+fillet_rad*2;
    difference()
    {
        union()
        {
            color("white")
            difference()
            {
                filleted_rectangle(size_x,size_y,clip_wall_bottom, fillet_rad);
                
                translate([size_x/2,size_y/2,0])
                for(position = get_hole_positions())
                {
                    // Positions are centered, de-center them
                    strip_hole(translation = position, strip_head_size = [5,5,4.12], diameter = rpy_hole_diameter, height = clip_wall_bottom + 0.1);
                }
            }

            // Hooks
            translate([12,40,0])
            rotate([-90,0,0])
            translate([0,-hook_side,0])
            simple_hook_array(2,2);
        }

        // Remove center to save plastic
        hole_size = 40;
        hole_z = clip_wall_bottom+0.2;
        translate([34,30,-0.1])
        scale([1.15,1,1])
        rotate([0,0,45])
        translate([-hole_size/2,-hole_size/2,0])
        filleted_rectangle(hole_size,hole_size,hole_z, fillet_rad);

        // Remove extra surface to fit components
        cut_size_y = size_y-fillet_rad*3.6;
        translate([-0.1,size_y/2-cut_size_y/2,clip_wall_bottom-2.5])
        cube([size_x+0.2, cut_size_y,clip_wall_bottom]);
        
        cut_size_x = size_x-fillet_rad*3.6;
        translate([size_x/2-cut_size_x/2,-0.1,clip_wall_bottom-2.5])
        cube([cut_size_x, size_y+0.2,clip_wall_bottom]);
    }
}

module assembly_rpy_clip()
{
    rpy_clip();
    fillet_rad = 10/2;
    translate([fillet_rad/4,fillet_rad/4,clip_wall_bottom])
    raspberry_pi_3a_plus();
}

 rpy_clip();

mode = "none";
// Exportable modules
if (mode == "rpy_clip") {
    rpy_clip();
}
