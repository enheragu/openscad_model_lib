


/* [Model settings] */
// Diameter of the wooden stick to use. Note that the hole model depends on this measure :) (mm)
wooden_stick_diam = 2;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. Note that some 
// of the pieces do not include this tolerance as they are supposed to fit tight (mm)
tolerance = 0.4;

/* [Other] */
// $fn resolution
fn = 150;

// Pot

module pot()
{
    difference()
    {
        d1 = wooden_stick_diam*15;
        d2 = wooden_stick_diam*20;
        h = wooden_stick_diam*15;
        union()
        {
            cylinder(d1= d1, d2 = d2, h = h, $fn = fn);

            sq_size_x = wooden_stick_diam*2;
            sq_size_z = wooden_stick_diam*3;
            relation_x = 0.6;
            relation_z = 0.6;
            translation_x = d2/2-sq_size_x*relation_x;
            translation_z = h-sq_size_z*relation_z;
            translate([0,0,translation_z])
            rotate_extrude(angle = 360, convexity = 2)
            translate([translation_x,0,0])
            square(size = [sq_size_x, sq_size_z]); 
        }
        // Stick hole
        translate([0,0,2*h/3+0.1])
        cylinder(d = wooden_stick_diam+tolerance, h = h/2, $fn = fn);
    }
}

// Leave


// Flower

module assembly()
{
    pot();
}

assembly();