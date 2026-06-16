
/** [Pegboard top Info] **/
bar_diam = 20;
wall_width = 1;
height = 12;

/** [Other] **/
fn=150;

tolerance = 0.4;

// Small cuantity to ensure cutting though
epsilon = 0.1;

module pegboard_top() {
    translate([0, 0, height])
    cylinder(d=bar_diam+wall_width*6, h=wall_width, $fn=fn);
    difference()
    {
        cylinder(d=bar_diam+wall_width*2, h=height, $fn=fn);
        translate([0, 0, -epsilon])
        cylinder(d=bar_diam, h=height+epsilon*2, $fn=fn);
    }
}

pegboard_top();