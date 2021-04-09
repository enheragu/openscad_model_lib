

/* [Cut table info] */

// How many tables and what is their width. Leave as 0 to ignore. (mm)
table_space = [20,15,0,0];

// Width of each spacer part (mm)
spacer_width = 15;

// Side from which balls are feeded into the bearing (either through inner or outer side)
base="S"; // [S:Single Side,B:Both sides]
 
/* [Other] */
// $fn resolution
fn = 150;

// Width and height of the geomety. max_dix is the maximumd difference allowed for the other part, sets the max slope
module base_geom(width, length, height, max_dif)
{
    //hull()
    {
        length_displacement = rands(min_value = length - max_dif*2, max_value = length, value_count = 1)[0];
        height2 = rands(min_value = height - max_dif, max_value = height, value_count = 1)[0];
        CubeFaces = [
            [0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]]; // left

        CubePoints = [
            [0,0,0],[length,0,0],[length,height,0],[0,height,0],
            [length/2-length_displacement/2,0,width],[length/2-length_displacement/2+length,0,width],[length/2-length_displacement/2+length,height2,width],[length/2-length_displacement/2,height2,width]];

        polyhedron(CubePoints,CubeFaces);
    }

}

base_geom(spacer_width,60,50,10);

for(index = [0:len(table_space)])
{
    if (table_space[index] != 0)
    {   
        cumulativesum = [ for (a=0, b=table_space[0]; a < len(table_space); a= a+1, b=b+table_space[a]) b];
        translate([0,0,cumulativesum[index]+spacer_width*(index+1)])
        base_geom(spacer_width,60,50,10);
    }
}
