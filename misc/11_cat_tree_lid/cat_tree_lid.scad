include <./../../utils/filleted_cylinder.scad>

/* [Tube settings] */
outer_diameter = 75;

inner_diameter = 69;

wall_width = 4;

insert_length = 26;

/* [Mechanical/extra parts] */

// Nut and head screw (both hexagonal) circunscribed circunference diameter (mm)
head_nut_diam = 14.6;

head_nut_heigth = 7;

screw_metric_diam = 7.8;

rope_diam_width = 7;

wood_screw_metric = 5;

// Use screw length and wood width to add extra plastic support to match both of them
wood_screw_length = 30;

wood_width = 18;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.5;

/* [Other] */
// $fn resolution
fn = 150;

module base_obj()
{
    union()
    {
        fillete_cylinder(outer_diameter, wall_width, wall_width/2);

        translate([0,0,0.1])
        difference()
        {
            rotate([180,0,0])
            fillete_cylinder(inner_diameter, insert_length, wall_width/2);

            translate([0,0,-wall_width])
            rotate([180,0,0])
            cylinder(d = inner_diameter-wall_width, h = insert_length+0.1, $fn = fn);
        }
    }
}

module basic_lid()
{
    difference()
    {
        base_obj();
        
        rotate([180,0,0])
        translate([0,0,-wall_width-0.1])
        cylinder(d = screw_metric_diam+tolerance, h = wall_width*2+0.2, $fn = fn);

        hole_heigth = insert_length+wall_width;
        hole_width = rope_diam_width+tolerance*3;
        translate([head_nut_diam/2,-hole_width/2,-hole_heigth+tolerance*2])
        cube([outer_diameter+wall_width*2,hole_width,hole_heigth]);
    }
}

// lid between modules
module intermediate_lid()
{
    union()
    {
        basic_lid();
        // screw/nut support
        translate([0,0,-wall_width+0.2])
        rotate([180,0,0])
        difference()
        {
            cylinder(d = head_nut_diam+wall_width*2, h = head_nut_heigth, $fn = 6);
            translate([0,0,-0.1])
            cylinder(d = head_nut_diam+tolerance, h = head_nut_heigth+0.2, $fn = 6);
        }
    }
}

// Lid between base and first module
module base_lid()
{
    // Screew to wood insertion
    function arcAngle(radious, angle,step) = [ for (a = [0 : step : angle]) [radious*cos(-a),radious*sin(-a)] ];

    height = wood_screw_length - wood_width + wall_width;
    rad = inner_diameter/2*2/3;

    difference()
    {
        union()
        {
            basic_lid();
            rotate([0,0,90])
            for (point = arcAngle(rad,360,360/6))
            {
                translate([point.x,point.y,0])  
                rotate([0,180,0])
                fillete_cylinder(wood_screw_metric + wall_width*2, height, wall_width/2);
            }
        }

        // holes have to go through the hole piece
        rotate([0,0,90])
        for (point = arcAngle(rad,360,360/6))
        {
            translate([point.x,point.y,0])  
            translate([0,0,-height-0.1])
            cylinder(d = wood_screw_metric, h = height*2+0.2, $fn = fn);
        }
    } 
}

module fake_intermediate_step()
{
    height = 18.2;
    difference()
    { 
        union()
        {
            fillete_cylinder(outer_diameter, height/2, wall_width/2);
            rotate([180,0,0])
            fillete_cylinder(outer_diameter, height/2, wall_width/2);
        }
        translate([0,0,-height/2-0.1])
        cylinder(d = screw_metric_diam+tolerance, h = height+0.2, $fn = fn);
    }
}


module extension()
{
    insert_multiplier = 2.5;
    difference()
    {
        fillete_cylinder(inner_diameter, insert_length*insert_multiplier, wall_width/2);
       
        // Remove base obj
        //translate([0,0,0.])
        difference()
        {
            translate([0,0,-0.1])
            fillete_cylinder(inner_diameter+0.1, insert_length, wall_width/2);

            translate([0,0,-0.1])
            cylinder(d = inner_diameter-wall_width-tolerance, h = insert_length+0.2, $fn = fn);
        }

        // Remove inner part
        translate([0,0,-0.1])
        cylinder(d = inner_diameter-wall_width*2, h = insert_length*insert_multiplier+0.2, $fn = fn);

        hole_heigth = insert_length*insert_multiplier+wall_width;
        hole_width = rope_diam_width+tolerance*3;
        translate([head_nut_diam/2,-hole_width/2,-0.1])
        cube([outer_diameter+wall_width*2,hole_width,hole_heigth]);
    }
}

extension();
/*union()
{
    color("grey")
    extension();

    translate([0,0,-0.2])
    rotate([180,0,0])
    color("white",0.8)
    intermediate_lid();
}*/
