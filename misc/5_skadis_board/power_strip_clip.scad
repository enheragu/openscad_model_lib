
include <skadis_param.scad>
include <skadis_simple_hook.scad>
include <./../../utils/filleted_rectangle.scad>

power_strip_length = 270;
power_strip_height = 54.5;
power_strip_width = 43;
power_strip_round_corner_rad = 10;

power_strip_cable_diameter = 12.1;

clip_power_strip_length = 57 + clip_wall_bottom + tolerance;
clip_power_strip_height = power_strip_height + clip_wall*2 + tolerance*2;
clip_power_strip_width = power_strip_width + clip_wall + clip_wall_bottom + tolerance*2;


module power_strip()
{   
    difference()
    {
        color("white")
        union()
        {
            filleted_rectangle(power_strip_length,power_strip_height,power_strip_width, power_strip_round_corner_rad);

            translate([power_strip_length, power_strip_height/2,power_strip_width/2])
            rotate([0,90,0])
            cylinder(d = power_strip_cable_diameter, h = 17, $fn = fn);
        }

        // Switch
        translate([power_strip_length-25-25, power_strip_height/2 - 31/2, power_strip_width - 2])
        filleted_rectangle(25,31,2.1, 3);

        // USB plugs
        translate([25, power_strip_height/2 - 46/2, power_strip_width - 2])
        filleted_rectangle(46,46,2.1, 5);

    }
}

module power_strip_negative()
{
    n_power_strip_length = power_strip_length+tolerance*2;
    n_power_strip_height = power_strip_height+tolerance*2;
    n_power_strip_width = power_strip_width + tolerance*2;
    union()
    {
        color("black")
        union()
        {
            filleted_rectangle(n_power_strip_length,n_power_strip_height,n_power_strip_width, power_strip_round_corner_rad);

            translate([n_power_strip_length, n_power_strip_height/2,n_power_strip_width/2])
            rotate([0,90,0])
            cylinder(d = power_strip_cable_diameter, h = 17, $fn = fn);
        }

        // Switch
        n_switch_x = 45 + tolerance*2;
        n_switch_y = 34 + tolerance*2;
        n_switch_z = clip_wall_bottom + tolerance;
        translate([n_power_strip_length-23-n_switch_x, n_power_strip_height/2 - n_switch_y/2, n_power_strip_width - 2])
        filleted_rectangle(n_switch_x,n_switch_y,n_switch_z, 3);

        // USB plugs
        n_usb_x = 46 + tolerance*2;
        n_usb_y = 46 + tolerance*2;
        n_usb_z = clip_wall_bottom + tolerance;
        translate([25, power_strip_height/2 - n_usb_y/2, n_power_strip_width - 2])
        filleted_rectangle(n_usb_x,n_usb_y,n_usb_z, 5);

    }  
}

module clip_1()
{
    color("white")
    difference()
    {
        filleted_rectangle(clip_power_strip_length,clip_power_strip_height,clip_power_strip_width, power_strip_round_corner_rad);

        translate([clip_wall,clip_wall,clip_wall_bottom])
        power_strip_negative();

        // USB plugs
        translate([25-tolerance, clip_power_strip_height/2 - 50/2, clip_power_strip_width - clip_wall - 0.1])
        filleted_rectangle(clip_power_strip_length,50,clip_wall+0.2, 5);
    }

    color("red")
    translate([16,42,hook_side])
    rotate([-90,0,0])
    simple_hook_array(2,2);
}

module clip_2()
{
    translate_x = power_strip_length - clip_power_strip_length + clip_wall_bottom + tolerance;
    translate_y = 0; //- clip_wall - tolerance;
    translate_z = 0; //- clip_wall_bottom - tolerance;
    color("white")
    difference()
    {
        translate([translate_x,translate_y,translate_z])
        difference()
        {
            filleted_rectangle(clip_power_strip_length,clip_power_strip_height,clip_power_strip_width, power_strip_round_corner_rad);

            // Cable hole        
            cable_hole_y = power_strip_cable_diameter + tolerance*2 + 0.2;
            cable_hole_z = clip_power_strip_width/2;
            translate([-0.1,clip_power_strip_height/2-cable_hole_y/2-0.1,-0.1])
            cube([clip_power_strip_length + 0.2,cable_hole_y, cable_hole_z]);    

            translate([clip_power_strip_length - clip_wall - 0.1, clip_power_strip_height/2,clip_power_strip_width/2])
            rotate([0,90,0])
            cylinder(d = power_strip_cable_diameter + tolerance*2, h = clip_wall + 0.2, $fn = fn);
        }

        
        translate([clip_wall,clip_wall,clip_wall_bottom])
        power_strip_negative();
    }
    
    color("red")
    translate([216,42,hook_side])
    rotate([-90,0,0])
    simple_hook_array(2,2);
}

module assembly_power_strip_clip()
{
     translate([clip_wall+tolerance,clip_wall+tolerance,clip_wall_bottom+tolerance])
     power_strip();
    clip_1();
    clip_2();

    // Add complete matrix to hel positionate
    color("yellow", 0.5)
    translate([16,42,hook_side])
    rotate([-90,0,0])
    simple_hook_array(10,2);
}

// assembly_power_strip_clip();


mode = "none";
// Exportable modules
if (mode == "clip_1") {
    clip_1();
} else if (mode == "clip_2") {
    clip_2();
}
