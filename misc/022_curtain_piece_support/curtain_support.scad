include <BOSL2/std.scad>

/* [Curtain support Info] */

// Bounding box figure
base_size = [29.7,19.7]; // [28.7,19.7];
upper_size = [31,20]; // [29.7,20];
height = 17.5;

// Big inner Cut
base_size_cut = [16,20];
upper_size_cut = [16.6,20];
height_cut = 5.5;
cut_distance = 6.35;

// Support sizes
height_sup = 3.2;
base_sup = [24.6,20];
sup_distance = 12.26;

// Upper cut
upper_sup_cut = [22,62,20];
upper_cut_height = 3;
upper_cut_dist = 15.64;

// Circular hole side
hole_z = 6.55;
hole_diam = 5.7;

// Circular hole bottom
hole_x_y = [8.2,7.68];
hole_bot_diam = 4.3;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

/* [Other] */

// Small cuantity to ensure cutting though
epsilon = 0.1;

// $fn resolution
fn = 100;


module piece()
{
    difference() 
    {
        translate([-1,0,0])
        prismoid(size1=base_size, size2=upper_size, h=height);
        
        translate(v = [0,0,cut_distance])
        prismoid(base_size_cut, upper_size_cut, height_cut);
        
        translate(v = [0,0,sup_distance+height_sup/2-tolerance/2-epsilon])
        cuboid(
            [base_sup[0],base_sup[1],height_sup+tolerance], rounding=height_sup,
            edges=[BOT+RIGHT,BOT+LEFT],
            $fn=fn
        );

        translate(v = [0,0,upper_cut_dist+upper_cut_height/2-tolerance/2-epsilon])
        cube([upper_sup_cut[0], upper_sup_cut[1], upper_cut_height+tolerance], center = true);


        translate([-max(base_size),0,hole_z+hole_diam/2-tolerance-epsilon])
        rotate([0,90,0])
        cylinder(d= hole_diam + tolerance, h=max(base_size)*2, $fn = fn);
        
        translate([max(base_size)/2-hole_x_y[0]-hole_bot_diam/2,0,-epsilon])
        cylinder(d= hole_bot_diam + tolerance, h=height, $fn = fn);
    }
}

piece();


