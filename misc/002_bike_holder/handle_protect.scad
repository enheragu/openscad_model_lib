
/* [Holder Shape] */
// OUter piece shape, either it is chamfered or rounded
piece_shape="C"; //[C:Cone,R:Rounded]

// height of the piece (hole_height + bottom_height = piece height) (mm)
hole_height  = 10;

// Height of the solid base (hole_height + bottom_height = piece height) (mm)
bottom_height = 3;

// Also the wall size both between hole and reverse fillet start (mm)
wall_size = 2;

// Diametre of the bike handlebar (mm)
handle_diam = 28;

// Diameter of te piece at the base if cone shape is selected
piece_diameter = 52;

// Extra size to fit the handle (hole diameter = handle_diam + margin)
margin = 5;

/* [Screw hole] */
// Make the hole or not
make_hole = true;

// Screw head shape
head_shape="C"; //[C:Cone,S:Straigth Cylinder]

// Scre hole (hole in the center for the piece to be attached) (mm)
screw_metric = 4;

// Head of the scre head to make space for it (desinged for conic head screws) (mm)
screw_head_height = 4;

// Diameter of the screw (mm)
screw_head_diam = 8;

// $fn resolution
fn = 150;

module toroid(diameter, section_diameter)
{
        rotate_extrude(convexity = 10, $fn = fn)
        translate([diameter/2, 0, 0])
        circle(d=section_diameter);
}


module handle_protect_rounded()
{
    piece_height = hole_height + bottom_height;
    piece_diam = handle_diam + margin + wall_size + piece_height*2;
    difference()
    {
        difference()
        {
            cylinder(d = piece_diam, h = piece_height, $fn = fn);
            translate([0,0,wall_size])
            // Adds *1.1 to ensure cutting
            cylinder(d = handle_diam + margin, h = hole_height*1.1, $fn=fn);
        }
        translate([0,0,piece_height])
        toroid(piece_diam, (piece_height)*2-wall_size);
    }
}


module handle_protect_cone()
{
    piece_height = hole_height + bottom_height;
    piece_diam_1 = piece_diameter;
    piece_diam_2 = handle_diam + margin + wall_size*2;
    difference()
    {
        union()
        {
            cylinder(d = piece_diam_1, h = wall_size, $fn = fn);
            translate([0,0,wall_size])
            cylinder(d1 = piece_diam_1, d2 = piece_diam_2, h = piece_height - wall_size, $fn = fn);
        }
        translate([0,0,bottom_height])
        cylinder(d = handle_diam + margin, h = hole_height*1.1, $fn=fn);
    }
}

module screw_hole()
{
    diam_1 = (head_shape == "C")?screw_metric:screw_head_diam;
    diam_2 = screw_head_diam;

    // Adds 0.1 to ensure complete cutting
    translate([0,0, (bottom_height - screw_head_height)+0.1])
    cylinder(d1 = diam_1, d2 = diam_2, h = screw_head_height, $fn = fn);
    translate([0,0, -0.1])
    cylinder(d = screw_metric, h = wall_size+0.1, $fn = fn);
}



if(make_hole)
{
    difference()
    {
        if(piece_shape == "R") handle_protect_rounded();
        else  handle_protect_cone();
        screw_hole();
    }
}
else
{
        if(piece_shape == "R") handle_protect_rounded();
        else  handle_protect_cone();
}