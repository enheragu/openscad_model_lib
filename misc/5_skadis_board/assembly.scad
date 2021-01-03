

include <skadis_board.scad>
include <screen_stuff/screen.scad>


skadis_board();

translate([37,94,board_width])
screen_clipped();