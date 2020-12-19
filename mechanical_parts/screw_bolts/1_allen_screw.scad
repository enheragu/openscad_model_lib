// Customizable Allen head screw/bolt by enheragu
// Date: 19-12-2020

// metric tag name, head diameter, screw diameter, head heigth, diameter of head hex hole
metrics = [
["M1.6", 3.00, 1.60, 1.60, 1.733],
["M2", 3.80, 2.00, 2.00, 1.733],
["M2.5", 4.50, 2.50, 2.50, 2.303],
["M3", 5.50, 3.00, 3.00, 2.873],
["M4", 7.00, 4.00, 4.00, 3.443],
["M5", 8.50, 5.00, 5.00, 4.583]
];
// These metric data has been extracted from https://www.fasteners.eu/standards/DIN/912/


fn_resolution = 150;

function getIndex(type) = ([for(metric = metrics) if(metric[0] == type) metric]);
function is_undef (a) = (undef == a);


// Negative to make allen screw holes in other models
module allen_screw_negative(type, length, tolerance_diam = 0, tolerance_length = 0)
{
    match = getIndex(type)[0];
    
    // Head
    head_diam = match[1];
    screw_diam = match[2];
    head_heigth = match[3];
    hex_diam = match[4];

    echo("type: ", type);
    echo("match: ", match);
    echo("head_diam: ", head_diam);
    echo("screw_diam: ", screw_diam);
    echo("head_heigth: ", head_heigth);
    
    if(is_undef(match) || is_undef(head_diam) || is_undef(screw_diam) || is_undef(head_heigth))
    {
        fail(type, " not found in collection of metrics: ", metrics);
    }

    // Union of head and screw body
    color("red")
    union()
    {
        translate([0, 0, length])
        // Head
        cylinder(d=head_diam+tolerance_diam, h = head_heigth+tolerance_length, $fn=fn_resolution);
        // Screw part
        cylinder(d=screw_diam+tolerance_diam, h = length-head_heigth+tolerance_length, $fn=fn_resolution);
    }
}

// Nice view of allen screw model to have in assembly
module allen_screw(type, length, tolerance = 0)
{  
    match = getIndex(type)[0];
    head_diam = match[1];
    screw_diam = match[2];
    head_heigth = match[3];
    hex_diam = match[4];

    // Lower chamfer
    color([58/255,59/255,60/255])
    union()
    {
        difference()
        {
            //Empty hex slot in head
            difference()
            {
                allen_screw_negative(type, length, tolerance);
                translate([0, 0, length+head_heigth/2])
                cylinder(d=hex_diam, h = head_heigth, $fn=6);
            }
            // Ensure complete cutting with an extra 0.1 mm and extended diameter
            translate([0, 0, -0.1])
            cylinder(h = chamfer_heigth+0.1, d = screw_diam*1.1, $fn=fn_resolution);
        }
        chamfer_heigth = screw_diam*0.1;
        cylinder(h = chamfer_heigth, r1 = (screw_diam-chamfer_heigth*2)/2, r2 = screw_diam/2, $fn=fn_resolution);
    }
    
}




allen_screw("M2", 10);
allen_screw_negative("M2", 10, 0.2, 0.2);