
// All units are in centimenters!

wood_width = 1.6;

// There are two_trolley_1 and one trolley_2 in the middle
margin = 0.5; // Margin for error and that stuff :)
trolley_1 = [102+margin,13.2+margin,79.7+margin*2]; // length, width, height
trolley_2 = [102+margin,18.2+margin,79.7+margin*2];
margin_between_trolleys = 0.5;

wheel_height = 2.8;

min_space_between_doors = 0.8; // 6 mm minimum between both sliding doors
min_space_between_door_frame = 0.45; // 4.5 mm between door and frame on each side

plug_side = 8.3;

// Slehf part widht
shelf_widht = 42;

// Width of the back support of the countertop
wood_width_support = 4.5;

fn = 80;

// If export is true it will print the pieces to be added to BOM
module basic_cube(size, wood_width, export = false, tag = "")
{
    board_1 = [size[1],size[2]-wood_width*2, wood_width];
    board_2 = [size[0],size[1], wood_width];

    // Right side
    color("blue")
    translate([size[0]-wood_width,0,wood_width])
    rotate([90,0,90])
    cube(board_1);

    // Left side
    color("blue")
    translate([0,0,wood_width])
    rotate([90,0,90])
    cube(board_1);

    // Base
    cube(board_2);

    // Upper
    translate(v = [0,0,size[2]-wood_width]) 
    cube(board_2);

    if (export) {
        echo(str("BOM_ITEM: ",tag,"\t\t[x2] ", board_1));
        echo(str("BOM_ITEM: ",tag,"\t\t[x2] ", board_2));
    }
}

module trolley(size, wood_width, wheel_height)
{
    translate(v = [0,0,wheel_height]) 
    basic_cube(size, wood_width);

    num_wheel = 3;
    for (index = [0 : num_wheel-1])
    {
        translate(v = [size[0]/(num_wheel*2)+size[0]/num_wheel*index,0,wheel_height/2]) 
        rotate([-90,0,0])
        cylinder(h = size[1], r = wheel_height/2, $fn = fn);
    }
}

module trolley_set(trolley_color = "white", alpha = 0.8)
{
    color(trolley_color, alpha)
    trolley(trolley_1, wood_width, wheel_height);
    color(trolley_color, alpha)
    translate([0, trolley_1[1]+margin_between_trolleys])
    trolley(trolley_2, wood_width, wheel_height);
    color(trolley_color, alpha)
    translate([0, trolley_1[1]+trolley_2[1]+margin_between_trolleys*2])
    trolley(trolley_1, wood_width, wheel_height);
}


module doors(frame_size, wood_width)
{
    // Frame
    translate(v = [0,-(frame_size[1]),0]) 
    union()
    {
        echo("Frame with doors:")
        basic_cube(size = frame_size, wood_width = wood_width, export = true, tag = "Door Frame");

        door_size = [frame_size[0]/2+1,
                    wood_width,
                    frame_size[2]-min_space_between_door_frame*2-wood_width*2];
        
        color([153/255,255/255,204/255])
        translate(v = [+wood_width+min_space_between_doors,+min_space_between_doors, wood_width+min_space_between_door_frame]) 
        cube(size = door_size);

        color([153/255,255/255,204/255])
        translate(v = [+frame_size[0]-wood_width-min_space_between_doors-door_size[0],
            +min_space_between_doors*2+wood_width,
            wood_width+min_space_between_door_frame]) 
        cube(size = door_size);

        echo(str("BOM_ITEM: Door\t\t[x2] ", door_size));
    }
    
}

// Plug board
module plugs_structure(plug_board_size, door_frame_size, trolley_depth, wood_width)
{
    base_plug_size = [plug_board_size[0],
                      wood_width+trolley_depth+door_frame_size[1],
                      wood_width];

    union()
    {
        // Front
        translate(v = [0,0,wood_width]) 
        cube(plug_board_size);

        // Back
        translate(v = [0,base_plug_size[1]-wood_width,
                    wood_width]) 
        cube(plug_board_size);

        // Base
        color("green")
        cube(base_plug_size);

        // Upper
        color("green")
        translate(v = [0,0,door_frame_size[2]-wood_width]) 
        cube(base_plug_size);
    }

    echo("Plugs structure");
    echo(str("BOM_ITEM: Plug board/back\t\t[x2] ", plug_board_size));
    echo(str("BOM_ITEM: Plug base/top\t\t[x2] ", base_plug_size));
}


module shelf_module(shelf_frame, door_frame_size, trolley_depth, wood_width)
{
    union()
    {
        echo("Shelf Frame:")
        basic_cube(size = shelf_frame, wood_width = wood_width, export=true, tag="shelf frame");

        echo("Shelfs:");
        shelf_size = [shelf_frame[0]-wood_width*2-margin/2-0.05,
                shelf_frame[1]-wood_width,
                wood_width];
        shelf_num = 2;
        translate(v = [0,wood_width,0]) 
        for (index = [0 : shelf_num-1])
        {
            translate(v = [wood_width+margin/4,0,
                           shelf_frame[2]/(shelf_num+1)+index*shelf_frame[2]/(shelf_num+1)]) 
            cube(shelf_size);
        }
        echo(str("BOM_ITEM: Shelf\t\t[x2] ", shelf_size));
    }
}





module countertop_back_support(door_frame_size, trolley_depth, wood_width)
{
    translate(v = [0,trolley_depth,0])
    union()
    {
        size = [door_frame_size[0],wood_width,door_frame_size[2]];
        basic_cube(size, wood_width = wood_width_support, export = true, tag = "back support");

        // board_1 = [wood_width,door_frame_size[2]-wood_width*2, wood_width];
        board_1 = [size[1],size[2]-wood_width_support*2, wood_width_support];
        // translate([size[0]-wood_width,0,wood_width])

        echo(str("BOM_ITEM: Countertop back support\t\t[x3] ", board_1));
        column_num = 2;
        color("red")
        translate([size[0]-wood_width_support,0,wood_width_support])
        for (index = [0 : column_num-1])
        {
            translate([-size[0]/(column_num+1)-size[0]*index/(column_num+1),0,0])
            rotate([90,0,90])
            cube(board_1);
        }
    }
}




module countertop(door_frame_size, plug_board_size, shelf_frame, wood_width)
{
    countertop_size = [door_frame_size[0]+plug_board_size[0]+shelf_frame[0],
                    shelf_frame[1],
                    wood_width];
                    color([102/255,204/255,0])
    cube(countertop_size);
    echo(str("BOM_ITEM: Countertop\t\t[x1] ", countertop_size));
}


///////////////////////////////
//        Desing part        //
///////////////////////////////

// Animation :)
$vpt = [35, 15, 35];
$vpr = [60, 0, 360 * $t];
$vpd = 480;

union()
{
    // Just for visualization   
    translate(v = [margin_between_trolleys,margin_between_trolleys,0]) 
    trolley_set();



    door_frame_size = [trolley_1[0]+margin_between_trolleys,
                    wood_width*2+min_space_between_doors*3,
                    trolley_1[2]+wheel_height];
    doors(door_frame_size, wood_width);



    trolley_depth = 2*trolley_1[1]+trolley_2[1]+margin_between_trolleys*4;
    plug_board_size = [plug_side+margin_between_trolleys*2,wood_width,door_frame_size[2]-wood_width*2];
    translate(v = [-plug_board_size[0],-door_frame_size[1],0]) 
    plugs_structure(plug_board_size = plug_board_size,
                    door_frame_size = door_frame_size, 
                    trolley_depth = trolley_depth,
                    wood_width = wood_width);



    shelf_frame = [shelf_widht,
                wood_width+trolley_depth+door_frame_size[1],
                door_frame_size[2]];
    translate(v = [-shelf_frame[0]-plug_board_size[0],-door_frame_size[1],0]) 
    shelf_module(shelf_frame = shelf_frame,
                door_frame_size = door_frame_size,
                trolley_depth = trolley_depth,
                wood_width = wood_width);

    countertop_back_support(door_frame_size = door_frame_size, 
                            trolley_depth = trolley_depth, 
                            wood_width = wood_width);


    // countertop
    translate(v = [-shelf_frame[0]-plug_board_size[0],-door_frame_size[1],door_frame_size[2]]) 
    countertop(door_frame_size = door_frame_size, 
                plug_board_size = plug_board_size, 
                shelf_frame = shelf_frame, 
                wood_width = wood_width);
}