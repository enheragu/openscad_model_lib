

/* [Other] */
fn = 150;
wall_width = 1.6;
tolerance = 0.4;
extra_height = 100;
insertion = 15;
inclination = 30;

// Small cuantity to ensure cutting though
epsilon = 0.1;


/* [Material info] */
marker_diameter = 13+tolerance*2;
bottle_diameter = 32+tolerance*2;


/* [Box Info] */
box_length = 125;
box_height = 70;
box_width = bottle_diameter+wall_width*1.5*2;



module cleaner(extra_height_in)
{
    paper_x = 29 + tolerance * 2;
    paper_z = box_height + tolerance * 3;
    paper_y = 52 + tolerance * 2;
    cube([paper_x, paper_y, paper_z + extra_height_in], center=true);
}

module bottle(extra_height_in)
{
    cylinder(h = box_height - wall_width*2, d = bottle_diameter, $fn = fn);
}

module marker(extra_height_in)
{
    cylinder(h = box_height - wall_width*2, d = marker_diameter, $fn = fn);
}

module stuff(extra_height_in)
{
    // color("red")
    translate([wall_width*1.5, wall_width*1.5, wall_width])
    union()
    {
        translate([marker_diameter/2, marker_diameter/2, 0]) marker(extra_height_in);
        translate([box_width-marker_diameter, marker_diameter*1.5+wall_width, 0]) marker(extra_height_in);
        translate([marker_diameter/2, marker_diameter*1.5+wall_width, 0]) marker(extra_height_in);
        translate([box_width-marker_diameter, marker_diameter/2, 0]) marker(extra_height_in);
        
        translate([bottle_diameter/2, box_length-bottle_diameter/2-wall_width*1.7*2, 0]) bottle(extra_height_in);
        translate([box_width/2-wall_width*1.5, box_length/2-wall_width*2.8, 0]) cleaner(extra_height_in);
    }
}



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

rotation = inclination; // atan2(insertion*3, box_length);

// Tolerance expands the insertion part
module box_base(box_width_in, box_length_in, box_height_in, wall_width_in, tolerance_in = 0.0)
{
    difference()
    {
        union()
        {
            // Base box
            difference()
            {   
                translate([-tolerance_in,-tolerance_in,-tolerance_in])
                filleted_rectangle(box_width_in+tolerance_in*2, box_length_in+tolerance_in*2, box_height_in+tolerance_in*2, box_length_in/15);

                rotate([0,rotation,0])
                translate([-wall_width_in*200,-wall_width_in*200, box_height_in*0.9])
                cube([box_width_in*300, box_length_in*300, box_height_in*200]);
            }
        }

        // Empty innner of the box
        inner_x = box_width_in - wall_width_in*2 - tolerance_in*2;
        inner_y = box_length_in - wall_width_in*2 - tolerance_in*2;
        inner_z = box_height_in;
        translate([wall_width_in + tolerance_in, wall_width_in + tolerance_in, wall_width_in])
        filleted_rectangle(inner_x, inner_y, box_height_in, inner_y/15);
    }
    
}


module base()
{

    // Wall support
    wall_attach_dim = [7, 7];
    wall_small_diam = 4;
    extra = 2;
    hole_width = wall_width + epsilon*4;

    difference()
    {   
        union()
        {
            box_base(box_width, box_length, box_height, wall_width, 0);
            difference()
            {
                filleted_rectangle(box_width, box_length, box_height*5/7, box_length/15);
                stuff(extra_height);
            
            }
        }

        // wall support
        translate([-epsilon, box_length/4, box_height-wall_small_diam-wall_attach_dim[1]-wall_width*3-extra])
        union()
        {
            translate([(hole_width)/2, 0, (wall_small_diam + wall_attach_dim[1] + extra)/2])
            cube([hole_width, wall_small_diam, wall_small_diam + wall_attach_dim[1] + extra], center = true);
        
            translate([(hole_width)/2, 0, (wall_attach_dim[1])/2])
            cube([hole_width, wall_attach_dim[0], wall_attach_dim[1]], center = true);
        }
        translate([-epsilon, box_length*3/4, box_height-wall_small_diam-wall_attach_dim[1]-wall_width*3-extra])
        union()
        {
            translate([(hole_width)/2, 0, (wall_small_diam + wall_attach_dim[1] + extra)/2])
            cube([hole_width, wall_small_diam, wall_small_diam + wall_attach_dim[1] + extra], center = true);
        
            translate([(hole_width)/2, 0, (wall_attach_dim[1])/2])
            cube([hole_width, wall_attach_dim[0], wall_attach_dim[1]], center = true);
        }
    }
}


// color("PowderBlue", 1) 
base();
