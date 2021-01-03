include <../skadis_param.scad>
include <../skadis_simple_hook.scad>
include <./../../../utils/filleted_rectangle.scad>

speaker_body_length = 49.8;
speaker_body_height = 15.11;
speaker_body_width = 6.4;

speaker_attachment_length = 7.5;
speaker_attachment_height = 8;
speaker_attachment_width = 1.5;
z_elevation = 3.4;

speaker_length = speaker_body_length + speaker_attachment_length*2;
speaker_height = speaker_body_height;
speaker_width = speaker_body_width;


clip_length = speaker_length + tolerance*2 + clip_wall*2;
clip_height = speaker_height + tolerance*2 + clip_wall_bottom*2;
clip_width = speaker_width + tolerance*2 + clip_wall;

module base_speaker(translation = [0,0,0])
{
    translate(translation)
    translate([speaker_attachment_length,0,0])
    color("black")
    union()
    {
        cube([speaker_body_length, speaker_body_height, speaker_body_width]);

        translate([-speaker_attachment_length,speaker_body_height/2-speaker_attachment_height/2,z_elevation])
        cube([speaker_attachment_length, speaker_attachment_height, speaker_attachment_width]);

        translate([speaker_body_length,speaker_body_height/2-speaker_attachment_height/2,z_elevation])
        cube([speaker_attachment_length, speaker_attachment_height, speaker_attachment_width]);
    }
}


module negative_base_speaker(translation = [0,0,0])
{
    enlarge_speaker_length = speaker_length + tolerance * 2; // adds tolerance at both sides
    enlarge_speaker_height = speaker_height + tolerance * 2; // adds tolerance at both sides
    // Ensure cut through. Adds tolerance only in one of the sides, the other is oppened
    // Adds clip wall of the speaker negative :)
    enlarge_speaker_width = speaker_width + 0.2 + tolerance + 0.1;
    
    translate([clip_length/2 - enlarge_speaker_length/2, clip_height/2 - enlarge_speaker_height/2, -0.1])
    //color("black")
    union()
    {
        color("black")
        resize([enlarge_speaker_length, enlarge_speaker_height, enlarge_speaker_width])
        union()
        {
            // Atatchments to go throug
            translate([0,speaker_body_height/2-speaker_attachment_height/2,0])
            cube([speaker_attachment_length, speaker_attachment_height, speaker_body_width-speaker_attachment_width]);

            translate([speaker_body_length+speaker_attachment_length,speaker_body_height/2-speaker_attachment_height/2,0])
            cube([speaker_attachment_length, speaker_attachment_height, speaker_body_width-speaker_attachment_width]);

            // Cable output space
            translate([speaker_body_length+speaker_attachment_length,0,0])
            cube([speaker_attachment_length, speaker_attachment_height, speaker_body_width-speaker_attachment_width]);

            base_speaker(translation);
        }

        // Speaker hole
        diameter = 13;
        heigth = 23;
        color("red")
        translate([13,enlarge_speaker_height/2 - diameter/2,0])
        filleted_rectangle(heigth,diameter,speaker_width+clip_wall*2+0.2,diameter/2);       
    }
}

module speaker_clip()
{
    union()
    {
        difference()
        {
            // Add expanded board
            diameter = 10;
            color("white", 0.5)
            filleted_rectangle(clip_length,clip_height,clip_width,diameter/2);
            
            negative_base_speaker();
        }
        
        translate([25,tolerance/2,side])
        rotate([0,0,90])
        rotate([-90,0,0])
        simple_hook_array(1,2);
    }
}

 speaker_clip();
// negative_base_speaker();

mode = "none";
// Exportable modules
if (mode == "speaker_clip") {
    speaker_clip();
}