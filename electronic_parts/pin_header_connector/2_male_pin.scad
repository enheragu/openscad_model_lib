// Male pin by enheragu
// Date: 19-12-2020

include <0_common_pin.scad>;

// Extra marging added to perform cutting and ensure complete cut
margin = 0.1;
2margin = margin*2;

// Measures extracted from https://www.naylampmechatronics.com/accesorios-y-prototipado/555-header-40-pines-macho.html?search_query=pines+macho&results=199

plastic_square_side = 2.54;
//plastic_square_height = 1.5;
pin_side = 0.65;
pin_upper_height = 6;
pin_lower_height = 11.34-plastic_square_side-pin_upper_height;

/**
 * Generates single male pin
 */
module male_pin()
{
    plastic_chanfer_size = plastic_square_side/4;
    translate([plastic_square_side/2,plastic_square_side/2,0])
    union()
    {
        // Chanfer sides
        color([58/255,59/255,60/255])
        intersection()
        {
            cube(plastic_square_side, center = true);
            rotate([0,0,45])
            cube(plastic_square_side+plastic_chanfer_size, center = true);
        }

        // Uper pin end
        translate([0,0,plastic_square_side/2])
        common_pin(pin_upper_height, pin_side);
        
        // Lower pin end
        rotate([180,0,0])
        translate([0,0,plastic_square_side/2])
        common_pin(pin_lower_height, pin_side);
    }
}


/**
 * Generates an array of male pins
 * row: number of rows in generated array
 * column: number of columns in generated array
 */

module male_pin_array(row = 1, column = 1)
{
    union()
    {
        for(x = [0:row-1])
        {
            for (y = [0:column-1])
            {
                translate([x*plastic_square_side,y*plastic_square_side])
                male_pin();
            }
        }
    }
}

// male_pin();
// male_pin_array(5,1);