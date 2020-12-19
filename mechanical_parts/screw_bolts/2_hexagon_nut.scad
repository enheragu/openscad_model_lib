// Customizable hexagon nuts by enheragu
// Date: 19-12-2020

// metric tag name, head_diameter, nut height, hole_diameter
metrics = [
    ["M1.6", 3.41, 1.30, 1.60],
    ["M2", 4.32, 1.60, 2.00],
    ["M2.5", 5.45, 2.00, 2.50],
    ["M3", 6.01, 2.40, 3.00],
    ["M4", 7.66, 3.20, 4.00],
    ["M5", 8.79, 4.70, 5.00],
    ["M6", 11.05, 5.20, 6.00],
    ["M8", 14.38, 6.80, 8.00],
    ["M10", 17.77, 8.40, 10.00],
    ["M12", 20.03, 10.80, 12.00]
];

// These metric data has been extracted from https://www.fasteners.eu/standards/DIN/934/

// Default resolution for shapes
fn_resolution = 150;
// Extra marging added to perform cutting and ensure complete cut
margin = 0.1;
2margin = margin*2;


function getIndex(type) = ([for(metric = metrics) if(metric[0] == type) metric]);
function is_undef (a) = (undef == a);

/** Negative to make allen screw holes in other models
 * metric_tag: string with metric tag, see metrics dict for the available ones
 * tolerance_diam: tolerance for the diameter measures (note that is applied once, if you want a radious tolerance multiply by 2)
 * tolerance_length: tolerance for the lenght
 */
module hexagon_nut_negative(type, tolerance_diam = 0, tolerance_length = 0)
{
    match = getIndex(type)[0];
    hex_diam = match[1];
    height = match[2];
    hole_diam = match[3];

    echo("type: ", type);
    echo("match: ", match);
    echo("hex_diam: ", hex_diam);
    echo("height: ", height);
    echo("hole_diam: ", hole_diam);

    color("red")
    cylinder(d=hex_diam+tolerance_diam, h = height+tolerance_length, $fn=6);
}


module hexagon_nut(type, tolerance = 0)
{
    match = getIndex(type)[0];
    hex_diam = match[1];
    height = match[2];
    hole_diam = match[3];

    color([58/255,59/255,60/255])
    intersection()
    {
        difference()
        {
            hexagon_nut_negative(type);
            translate([0,0,-margin])
            // Add extra height to ensure complete cutting
            cylinder(d=hole_diam, h = height+2margin, $fn=fn_resolution);
        }
        // Cilinder with chamfer to intersect with nut
        union()
        {
            chamfer_height = hex_diam*0.1;
            cylinder(h = chamfer_height, r1 = (hex_diam-chamfer_height*2)/2, r2 = hex_diam/2+margin, $fn=fn_resolution);

            translate([0,0,height])
            rotate([180,0,0])
            cylinder(h = chamfer_height, r1 = (hex_diam-chamfer_height*2)/2, r2 = hex_diam/2+margin, $fn=fn_resolution);
            translate([0,0,chamfer_height-margin])
            cylinder(h = height-chamfer_height*2+2margin, d = hex_diam+margin, $fn=fn_resolution);
        }
    }
}

// hexagon_nut("M5");
// hexagon_nut_negative("M5",0.4,0.4);