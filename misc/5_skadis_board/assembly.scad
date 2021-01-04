

include <skadis_board.scad>
include <screen_stuff/screen.scad>


skadis_board();

translate([37,94,skadis_board_width])
screen_clipped();