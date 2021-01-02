

include <skadis_board.scad>
include <screen.scad>


skadir_board();

translate([37,94,board_width])
screen_clipped();