
// Height of the coockie cutter
height = 10;

// Minimum wall width of th emodel
wall_width = 1.6;

// Width of the hotend of the rxtruder
extruder_width = 0.4;

// Path of the SVG file to load
svg_path = "./svg/molino_kwon_o.svg";

stamp_diameter = 59;
stamp_height = 4;

handle_diameter = 16.66;
handle_height = 16;

coockie_cutter_height = 20;
coockie_cutter_diam = 60;

epsilon = 0.01;

tolerance = 0.3;

export = "A"; //[S:Stamp, H:Stamp Handle, C:Coockie cutter, A:Assembly]

fn = 180;

module stamp()
{
    union() 
    {
        difference()
        {
            cylinder(h = stamp_height, d = stamp_diameter, center = true, $fn = fn);
            translate([-stamp_diameter/2+wall_width/2, -stamp_diameter/2+wall_width/2, stamp_height/4+epsilon])
            linear_extrude(height=stamp_height/2, center=true)
            resize([stamp_diameter-wall_width, stamp_diameter-wall_width])
                import(svg_path);

            translate(v = [0,0,-stamp_height/2]) 
            difference() 
            {
                cylinder(h = wall_width, d = handle_diameter+tolerance, center = true, $fn = fn);
                translate(v = [0,0,-epsilon]) 
                cylinder(h = wall_width+epsilon*3, d = handle_diameter-wall_width*2-tolerance, center = true, $fn = fn);
            }
        }

        difference()
        {
            cylinder(h = stamp_height, d = stamp_diameter, center = true, $fn = fn);
            translate(v = [0,0,-epsilon]) 
            cylinder(h = stamp_height+epsilon*3, d = stamp_diameter - wall_width*2, center = true, $fn = fn);
        }
    }
}

module handle()
{
    difference()
    {
        cylinder(h = handle_height, d = handle_diameter, center = true, $fn = fn);
        translate(v = [0,0,handle_height/2-epsilon])
        cylinder(h = wall_width, d = handle_diameter - wall_width*2 + tolerance, center = true, $fn = fn);
    }
}

module coockie_cutter()
{
    difference()
    {
        union()
        {
            cylinder(h = coockie_cutter_height/2, d1 = coockie_cutter_diam + wall_width*2, d2 = coockie_cutter_diam + extruder_width, center = true, $fn = fn);
            translate(v = [0,0,-coockie_cutter_height/2])
            cylinder(h = coockie_cutter_height/2, d = coockie_cutter_diam + wall_width*2, center = true, $fn = fn);
            translate(v = [0,0,-coockie_cutter_height/2-coockie_cutter_height/4])
            cylinder(h = wall_width*1.5, d = coockie_cutter_diam + wall_width*6, center = true, $fn = fn);
        }
        translate(v = [0,0,-coockie_cutter_height/2])
        cylinder(h = coockie_cutter_height*3, d = coockie_cutter_diam, center = true, $fn = fn);
    }
}



if (export == "S")
{
    stamp();
}
else if (export == "H")
{
    handle();
}
else if (export == "C")
{
    coockie_cutter();
}
else if (export == "A")
{   
    stamp()
    coockie_cutter();
}