
// Note that 3d hull operation with 8 spheres is quite resources consuming
module rounded_rectangle(size_x,size_y,size_z, round_rad)
{
    hull()
    {   
        // 4 corners
        x_y_points = [[round_rad,round_rad],[size_x-round_rad,round_rad],[round_rad,size_y-round_rad],[size_x-round_rad,size_y-round_rad]];

        z_points = [round_rad, size_z-round_rad];

        for(point = x_y_points)
        {
            hull()
            {
                for (point_z = z_points)
                {
                    translate([point[0], point[1], point_z])
                    sphere(d= round_rad*2, $fn = fn);
                }
            }
        }
    }
}