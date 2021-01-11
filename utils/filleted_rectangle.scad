

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