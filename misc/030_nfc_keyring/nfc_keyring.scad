


/** [Keyring Info] **/
keyring_outer_diameter = 37; // in mm
keyring_thickness = 3; // in mm
keyring_hole_diameter = 2; // in mm

svg_path = "./svg/molino_kwon_o.svg";
nfc_svg_path = "./svg/nfc_logo.svg";

/** [NFC Tag dimensions] **/
nfc_diameter = 25; // in mm
nfc_thickness = 0.8; // in mm

/** [Stamp Info] **/
stamp_width = 0.8; // in mm (take into account layer height, at least three layers for a nice color)
nfc_stamp_width = 0.4; // in mm (take into account layer height, at least three layers for a nice color)

/** [Other] **/
wall_width = 2;
tolerance = 0.4;
fn = 150;

export = "A"; //[BL:Base lower part, BT:Base top part, S: Base solid (No NFC), LT:Top logo, LNFC:NFC logo, AT:Assembly top part, AL: Assembly lower part, AS: Assembly solid, A: Assembly]

// Small cuantity to ensure cutting though
epsilon = 0.1;


sphere_r = keyring_hole_diameter + wall_width;


module nfc_tag(tolerance_in = 0)
{
    cylinder(h = nfc_thickness + tolerance_in, d = nfc_diameter + tolerance_in*2, $fn = fn);
}

module nfc_logo()
{
    nfc_logo_dimension = keyring_outer_diameter/2 - wall_width*2;
    color("white")
    translate(v = [-nfc_logo_dimension*0.79, -nfc_logo_dimension*0.69, -(keyring_thickness/2 + epsilon/60 - nfc_stamp_width/2)]) 
    linear_extrude(height=nfc_stamp_width, center=true)
    resize([nfc_logo_dimension, nfc_logo_dimension])
        import(nfc_svg_path);
}

module front_logo()
{
    color("red")
    difference() 
    {
        logo_dimension = keyring_outer_diameter - wall_width*2;
        translate(v = [-logo_dimension/2, -logo_dimension/2, keyring_thickness/2 + epsilon/60 - stamp_width/2]) 
        linear_extrude(height=stamp_width, center=true)
        resize([logo_dimension, logo_dimension])
            import(svg_path);

        logo_keyring_hole_diameter = keyring_hole_diameter + wall_width/3;
        translate([keyring_outer_diameter/2-wall_width*1.1, 0, 0]) cylinder(h = keyring_thickness*2, d = logo_keyring_hole_diameter, $fn = fn, center = true);

        // translate([keyring_outer_diameter/2-wall_width/3, 0, (keyring_thickness/2+wall_width) + epsilon/10])
        // sphere(r=sphere_r, $fn = fn);
    }
}
module nfc_keyring_base()
{
    difference() 
    {
        cylinder(h = keyring_thickness, d = keyring_outer_diameter, $fn = fn, center = true);
        translate([keyring_outer_diameter/2-wall_width*1.1, 0, 0]) cylinder(h = keyring_thickness*2, d = keyring_hole_diameter, $fn = fn, center = true);

        // translate([keyring_outer_diameter/2-wall_width/3, 0, (keyring_thickness/2+wall_width)])
        // sphere(r=sphere_r, $fn = fn);
        
        // translate([keyring_outer_diameter/2-wall_width/3, 0, -(keyring_thickness/2+wall_width)])
        // sphere(r=sphere_r, $fn = fn);
        
        if (export != "S")
        {
            translate([0,0, keyring_thickness/2-wall_width*1.25+epsilon])
            nfc_tag(tolerance);
        }
    }
}


module nfc_keyring_base_upper()
{
    color("yellow")
    difference() 
    {
        nfc_keyring_base();
        translate([0,0, -keyring_thickness*0.4])
        cylinder(h = keyring_thickness+epsilon, d = keyring_outer_diameter-wall_width-epsilon, $fn = fn, center = true);
        
        translate([0,0, -keyring_thickness*0.75])
        cylinder(h = keyring_thickness, d = keyring_outer_diameter+epsilon*2, $fn = fn, center = true);
    }        

}

module nfc_keyring_base_base()
{
    color("orange")
    intersection() 
    {
        nfc_keyring_base();
        union()
        {
            translate([0,0, -keyring_thickness*0.4])
            cylinder(h = keyring_thickness-epsilon, d = keyring_outer_diameter-wall_width-epsilon, $fn = fn, center = true); 

            translate([0,0, -keyring_thickness*0.75])
            cylinder(h = keyring_thickness, d = keyring_outer_diameter+epsilon*2, $fn = fn, center = true);
        }
    }
}

if (export == "BL") {
    nfc_keyring_base_base();
} else if (export == "BT") {
    nfc_keyring_base_upper();
} else if (export == "S") {
    nfc_keyring_base();
} else if (export == "LNFC") {
    nfc_logo();
} else if (export == "LT") {
    front_logo();
} else if (export == "AT") {
    nfc_keyring_base_upper();
    front_logo();
} else if (export == "AL") {
    nfc_keyring_base_base();
    nfc_logo();
} else if (export == "AS") {
    nfc_keyring_base();
    front_logo();
} else if (export == "A") {
    nfc_keyring_base_upper();
    front_logo();
    nfc_keyring_base_base();
    nfc_logo();
}