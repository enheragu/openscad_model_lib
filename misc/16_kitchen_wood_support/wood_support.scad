


/* [Support Info] */

// bar diameter + 2*tolerance
wood_diam = 19.8; // 0.1

// Box length (inner space) (mm)
support_height = 70;
// 70mm -> Print 2 (first uper)
// 74mm -> Print 2 (first mid)
// 80mm -> Print 2 (first lower)
// 63mm -> Print 2 (second uper)
// 60mm -> Print 2 (second mid)
// 90mm -> Print 2 (second lower)
// 35mm -> Print 2 (third uper)
// 80mm -> Print 2 (third mid)
// 100mm -> Print 2 (third lower)

screw_diam = 3.4;

screw_head_diam = 6.5;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;

/* [Other] */

// $fn resolution
fn = 150;


rotate(a = 90, v = [1,0,0]) 
difference() 
{
    cube(size = [wood_diam, wood_diam*2/3, support_height-wood_diam/8]);

    translate(v = [wood_diam/2, wood_diam + tolerance, support_height]) 
    rotate(a = 90, v = [1,0,0]) 
    cylinder(h = wood_diam + tolerance * 2, r = wood_diam/2, $fn = fn);

    translate(v = [wood_diam/2, -tolerance, support_height/2]) 
    rotate(a = 90, v = [-1,0,0]) 
    union()
    {
        cylinder(h = wood_diam + tolerance * 2, r = screw_diam/2, $fn = fn);
        translate(v = [0,0, wood_diam/3]) 
        cylinder(h = wood_diam/2 + tolerance * 2, r = screw_head_diam/2, $fn = fn);
    }
}
