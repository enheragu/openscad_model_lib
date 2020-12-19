// Metallic pin part by enheragu
// Date: 19-12-2020

/** Metallic pin with chanfer on one side, used as common part in the other modueles
 * height: pin height
 * pin_side: square side size
 * tolerance: extra side size to add some tolerance when used as negative
 */
module common_pin(height, in_pin_side, tolerance = 0)
{
    pin_side = in_pin_side+tolerance*2;
    pin_chanfer_size = pin_side/4;

    circunscript_diameter=sqrt(pow(pin_side,2)+pow(pin_side,2));
    union()
    {
        // pin
        translate([-pin_side/2,-pin_side/2, 0])
        cube([pin_side,pin_side,height-pin_chanfer_size]);

        // chanfer
        translate([0,0, height-pin_chanfer_size])
        rotate([0,0,45])
        cylinder(h=pin_chanfer_size, d1=circunscript_diameter, d2=circunscript_diameter-pin_chanfer_size*2, $fn=4);
    }
}

// common_pin(6,0.5);