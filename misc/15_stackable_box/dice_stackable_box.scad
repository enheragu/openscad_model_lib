

include <./stackable_box.scad>

/* [Printer settings] */

// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.8;


/* [Box Info] */

// Dice side in mm
dice_side = 8.7;

// how many dices are to be stored
dice_matrix = [3,2];

// Width of printed wall. Take into account that in the insertion this will be half of the value inserted (mm)
wall_width = 3.6; // 0.1

// Insertion length (mm). Insertion between both parts
insertion = 3;


/* [Other] */

export = "DN"; //[DL:Lid, DI:Intermediate box, DB:Base, AS:Assembly, DN:None]
// $fn resolution
fn = 150;




module filling(box_length, box_width, box_height, wall_width, tolerance)
{
    color("red")
    translate(v = [wall_width+tolerance,wall_width+tolerance,wall_width]) 
    cube([box_length+tolerance,box_width+tolerance,box_height]);
}

module cubes(box_length, box_width, box_height, wall_width, tolerance)
{
    translate(v = [wall_width+tolerance*2,wall_width+tolerance*2]) 
    union()
    {   
        for (x = [0:dice_matrix.x-1])
        {
            for (y = [0:dice_matrix.y-1])
            {
                side = dice_side + tolerance*2;
                translate(v = [x*(side+wall_width), y*(side+wall_width), -tolerance]) 
                cube(size = [side, side, dice_side*2]);
            }

        }
    }
}



filling_length = dice_side*dice_matrix.x + tolerance*dice_matrix.x*2 + wall_width*(dice_matrix.x-1);
filling_width = dice_side*dice_matrix.y + tolerance*dice_matrix.y*2  + wall_width*(dice_matrix.y-1);
filling_height = dice_side+tolerance;
 
module dice_box_lid(box_external_length,box_external_width,box_external_height)
{
    box_lid(box_external_length, box_external_width, box_external_height, wall_width, tolerance);
}

module dice_box_intermediate(box_external_length,box_external_width,box_external_height)
{   
    difference() 
    {
        union() 
        {
            
            // color("green")
            box_intermediate(box_external_length, box_external_width, box_external_height, wall_width, tolerance);
            translate(v = [0,0,insertion+tolerance]) 
            filling(filling_length, filling_width, filling_height, wall_width, tolerance);
        }   
        translate(v = [0,0,insertion+wall_width+tolerance])
        cubes(filling_length, filling_width, filling_height, wall_width, tolerance);
    }    
}

module dice_box_base(box_external_length,box_external_width,box_external_height)
{
    difference() 
    {
        union() 
        {
            box_base(box_external_length, box_external_width, box_external_height, wall_width, tolerance);
            translate(v = [0,0,tolerance]) 
            filling(filling_length, filling_width, filling_height, wall_width, tolerance);
        } 
        translate(v = [0,0,wall_width+tolerance])
        cubes(filling_length, filling_width, filling_height, wall_width, tolerance);
    }
}
if (1)
{
    // filling_ vars are undefined if these are placed in general scope...dont know why
    box_external_length = filling_length + wall_width*2 + tolerance*4; //needs tolerance for insertion and for inner part
    box_external_width = filling_width + wall_width*2 + tolerance*4; //needs tolerance for insertion and for inner part
    box_external_height = filling_height + wall_width + tolerance;

    if (export == "DL")
    {
        dice_box_lid();
    }
    else if (export == "DI")
    {
        dice_box_intermediate();  
    }
    else if (export == "DB")
    {
        dice_box_base();
    }
    else if (export == "AS")
    {    
        // Display assembly
        color("CadetBlue", 1)
        // translate([box_external_wdith+wall_width*2+tolerance*2,0,box_external_height*2+wall_width+insertion*2])
        // rotate([180,0,180])
        dice_box_lid(box_external_length,box_external_width,box_external_height);

        // translate([0,0,box_external_height])
        color("SteelBlue", 1) 
        translate([0,box_external_length+10,0])
        dice_box_intermediate(box_external_length,box_external_width,box_external_height);
        color("PowderBlue", 1) 
        translate([0,box_external_length*2+20,0])
        dice_box_base(box_external_length,box_external_width,box_external_height);
    }
    else
    {

    }
}