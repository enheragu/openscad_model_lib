
include <./box_and_lid.scad>


/* [Box Info] */

box_width = 138;
box_length = 90;
box_height = 153;
wall_width = 3;
tolerance = 0.4;
extra_height = 100;
insertion = 8;
inclination = 20;

/* [Other] */
export_filled = "L"; //[L:Lid, B:Base, A:Assembly, N:None]

module little_jar(extra_height_in)
{
    diameter = 45 + tolerance * 3;
    height = 52 + tolerance * 3;
    cylinder(h = height + extra_height_in, d = diameter, $fn = fn);
}

module bottle(extra_height_in)
{
    diameter = 49 + tolerance * 3;
    height = 139 + tolerance * 3;
    cylinder(h = height + extra_height_in, d = diameter, $fn = fn);
}

module tape(extra_height_in)
{
    diameter = 36 + tolerance * 3;
    height = 16*2 + tolerance * 3;
    cylinder(h = height + extra_height_in, d = diameter, $fn = fn);
}

module paper(extra_height_in)
{
    paper_x = 78 + tolerance * 3;
    paper_z = 55 + tolerance * 3;
    paper_y = 30 + tolerance * 3;
    cube([paper_x, paper_y, paper_z + extra_height_in]);
}

module aquarelles_box(extra_height_in)
{
    paper_x = 20 + tolerance * 3;
    paper_y = 64 + tolerance * 3;
    paper_z = 130 + tolerance * 3;
    cube([paper_x, paper_y, paper_z + extra_height_in]);
}

module bandeja(extra_height_in)
{
    paper_x = 86 + tolerance * 3;
    paper_y = 15 + tolerance * 3;
    cube([paper_x, paper_y, paper_x + extra_height_in]);
}

module lapiz(extra_height_in)
{
    cylinder(h = box_height - wall_width*2, d = 11, $fn = fn);
}

module stuff(extra_height_in)
{
    color("red")
    translate([wall_width*2, wall_width*2, wall_width])
    union()
    {
        aquarelles_box(extra_height_in);

        translate([30, 0, 0]) bandeja(extra_height_in);

        translate([50, 53, 0]) bottle(extra_height_in);

        translate([100, 47, 0]) tape(extra_height_in);

        translate([100, 47, 36]) little_jar(extra_height_in);

        translate([30, 0, 90]) paper(extra_height_in);

        translate([6, 73, 0]) lapiz(extra_height_in);

        translate([21, 73, 0]) lapiz(extra_height_in);
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
    translate([0,-10,155])
    rotate([-180,0,0])
    difference()
    {
        translate([box_width,0,box_height])
        rotate([180,0,180])
        union()
        {
            filleted_rectangle(box_width, box_length, box_height*4/7*(1-base_lid_relation), box_length/10);
            box_lid(box_width, box_length, box_height, wall_width, tolerance);
        }
        stuff(0);
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