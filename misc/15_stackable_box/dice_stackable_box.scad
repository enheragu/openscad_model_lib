

include <./stackable_box.scad>

/* [Printer settings] */

// Printer tolerance. Printers are not perfect, pieces need a bit of margin to fit. (mm)
tolerance = 0.4;


/* [Box Info] */

// Dice side in mm
dice_side = 8;

// how many dices are to be stored
dice_matrix = [3,2];

// Width of printed wall. Take into account that in the insertion this will be half of the value inserted (mm)
wall_width = 2.4; // 0.1

// Insertion length (mm). Insertion between both parts
insertion = 1;


/* [Other] */

export = "DN"; //[DL:Lid, DI:Intermediate box, DB:Base, DN:None]
// $fn resolution
fn = 150;




module filling(box_length, box_width, box_height, wall_width, tolerance)
{
    difference()
    {
        translate(v = [wall_width/2,wall_width/2,wall_width+tolerance]) 
        filleted_rectangle(size_x = box_length+wall_width, size_y = box_width+wall_width, size_z = box_height, round_rad = box_width/10);

        translate(v = [wall_width-tolerance,wall_width-tolerance,wall_width]) 
        union()
        {   
            for (x = [0:dice_matrix.x-1])
            {
                for (y = [0:dice_matrix.y-1])
                {
                    translate(v = [x*(dice_side+wall_width)-tolerance, y*(dice_side+wall_width)-tolerance, -tolerance]) 
                    cube(size = [dice_side + tolerance*2, dice_side + tolerance*2, dice_side*2]);
                }

            }
        }
    }
}

if (export == "DL")
{
    // translate([box_width,0,box_height])
    // rotate([180,0,180])
    box_length = dice_side*dice_matrix.x + tolerance*dice_matrix.x*2 + wall_width*(dice_matrix.x-2);
    box_width = dice_side*dice_matrix.y + tolerance*dice_matrix.y*2  + wall_width*(dice_matrix.y-2);
    box_height = dice_side+tolerance;
    box_lid(box_length, box_width, box_height, wall_width, tolerance);
}
else if (export == "DI")
{
    union() 
    {
        box_length = dice_side*dice_matrix.x + tolerance*dice_matrix.x*2 + wall_width*(dice_matrix.x-2);
        box_width = dice_side*dice_matrix.y + tolerance*dice_matrix.y*2  + wall_width*(dice_matrix.y-2);
        box_height = dice_side+tolerance;
        box_intermediate(box_length, box_width, box_height, wall_width, tolerance);
        filling(box_length, box_width, box_height, wall_width, tolerance);
    }      
}
else if (export == "DB")
{
    union() 
    {
        box_length = dice_side*dice_matrix.x + tolerance*dice_matrix.x*2 + wall_width*(dice_matrix.x-2);
        box_width = dice_side*dice_matrix.y + tolerance*dice_matrix.y*2  + wall_width*(dice_matrix.y-2);
        box_height = dice_side+tolerance;
        box_base(box_length, box_width, box_height, wall_width, tolerance);
        filling(box_length, box_width, box_height, wall_width, tolerance);
    }
}
else
{

}