include <skadis_param.scad>
include <skadis_simple_hook.scad>


screen_clip_width = screen_width+tolerance*2+screen_clip_wall*2;
screen_clip_length = screen_clip_size;
screen_clip_height = screen_clip_cover + tolerance + screen_clip_wall;

module screen()
{
    color("black")
    cube([screen_x,screen_y,screen_width]);
}


module screen_clip(translation = [0,0,0], rotation = [0,0,0])
{
    screen_clip_width = screen_width+tolerance*2+screen_clip_wall+screen_clip_wall_bottom;
    screen_clip_length = screen_clip_size;
    screen_clip_height = screen_clip_cover + tolerance + screen_clip_wall;

    // Remove screen hole
    translate(translation)
    rotate(rotation)
    color("white")
    difference()
    {
        union()
        {
            cube([screen_clip_length, screen_clip_height, screen_clip_width]);

            translate([screen_clip_height, 0, 0])
            rotate([0, 0, 90])
            cube([screen_clip_length, screen_clip_height, screen_clip_width]);

            // Back
            cube([screen_clip_size, screen_clip_size, screen_clip_wall_bottom]);


            // Rounded front
            difference()
            {
                translate([0, 0, screen_clip_width-screen_clip_wall])
                cube([screen_clip_height*2, screen_clip_height*2, screen_clip_wall]);

                translate([screen_clip_height*1.5, screen_clip_height*1.5, screen_clip_width-screen_clip_wall - 0.1])
                cylinder(d = screen_clip_height, h = screen_clip_wall + 0.2, $fn = fn);


                translate([screen_clip_height*1.5, 0, screen_clip_width-screen_clip_wall - 0.1])
                cube([screen_clip_height*2, screen_clip_height*2, screen_clip_wall + 0.2]);

                translate([0, screen_clip_height*1.5, screen_clip_width-screen_clip_wall - 0.1])
                cube([screen_clip_height*2, screen_clip_height*2, screen_clip_wall + 0.2]);
            }
        }
        // Screen empty Slot
        translate([screen_clip_wall,screen_clip_wall,screen_clip_wall_bottom])
        cube([screen_clip_length,screen_clip_length,screen_width+tolerance*2]);
    }
}

module hook_array(translation = [0,0,0])
{
    translate(translation)
    // Center it in the clip to adjust later from there
    translate([screen_clip_wall*3,screen_clip_length/2,0])
    translate([0,0,screen_clip_wall_bottom])
    rotate([-90,0,0])
    simple_hook_array(2,2);
}

// Needs to add the hook for the board, thats why they are splitted here
// Adds extra comment `make` me" for later exporting script. See Makefile to see how it works
module screen_clip_1(translation = [0,0,0], rotation = [0,0,0]) // `make` me"
{
    hook_array([-7,8,0]); // Translation to fit into board holes
    screen_clip(rotation = rotation);
}

module screen_clip_2(translation = [0,0,0], rotation = [0,0,0]) // `make` me"
{
    translate(translation)
    union()
    {
        translate([-screen_clip_length,0,0])
        hook_array([6,8,0]); // Translation to fit into board holes
        screen_clip(rotation = rotation);
    }
}

module screen_clip_3(translation = [0,0,0], rotation = [0,0,0]) // `make` me"
{
    translate(translation)
    union()
    {
        translate([0,-screen_clip_length,0])
        hook_array([-7,13,0]); // Translation to fit into board holes
        screen_clip(rotation = rotation);
    }
}

module screen_clip_4(translation = [0,0,0], rotation = [0,0,0]) // `make` me"
{
    translate(translation)
    union()
    {
        translate([-screen_clip_length,-screen_clip_length,0])
        hook_array([6,13,0]); // Translation to fit into board holes
        screen_clip(rotation = rotation);
    }
}

module screen_clipped()
{
    translate([screen_clip_wall+tolerance, screen_clip_wall+tolerance, screen_clip_wall+tolerance])
    screen();

    screen_clip_1();
    screen_clip_2(translation = [screen_x+screen_clip_wall*2,0,0], rotation = [0,0,90]);
    screen_clip_3(translation = [0,screen_y+screen_clip_wall*2,0], rotation = [0,0,-90]);
    screen_clip_4(translation = [screen_x+screen_clip_wall*2,screen_y+screen_clip_wall*2,0], rotation = [0,0,180]);
}

// screen_clipped();