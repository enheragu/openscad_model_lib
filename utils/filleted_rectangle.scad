

module filleted_rectangle(size, round_rad, center = false)
{
    size_x=size[0];
    size_y=size[1];
    size_z=size[2];
    center_translation = center? [-size_x/2, -size_y/2, -size_z/2] : [0,0,0];
    translate(v = center_translation) 
    hull()
    {   
        linear_extrude(height = size_z) translate([round_rad,round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([size_x-round_rad,round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([round_rad,size_y-round_rad,0]) circle(d= round_rad*2, $fn = fn);
        linear_extrude(height = size_z) translate([size_x-round_rad,size_y-round_rad,0]) circle(d= round_rad*2, $fn = fn);
    }
}