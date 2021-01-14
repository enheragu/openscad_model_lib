

/* [Export settings] */
mode = "Assembly"; // [Assembly, Pot, Leaf, Flower]

/* [Model settings] */
// Diameter of the wooden stick to use. Note that the hole model depends on this measure :) (mm)
wooden_stick_diam = 2.8;

bezier_step = 0.03;

wall_width = 1;

/* [Printer settings] */
// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. Note that some 
// of the pieces do not include this tolerance as they are supposed to fit tight (mm)
tolerance = 0.4;

/* [Other] */
// $fn resolution
fn = 120;


// Quadratic Bezier curve (take advantage of dot notation index for 2d points :) )
// p1 and p2 are the starting and end points, pC is the control point to adjust the curve, use step as you would use the fn param
function quadBezierX(p1, pC, p2, step) = pow(1-step,2) * p1.x + ( 1-step)*2*step*pC.x+pow(step,2)*p2.x;
function quadBezierY(p1, pC, p2, step) = pow(1-step,2) * p1.y + ( 1-step)*2*step*pC.y+pow(step,2)*p2.y;
function quadBezierZ(p1, pC, p2, step) = pow(1-step,2) * p1.z + ( 1-step)*2*step*pC.z+pow(step,2)*p2.z;

function quadraticBezierPoint2D(p1,pC,p2,step) = [quadBezierX(p1, pC, p2, step), quadBezierY(p1, pC, p2, step)];
function quadraticBezierCurve2D(p1, pC, p2) = [for (step=[0:bezier_step:1]) quadraticBezierPoint2D(p1, pC, p2, step)];

function quadraticBezierPoint3D(p1,pC,p2,step) = [quadBezierX(p1, pC, p2, step), quadBezierY(p1, pC, p2, step), quadBezierZ(p1, pC, p2, step)];
function quadraticBezierCurve3D(p1, pC, p2) = [for (step=[0:bezier_step:1]) quadraticBezierPoint3D(p1, pC, p2, step)];


// Pot
module pot()
{
    difference()
    {
        d1 = wooden_stick_diam*9;
        d2 = wooden_stick_diam*14;
        h = wooden_stick_diam*12;
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
            rotate_extrude(angle = 360, convexity = 2, $fn = fn)
            translate([translation_x,0,0])
            square(size = [sq_size_x, sq_size_z]); 
        }
        // Stick hole
        translate([0,0,2*h/3+0.1])
        cylinder(d = wooden_stick_diam+tolerance, h = h/2, $fn = fn);
    }
}

// Leaf
module leaf(translation = [0,0,0])
{

    p1 = [0,0];
    p2 = [0,50];
    pC1 = [26,17];
    pC2 = [-26,17];

    points1 = concat([p1], quadraticBezierCurve2D(p1, pC1, p2), [p2]);
    points2 = concat([p1], quadraticBezierCurve2D(p1, pC2, p2), [p2]);

    translate(translation)
    difference()
    {
        translate([0,-wall_width*4,0])
        rotate([30,0,0])
        linear_extrude(height = wall_width, convexity = 10)
        union()
        {
            polygon(points1);
            polygon(points2);
        }
        // stick hole
        cylinder(d = wooden_stick_diam, h = wall_width*10, $fn = fn);
    }
}

module 2dline(points, point_diam)
{
    union()
    {
        for (index=[0:len(points)-2])
        {
            hull()
            {
                translate(points[index]) circle(point_diam, $fn = fn);
                translate(points[index+1]) circle(point_diam, $fn = fn);
            }
        }
    }
}

// Flower
module flower(translation = [0,0,0])
{
    // For a rotate extrude its better if all points are in the same cuadrant (X and Y > 0)
    p1 = [wall_width,wall_width];
    p2 = [7,35];
    pC = [20,2];

    points = quadraticBezierCurve2D(p1, pC, p2);
    points1 = quadraticBezierCurve2D(p1, [-pC.x,pC.y], [-p2.x,p2.y]);

    translate(translation)
    difference()
    {
        union()
        {
            // For some reason 360 fails -.- Make two partial instead
            rotate_extrude(angle = 270, convexity = 10, $fn = fn)
            2dline(points,wall_width);
            
            rotate([0,0,180])
            rotate_extrude(angle = 270, convexity = 10, $fn = fn)
            2dline(points,wall_width);

            // Make some structure for the stick :)
            diam = pC.x*2/3;
            translate([0,0,diam/2]) sphere(d = diam, $fn = fn);
        }
        // Hole for the stick
        h = wall_width*5;
        translate([0,0,-0.1]) cylinder(d = wooden_stick_diam, h = h, $fn = fn);
    }
}

module assembly()
{
    color("white")
    pot();
    color("green")
    leaf([0,0,50]);
    color("red")
    flower([0,0,70]);
}


// Exportable modules
if (mode == "Assembly") {
    assembly();
} else if (mode == "Pot") {
    pot();
} else if (mode == "Leaf") {
    leaf();
} else if (mode == "Flower") {
    flower();
}