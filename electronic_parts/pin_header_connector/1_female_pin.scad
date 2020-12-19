// Female pin by enheragu
// Date: 19-12-2020

include <0_common_pin.scad>;

// Extra marging added to perform cutting and ensure complete cut
margin = 0.1;
2margin = margin*2;

// Meaures extracted from https://www.naylampmechatronics.com/accesorios-y-prototipado/554-header-40-pines-hembra.html

plastic_square_side = 2.54;
plastic_square_height = 8.5;
//plastic_square_height = 1.5;
pin_side = 0.65;
pin_lower_height = 3.15;

/**
 * Generates single female pin
 */
module female_pin(pin_entrance_tolerance = 0.4)
{
    plastic_chanfer_size = plastic_square_side/4;

    difference()
    {
        union()
        {
            // Chanfer sides
            color([58/255,59/255,60/255])
            intersection()
            {
                cube([plastic_square_side,plastic_square_side,plastic_square_height], center = true);
            }
            
            // Pin lower end
            rotate([180,0,0])
            translate([0,0,plastic_square_height/2])
            pin(pin_lower_height, pin_side);

        }

        // Pin upper entrance
        translate([0,0,plastic_square_height/2+margin])
        rotate([180,0,0])
        common_pin(pin_lower_height*1.5, pin_side, pin_entrance_tolerance);

        // Pin upper entrance with chanfer
        translate([0,0,plastic_square_height+margin])
        rotate([180,0,0])
        common_pin(pin_lower_height*1.5, pin_side+pin_side/2, pin_entrance_tolerance);

    }
}


/**
 * Generates an array of female pins
 * row: number of rows in generated array
 * column: number of columns in generated array
 */

module female_pin_array(row = 1, column = 1, pin_entrance_tolerance = 0.4)
{
    union()
    {
        for(x = [0:row-1])
        {
            for (y = [0:column-1])
            {
                translate([x*plastic_square_side,y*plastic_square_side])
                female_pin(pin_entrance_tolerance);
            }
        }
    }
}

// female_pin();
// female_pin_array(5,1);