// Customizable bearing by enheragu
// Date: 10-12-2020

/* [Bearing Sizes] */
// External diameter (mm)
external_diameter=36;

// Internal diameter (mm)
internal_diameter=20;

// Ball diameter (mm)
ball_diameter=6;

// height (mm). Of course it should be more than ball_diameter + at least a couple of layers
height=9;

/* [Other characteristics] */

// Lid of the hole to introduce balls. If set to true the lid is left in place to be princed. Is a separate obj and should be easy to dissasemple once printed :)
get_ball_lid = false;

// Side from which balls are feeded into the bearing (either through inner or outer side)
input_hole="E"; //[I:Internal SIde,E:External Side]

/* [Multi dimensional bearing] */
// Number of ball rows included (max of two, need both sizes to feed balls)
ball_rows = 1; // [1,2]

// Number of columns
ball_columns = 1;

/* [Printer settings] */

// Printer tolerance (mm). Printers are not perfect, pieces need a bit of margin to fit.
tolerance=0.4;

// Printer layer height. Will checked to ensure a minimum eigth of the bearing.
layer_height = 0.20; // 0.01

// Printer wall thickness. Will be checked to ensure a minimum width (ext_diam - in_diam) of the bearing.
wall_thickness = 0.4;

/* [Other]  */

// Debug option. Rounds borders to save some material while doing som print-testing
round_borders = false;

// Depends on the height and how much you want to take out (is divided by 10 tu have more range)
round_factor = 1.20; // [1:0.1:10]
round_factor_apply = 1 + round_factor/10;
// $fn resolution
fn = 150;

top_margin = layer_height*4;
side_margin = wall_thickness*4;
// Check that dimensions are acceptable to render
height_incorrect = ((height) < ((ball_diameter+tolerance+top_margin)*(ball_columns) + top_margin)); // add at least top_margin between ball columns and between sides
diam_relation_incorrect = ((external_diameter-internal_diameter)/2 < ((ball_diameter+tolerance+side_margin)*(ball_rows) + side_margin)); // add at least side_margin between ball rows and between sides


module fail(fail_msg)
{
    assert(false, fail_msg);
    cube();
}
//
if(height_incorrect) fail(str("height (",height,") provided is not consistent with number of columns (",ball_columns,") and ball diameter sizes (",ball_diameter,"). height sholud be > ",((ball_diameter+top_margin)*(ball_columns) + top_margin)),". Check Printer settings in customization."); 
else if(diam_relation_incorrect) fail(str("Diameters (ext: ",external_diameter,", int: ",internal_diameter,") provided are not consistent with number of rows (",ball_rows,") and ball diameter sizes (",ball_diameter,"). Dif between diameters (ext-int) should be > ",((ball_diameter+side_margin)*(ball_rows) + side_margin)*2,". Check Printer settings in customization.")); 
    

module ring(ext_diam, in_diam, height)
{
    difference()
    {
        cylinder(d=ext_diam, h = height, center=true, $fn=150);
        cylinder(d=in_diam, h = height*1.1, center=true, $fn=fn); // multiply height to ensure complete cutting
    }
}

module toroid(diameter, section_diameter)
{
        rotate_extrude(convexity = 10, $fn = fn)
        translate([diameter/2, 0, 0])
        circle(d=section_diameter);
}

module ball_hole(ext_diam, in_diam, ball_diameter,input_hole)
{
    average_rad = (ext_diam + in_diam)/4;
    angle = (input_hole == "I")?90:-90;
    translate([0, average_rad, 0])
    rotate([angle,0,0])
    cylinder(d=ball_diameter+tolerance,h=(ext_diam-average_rad)*1.1, $fn=fn);
}

module ball_door(ext_diam, in_diam, ball_diameter,input_hole)
{
    average_rad = (ext_diam + in_diam)/4;
    angle = (input_hole == "I")?90:-90;
    intersection()
    {
        translate([0, average_rad, 0])
        rotate([angle,0,0])
        cylinder(d=ball_diameter-tolerance*2,h=(ext_diam-average_rad), $fn=fn);
        ring(ext_diam, in_diam, height);
    }
}

module solid_ring_with_hole(ext_diam, in_diam, height, ball_diameter,input_hole)
{
    union()
    {
        difference()
        {
            ring(ext_diam, in_diam, height);
            ball_hole(ext_diam,in_diam,ball_diameter,input_hole);
        }
        if(get_ball_lid) ball_door(ext_diam,in_diam,ball_diameter,input_hole);
    }
}

module simple_bearing(ext_diam, in_diam, height, ball_diameter,input_hole)
{
    // Make cut section to split into two
    diam_average = (ext_diam+in_diam)/2;
    division_width = ball_diameter*0.4;
    division_ext_diam = diam_average+division_width;
    division_in_diam = diam_average-division_width;
    
    difference()
    {
        difference()
        {
            solid_ring_with_hole(ext_diam, in_diam, height, ball_diameter,input_hole);
            ring(division_ext_diam, division_in_diam, height*1.1); // multiply height to ensure complete cutting
        }
        toroid(diam_average, ball_diameter+tolerance);
    }
}


module multy_row_bearing(n_rows, ext_diam, in_diam, height, ball_diameter,input_hole)
{
    
    if(n_rows == 1)
    {
        simple_bearing(ext_diam, in_diam, height, ball_diameter,input_hole);
    }
    else if (n_rows == 2)
    {
        average_diam = (ext_diam+in_diam)/2;
        union()
        {
            // External bearing
            simple_bearing(ext_diam, average_diam, height, ball_diameter,"E");
            // Internal bearing
            simple_bearing(average_diam, in_diam, height, ball_diameter,"I");
        }
    }
}
module multy_col_bearing(n_cols,n_rows, ext_diam, in_diam, height, ball_diameter,input_hole)
{
    column_height = height/n_cols;
    union() 
    {
        for (i = [0 : n_cols-1])
        {
            //color("grey", 0.5)
            translate([0, 0, column_height*i])
            multy_row_bearing(n_rows,ext_diam,in_diam,column_height,ball_diameter,input_hole);
        }
    }
}

intersection()
{   
    multy_col_bearing(ball_columns,ball_rows,external_diameter,internal_diameter,height,ball_diameter,input_hole);
    if (round_borders) toroid((external_diameter+internal_diameter)/2,height*round_factor_apply);
}
