
// Tag minimum height. Each color adds this height to the piece
tag_width_min = 1;

// width of the red string around the tag
wall_width = 1;

// Text to appear in the tag
string = "Mamá";

// Depending on the text you input, the witdh can change a lot. Change this value to adjust the tag length a bit
width_compensation = 0; // [-70:0.1:70]

// Depending on the string introduced text might change a bit. Compensate this to final adjust centering of the text
height_compensation = 0; // [-10:0.1:10]

/* [Other] */
// Small cuantity to ensure cutting though
epsilon = 0.1;

// $fn resolution
fn = 150;

module filleted_rectangle(size_x,size_y,size_z, round_rad)
{
    hull()
    {   
        linear_extrude(height = size_z) translate([round_rad,round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([size_x-round_rad,round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([round_rad,size_y-round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([size_x-round_rad,size_y-round_rad,0]) circle(d= round_rad*2, $fn = fn);
    }
}



module tag(name, min_ww, wall_width)
{
    margin = 7;
    width_hat = 25;
    width = len(name)*16 + margin*2 + width_hat + width_compensation;
    height = 31;

    white_height = min_ww;
    red_height = min_ww*1.5;
    white_top_height = min_ww*2;

    color(c = "white") 
    filleted_rectangle(width,height,min_ww, margin);

    color("red")
    translate([margin,margin+height_compensation,0])
    linear_extrude(red_height)
    text( name, size= 17);

    color("red")
    difference()
    {
        filleted_rectangle(width,height,red_height, margin);
        translate(v = [wall_width, wall_width, epsilon]) 
        filleted_rectangle(width-wall_width*2,height-wall_width*2,red_height+epsilon, margin-wall_width);
    }

    translate(v = [width-width_hat-margin/2,0, 0]) 
    scale([0.11,0.11,1])
    union() 
    {
        color("red")
        linear_extrude(height = red_height) 
        import("./svg/christmas_hat_external.svg", center = false, dpi = 96, $fn = 100);
        color("white")
        linear_extrude(height = white_top_height) 
        import("./svg/christmas_hat_white.svg", center = false, dpi = 96, $fn = fn);
    }
}

tag(string, tag_width_min, wall_width);