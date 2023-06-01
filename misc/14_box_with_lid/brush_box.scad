
include <./box_and_lid.scad>


/* [Box Info] */

wall_width = 4;
tolerance = 0.4;
brush_diameter = 8.5;

extra_height = 100;
insertion = 15;
inclination = 20;

box_width = 8.5 * 3 + 2 + 4 * 2 + 0.4 * 2;
box_length = 8.5 * 2 + 1 + 4 * 2 + 0.4 * 2;
box_height = 210 + 4 * 2 + 0.4 * 2;

/* [Other] */
export_filled = "L"; //[L:Lid, B:Base, A:Assembly, N:None]

module stuff(extra_height_in)
{
    color("red")
    translate([wall_width*2.1, wall_width*2.1, wall_width])
    union()
    {
        margin = 1;
        cylinder(h = box_height - wall_width*2, d = 8.5, $fn = fn);
        
        translate([0, brush_diameter+margin, 0]) cylinder(h = box_height - wall_width*2, d = 8.5, $fn = fn);
        translate([brush_diameter+margin, brush_diameter+margin, 0]) cylinder(h = box_height - wall_width*2, d = 8.5, $fn = fn);
        translate([(brush_diameter+margin)*2, (brush_diameter+margin), 0]) cylinder(h = box_height - wall_width*2, d = 8.5, $fn = fn);
        translate([brush_diameter+margin, 0, 0]) cylinder(h = box_height - wall_width*2, d = 8.5, $fn = fn);
        translate([(brush_diameter+margin)*2, 0, 0]) cylinder(h = box_height - wall_width*2, d = 8.5, $fn = fn);
    }
}

module base()
{
    union()
    {   
        box_base(box_width, box_length, box_height, wall_width, 0);
        difference()
        {
            filleted_rectangle(box_width, box_length, box_height*3/7, box_length/10);
            stuff(extra_height);
        }
    }
}


module lid()
{
    // translate([0,-10,155])
    // rotate([-180,0,0])
    difference()
    {
        // translate([box_width,0,box_height])
        // rotate([180,0,180])
        union()
        {
            //filleted_rectangle(box_width, box_length, box_height*4/7*(1-base_lid_relation), box_length/10);
            box_lid(box_width, box_length, box_height, wall_width, tolerance);
        }

        translate([+8.5,0,15])
        rotate([0,20,0])
        union()
        {
            spacer = 5;
            for(y = [0 : spacer : spacer*4])
            {
                for(x = [0 : spacer : spacer*4])
                {
                    translate([x - y / 3, box_length + tolerance, y]) rotate([90,0,0]) cylinder(h = box_length + tolerance * 2, d = 3, $fn = fn);
                }
            }
        }
    }
}

if (export_filled == "L")
{
    lid();
}
else if (export_filled == "B")
{
    base();
}
else if (export_filled == "A")
{
    // Display assembly
    lid();
    base();
}
else
{

}