// Raspberry PI3 Model A+ by enheragu
// Date: 19-12-2020

include <../pin_header_connector/2_male_pin.scad>;


// Extra marging added to perform cutting and ensure complete cut
margin = 0.1;
2margin = margin*2;

// Default resolution for shapes
fn_resolution = 150;

board_width = 1.6;

hole_distance_x = 58;
hole_distance_y = 49;
half_hdx = hole_distance_x/2;
half_hdy = hole_distance_y/2;
hole_diameter = 2.7;
round_border_diam = 7;

// Function to get hole positions for screws
function get_hole_positions() = [
    [-half_hdx,-half_hdy,0],
    [-half_hdx,half_hdy,0],
    [half_hdx,half_hdy,0],
    [half_hdx,-half_hdy,0]
    ];


module rpy_chip()
{
    // rpy chip
    rpy_x = 10.6;
    rpy_y = 13;
    rpy_h = 2.3;

    color([196/255,202/255,206/255])
    translate([0,-rpy_y,0])
    cube([rpy_x,rpy_y,rpy_h]);
}

module broadcom_chip() 
{   
    //  broadcom chip
    z = 2.22;
    color([196/255,202/255,206/255])
    union()
    {
        side = 14;
        side_chaf = 12;
        chanfer_size = side_chaf/8;
        circunscript_diameter=sqrt(pow(side_chaf,2)+pow(side_chaf,2));
        union()
        {
            cube([side,side,z/2]);
            translate([side/2,side/2,z/2])
            rotate([0,0,45])
            cylinder(h=z/2, d1=circunscript_diameter, d2=circunscript_diameter-chanfer_size*2, $fn=4);
        }
    }
}

module sd_case()
{
    sd_x = 12.4;
    sd_y = 12.9;
    sd_width = 1.4;
    color([196/255,202/255,206/255])
    // center and put below board
    translate([0,-sd_y/2,-sd_width])
    cube([sd_x,sd_y,sd_width]);
}

module base_board()
{
    color([106/255, 207/255, 101/255])
    difference()
    {
        // Board
        hull()
        {
            for(position = get_hole_positions())
            {
                translate(position)
                cylinder(d = round_border_diam, h = board_width, $fn = fn_resolution);
            }
        }

        // Screw Holes
        for(position = get_hole_positions())
        {
            translate(position)
            translate([0,0,-margin])
            cylinder(d = hole_diameter, h = board_width+2margin, $fn = fn_resolution);
        }
    }
}
module board()
{
    union()
    {
        base_board();

        /* Positionate and draw pin_array */
        translate([-plastic_square_side*10,half_hdy-plastic_square_side,plastic_square_side])
        male_pin_array(20,2);

        /* Positionate and draw rpy_chip */
        rpy_pos_border = 6.9;
        hole_distance = rpy_pos_border-round_border_diam/2;
        translate([-half_hdx+hole_distance,half_hdy-hole_distance,board_width])
        rpy_chip();

        /* Positionate and draw broadcom_chip */
        border_distance_x = 19.4;
        border_distance_y = 31.7;
        bc_pos_x = -half_hdx-round_border_diam/2+border_distance_x;
        bc_pos_y = half_hdy+round_border_diam/2-border_distance_y;
        translate([bc_pos_x,bc_pos_y,board_width])
        broadcom_chip();

        /* Positionate SD thing */
        sd_pos_x = -half_hdx-round_border_diam/2;
        translate([sd_pos_x,0,0])
        sd_case();
    }
}


module raspberry_pi_3a_plus()
{
    translate([half_hdx+round_border_diam/2,half_hdy+round_border_diam/2,0])
    board();
}

//board();