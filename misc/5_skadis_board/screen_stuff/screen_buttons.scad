include <../skadis_param.scad>
include <../skadis_simple_hook.scad>
include <./../../../utils/filleted_rectangle.scad>

keypad_length = 15.2;
keypad_height = 107.9;
keypad_width = 1.5;

button_side = 6.2;
button_height = 3.8;
button_cylinder = 3.52;
button_cylinder_height = 3.5;

button_feet_length = 1.3;
button_feet_height = 9.96;
button_feet_width = 1.8;

cable_connection_length = 13.15;
cable_connection_height = 5.93;
cable_connection_width = 3.7;

clip_length = keypad_length + tolerance*2 + clip_wall + clip_wall_bottom;
clip_height = keypad_height - cable_connection_height + tolerance + clip_wall;
clip_width = keypad_width + tolerance*2 + clip_wall;

module button(translation = [0,0,0])
{
    translate(translation)
    union()
    {
        color("black")
        translate([button_side/2,button_side/2,button_height])
        cylinder(d = button_cylinder, h = button_cylinder_height, $fn = fn);
        color("grey")
        cube([button_side,button_side,button_height]);

        color("silver")
        translate([0.8,button_side/2-button_feet_height/2,0 ])
        cube([button_feet_length, button_feet_height, button_feet_width]);

        color("silver")
        translate([button_side-button_feet_length-0.8,button_side/2-button_feet_height/2,0 ])
        cube([button_feet_length, button_feet_height, button_feet_width]);
    }
}

module board(translation = [0,0,0])
{
    translate(translation)
    union()
    {
        // PDB board
        color([106/255, 207/255, 101/255])
        cube([keypad_length, keypad_height, keypad_width]);

        // Buttons
        but_translate_1 = [3.4,9.1,keypad_width]; button(but_translate_1);
        but_translate_2 = but_translate_1 + [0,button_side+15.68,0]; button(but_translate_2);
        but_translate_3 = but_translate_2 + [0,button_side+11.75,0]; button(but_translate_3);
        but_translate_4 = but_translate_3 + [0,button_side+11.75,0]; button(but_translate_4);
        but_translate_5 = but_translate_4 + [0,button_side+11.75,0]; button(but_translate_5);

        // Cable connection
        color("#FFF0C9")
        translate([keypad_length/2-cable_connection_length/2, keypad_height-cable_connection_height, keypad_width])
        cube([cable_connection_length, cable_connection_height, cable_connection_width]);
    }
}

module clip()
{
    union()
    {
        difference()
        {
            // Add expanded board
            diameter = 10;
            color("white", 0.5)
            filleted_rectangle(clip_length,clip_height,clip_width,diameter/2);         
            //cube([clip_length,clip_height,clip_width]);
            
            enlarge_board_length = keypad_length + tolerance * 2; // adds tolerance at both sides
            enlarge_board_height = keypad_height + tolerance * 2; // adds tolerance at both sides
            enlarge_board_width = keypad_width + button_height + button_cylinder_height + tolerance + 0.1; // Ensure cut through. Adds tolerance only in one of the sides, the other is oppened
            resize([enlarge_board_length, enlarge_board_height, enlarge_board_width])
            board([clip_length/2-enlarge_board_length/2, clip_wall, -0.1]);
        }
        
        translate([tolerance/2,70,side])
        rotate([-90,0,0])
        simple_hook_array(1,2);
    }
}

module screen_button_clipped()
{
    clip();
    board([clip_length/2-keypad_length/2, clip_wall, 0]);
}

 screen_button_clipped();

mode = "none";
// Exportable modules
if (mode == "clip") {
    clip();
}