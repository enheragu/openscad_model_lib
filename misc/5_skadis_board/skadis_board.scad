include <skadis_param.scad>
include <./../../utils/filleted_rectangle.scad>

module board_base()
{
    filleted_rectangle(board_x,board_y,board_width,board_round);  
}

module single_hole()
{ 
    hull()
    {   
        linear_extrude(height = board_width+0.2) translate([board_hole_x/2,board_hole_y-board_hole_x/2,0]) circle(d= board_hole_x, $fn = fn);
        linear_extrude(height = board_width+0.2) translate([board_hole_x/2,board_hole_x/2,0]) circle(d= board_hole_x, $fn = fn);
    }
}

module hole_matrix(x_rep, y_rep, init_pose)
{
    // Starts in 0, reduce 1
    for(x = [0:x_rep-1])
    {
        // Starts in 0, reduce 1
        for(y = [0:y_rep-1])
        {
            tranlate_x = x * (35 + board_hole_x);
            tranlate_y = y * (24.8 + board_hole_y);
            translate([tranlate_x,tranlate_y,0])
            translate(init_pose) single_hole();
        }
    }
}

module skadis_board()
{
    color("#82490b")
    difference()
    {
        board_base();
        hole_matrix(19,13,[17.4,32.4,-0.1]);
        hole_matrix(18,14,[37.5,12.8,-0.1]);
    }
}

// skadis_board();