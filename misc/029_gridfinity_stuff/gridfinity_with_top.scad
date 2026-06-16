// This desing is based on this (https://makerworld.com/es/models/1355775-gridfinity-zip-ties-bin#profileId-1630698)


include <gridfinity_basic_cup.scad>


// Y dimension. grid units (multiples of 42mm) or mm.
depth = [3, 0]; //0.1
// X dimension. grid units (multiples of 42mm) or mm.
width = [2, 0]; //0.1
// Z dimension excluding. grid units (multiples of 7mm) or mm.
height = [5.2, 0]; //0.1

// Top cover. grid units in [depth, width]
top_overture_depth = 1; 
top_overture_width = width[0];

vertical_chambers = 3;
horizontal_chambers = 1;


/* [Finger Slide] */
// Include larger corner fillet
fingerslide = "rounded"; //[none, rounded, chamfered]
// Radius of the corner fillet, 0:none, >1: radius in mm, <0 dimention/abs(n) (i.e. -3 is 1/3 the width)
fingerslide_radius = 15;
// wall to enable on, front, back, left, right. 0: disabled; 1: enabled using radius; >1: override radius.
fingerslide_walls=[1,0,0,0];
//Align the fingerslide with the lip
fingerslide_lip_aligned=true;


/* [Tapered Corner] */
frontal_chamfer = true;
frontal_chamfer_side = 21;

// Adds extra space in the top for some text layers to be added (in mm) check your layer height and preferred text height to adjust
text_layers = 0.4;

add_label = false;
highlight_text_square = true;
// takes either one complete label or as much as vertical chambers :) (separated by ;)
label_text = "M-M;M-F;F-F";

module default_cup(width = width, depth = depth, clearance = clearance, vertical_chambers = vertical_chambers) {
    set_environment(
    width = width,
    depth = depth,
    height = height,
    height_includes_lip = height_includes_lip,
    lip_enabled = lip_style != "none",
    render_position = render_position,
    help = enable_help,
    pitch = pitch,
    clearance = clearance,
    cut = cut,
    setColour = set_colour,
    randomSeed = random_seed,
    force_render = force_render)
    gridfinity_cup(
    filled_in=filled_in,
    label_settings=LabelSettings(
        labelStyle=label_style, 
        labelPosition=label_position, 
        labelSize=label_size,
        labelRelief=label_relief,
        labelWalls=label_walls),
    finger_slide_settings = FingerSlideSettings(
        type = fingerslide,
        radius = fingerslide_radius,
        walls = fingerslide_walls,
        lip_aligned = fingerslide_lip_aligned),
    cupBase_settings = CupBaseSettings(
        magnetSize = enable_magnets?magnet_size:[0,0],
        magnetEasyRelease = magnet_easy_release, 
        magnetCaptiveHeight = magnet_captive_height,
        centerMagnetSize = center_magnet_size, 
        screwSize = enable_screws?screw_size:[0,0],
        holeOverhangRemedy = hole_overhang_remedy, 
        cornerAttachmentsOnly = box_corner_attachments_only,
        floorThickness = floor_thickness,
        cavityFloorRadius = cavity_floor_radius,
        efficientFloor=efficient_floor,
        halfPitch=half_pitch,
        flatBase=flat_base,
        spacer=spacer,
        minimumPrintablePadSize=minimum_printable_pad_size,
        flatBaseRoundedRadius = flat_base_rounded_radius,
        flatBaseRoundedEasyPrint = flat_base_rounded_easyPrint,
        alignGrid = [align_grid_x, align_grid_y]
        ),
    wall_thickness=wall_thickness,
    vertical_chambers = ChamberSettings(
        chambers_count = vertical_chambers,
        chamber_wall_thickness = chamber_wall_thickness,
        chamber_wall_headroom = chamber_wall_headroom,
        chamber_wall_top_radius = chamber_wall_top_radius,
        separator_bend_position = vertical_separator_bend_position,
        separator_bend_angle = vertical_separator_bend_angle,
        separator_bend_separation = vertical_separator_bend_separation,
        separator_cut_depth = vertical_separator_cut_depth,
        irregular_subdivisions = vertical_irregular_subdivisions,
        separator_config = vertical_separator_config),
    horizontal_chambers = ChamberSettings(
        chambers_count = horizontal_chambers,
        chamber_wall_thickness = chamber_wall_thickness,
        chamber_wall_headroom = chamber_wall_headroom,
        chamber_wall_top_radius = chamber_wall_top_radius,
        separator_bend_position = horizontal_separator_bend_position,
        separator_bend_angle = horizontal_separator_bend_angle,
        separator_bend_separation = horizontal_separator_bend_separation,
        separator_cut_depth = horizontal_separator_cut_depth,
        irregular_subdivisions = horizontal_irregular_subdivisions,
        separator_config = horizontal_separator_config),
    lip_settings = LipSettings(
        lipStyle=lip_style, 
        lipSideReliefTrigger=lip_side_relief_trigger, 
        lipTopReliefHeight=lip_top_relief_height, 
        lipTopReliefWidth=lip_top_relief_width, 
        lipNotch=lip_top_notches,
        lipClipPosition=lip_clip_position,
        lipNonBlocking=lip_non_blocking),
    headroom=headroom,
    tapered_corner=tapered_corner,
    tapered_corner_size = tapered_corner_size,
    tapered_setback = tapered_setback,
    wallpattern_walls=wallpattern_walls, 
    wallpattern_dividers_enabled=wallpattern_dividers_enabled,
    wall_pattern_settings = PatternSettings(
        patternEnabled = wallpattern_enabled, 
        patternStyle = wallpattern_style, 
        patternRotate = wallpattern_rotate_grid,
        patternFill = wallpattern_fill,
        patternBorder = wallpattern_border, 
        patternDepth = wallpattern_depth,
        patternCellSize = wallpattern_cell_size, 
        patternHoleSides = wallpattern_hole_sides,
        patternStrength = wallpattern_strength, 
        patternHoleRadius = wallpattern_hole_radius,
        patternGridChamfer = wallpattern_pattern_grid_chamfer,
        patternVoronoiNoise = wallpattern_pattern_voronoi_noise,
        patternBrickWeight = wallpattern_pattern_brick_weight,
        patternFs = wallpattern_pattern_quality,
        patternColored = wallpattern_colored), 
    floor_pattern_settings = PatternSettings(
        patternEnabled = floorpattern_enabled, 
        patternStyle = floorpattern_style, 
        patternRotate = floorpattern_rotate_grid,
        patternFill = floorpattern_fill,
        patternBorder = floorpattern_border, 
        patternDepth = floorpattern_depth,
        patternCellSize = floorpattern_cell_size, 
        patternHoleSides = floorpattern_hole_sides,
        patternStrength = floorpattern_strength, 
        patternHoleRadius = floorpattern_hole_radius,
        patternGridChamfer = floorpattern_pattern_grid_chamfer,
        patternVoronoiNoise = floorpattern_pattern_voronoi_noise,
        patternBrickWeight = floorpattern_pattern_brick_weight,
        patternFs = floorpattern_pattern_quality), 
    wallcutout_vertical_settings = WallCutoutSettings(
        type = wallcutout_vertical, 
        position = wallcutout_vertical_position, 
        width = wallcutout_vertical_width,
        angle = wallcutout_vertical_angle,
        height = wallcutout_vertical_height, 
        corner_radius = wallcutout_vertical_corner_radius),
    wallcutout_horizontal_settings = WallCutoutSettings(
        type = wallcutout_horizontal, 
        position = wallcutout_horizontal_position, 
        width = wallcutout_horizontal_width,
        angle = wallcutout_horizontal_angle,
        height = wallcutout_horizontal_height, 
        corner_radius = wallcutout_horizontal_corner_radius),
    extendable_Settings = ExtendableSettings(
        extendablexEnabled = extension_x_enabled, 
        extendablexPosition = extension_x_position, 
        extendableyEnabled = extension_y_enabled, 
        extendableyPosition = extension_y_position, 
        extendableTabsEnabled = extension_tabs_enabled, 
        extendableTabSize = extension_tab_size),
    sliding_lid_enabled = sliding_lid_enabled, 
    sliding_lid_thickness = sliding_lid_thickness, 
    sliding_min_wall_thickness = sliding_min_wallThickness, 
    sliding_min_support = sliding_min_support, 
    sliding_clearance = sliding_clearance,
    sliding_lid_lip_enabled=sliding_lid_lip_enabled,
    cupBaseTextSettings = CupBaseTextSettings(
        baseTextLine1Enabled = text_1,
        baseTextLine2Enabled = text_2,
        baseTextLine2Value = text_2_text,
        baseTextFontSize = text_size,
        baseTextFont = text_font,
        baseTextDepth = text_depth,
        baseTextOffset = text_offset));
}




module box_with_top(width = width, depth = depth, 
                    top_overture_depth = top_overture_depth, top_overture_width = top_overture_width,
                    vertical_chambers = vertical_chambers,
                    add_label = add_label, label_text = label_text)
{
    basic_top_side_width = width[0]*gf_pitch-clearance[0]*2;
    basic_top_side_depth = depth[0]*gf_pitch-clearance[1]*2;
    basic_top_z = default_floor_thickness*5+text_layers;
    num_z = is_undef(height) ? $num_z : calcDimensionHeight(height, true);
    wall_thickness = wallThickness(wall_thickness, num_z);

    label_size_width = add_label ? basic_top_side_width-wall_thickness : 0;
    label_size_depth = add_label ? gf_pitch/3 : 0;
    label_size_z = wall_thickness*3;
    difference()
    {
        union()
        {
            // Base cup!
            color("DarkGray")
            default_cup(width = width, depth = depth, vertical_chambers = vertical_chambers);
            
            difference()
            {
                color("green")
                difference()
                {
                    // Base of Lid (chamfered suports for overhang below :))
                    translate([-basic_top_side_width/2, 
                                -basic_top_side_depth/2, 
                                gf_zpitch*height[0] - default_floor_thickness*2
                    ])
                    chamfered_cube(
                        size = [basic_top_side_width, basic_top_side_depth, basic_top_z],
                        cornerRadius = gf_cup_corner_radius
                    );

                    // Cut the overture
                    // Needs a few for a complete cut, sorry :')
                    translate([-(width[0]*gf_pitch)/2, -(depth[0]*gf_pitch)/2,
                               text_layers/2 + gf_zpitch*height[0]])
                    hull()
                    {
                        translate([0,0,-default_floor_thickness*9])
                        frame_cavity(num_x=top_overture_width, num_y=top_overture_depth, 
                                    render_top = false,
                                    );
                        frame_cavity(num_x=top_overture_width, num_y=top_overture_depth, 
                                    render_top = false,
                                    );
                    }
                }

                // Cut spaces for box insert
                translate([-(width[0]*gf_pitch)/2,-(depth[0]*gf_pitch)/2,text_layers + gf_zpitch*height[0]])
                union()
                {
                    color("green")
                    frame_cavity(
                        num_x = width[0], 
                        num_y = depth[0], 
                        render_top = true,
                        render_bottom = false,
                        frameLipHeight = 4,
                        cornerRadius = env_corner_radius(),
                        reducedWallHeight = lip_top_relief_height,
                        reducedWallWidth = lip_top_relief_width,
                        reducedWallOuterEdgesOnly=true){
                            echo("donothign");
                            frame_connectors(
                            width = width[0], 
                            depth = depth[0],
                            connectorPosition = lip_clip_position,
                            connectorClipEnabled = false);
                        };
                    // cut some extra layers for text to fit :)
                    color("DarkGray")
                    translate([0,0,-text_layers])
                    frame_cavity(num_x=width[0], num_y=depth[0], 
                                render_top = false,
                                );
                }
            }

            // chamfers for support overhang
            extra_overhang = add_label ? 0 : wall_thickness*2.8;
            chamfer_top_side_width = abs(top_overture_width==width[0] ? basic_top_side_width : basic_top_side_width-top_overture_width*gf_pitch) + extra_overhang;
            chamfer_top_side_depth = abs(top_overture_depth==depth[0] ? basic_top_side_depth + label_size_depth : basic_top_side_depth-top_overture_depth*gf_pitch) + label_size_depth + extra_overhang;

            color("DarkGray")
            // Chamfer support for lid overhangs
            translate([-basic_top_side_width/2, 
                        -basic_top_side_depth/2, 
                        gf_zpitch*height[0] - default_floor_thickness*2
            ])
            union()
            {   
                echo("----- Chamfers: (chamfer_top_side_width: ", chamfer_top_side_width, ", chamfer_top_side_depth:", chamfer_top_side_depth, ")");
                
                echo("Back Chamfer - Width: ", basic_top_side_width, "; Depth: ", basic_top_side_depth, "; Height: ", basic_top_z);
                // Back, should be complete
                translate([basic_top_side_width,basic_top_side_depth,0])
                rotate([0,0,180])
                support_chamfer(basic_top_side_width, basic_top_side_depth, basic_top_z, one_side_round=false);
                
                for (i = [0 : vertical_chambers-1]) {
                    // Left side, per chamber
                    translate([(i+1)*basic_top_side_width/vertical_chambers,
                               basic_top_side_depth-chamfer_top_side_depth,
                               0])
                    rotate([0,0,90])
                    support_chamfer(chamfer_top_side_depth, basic_top_side_depth/vertical_chambers, basic_top_z);
                    
                    // Right side, per chamber
                    translate([basic_top_side_width - (i+1)*basic_top_side_width/vertical_chambers,
                               basic_top_side_depth,
                               0])
                    rotate([0,0,-90])
                    support_chamfer(chamfer_top_side_depth, basic_top_side_depth/vertical_chambers, basic_top_z, switch_side = true);
                }
            }
        }
        if (frontal_chamfer)
        {
            // Frontal chamfer
            color("DarkGray")
            translate([0, -depth[0]*gf_pitch/2 + headroom/2, gf_zpitch*height[0] + basic_top_z/2 + headroom*1.5])
            rotate([45,0,0])
            cube([width[0]*gf_pitch + headroom, frontal_chamfer_side, frontal_chamfer_side], center=true);
        }
    }

    if (add_label)
    {        
        // From gridfinity_basic_cup as such
        bevel1_top = 0.8;
        bevel2_bottom = 2.6;
        bevel2_top = 5; 
        bonus_ht = 0.2;
        insert_height = 1.9+bevel2_top-bevel2_bottom+bonus_ht+bevel1_top+text_layers+fudgeFactor;
        
        translate([-basic_top_side_width/2,
                   -basic_top_side_depth/2 + top_overture_depth*gf_pitch - label_size_depth, 
                    gf_zpitch*height[0] - insert_height + label_size_z
                  ])
        union()
        {
            highlight_z = label_size_z+text_layers*1;

            text_size = 6.5;
            color("DarkGray")
            cube([label_size_width, label_size_depth, label_size_z]);
            labels = split(label_text, ";");
            if (len(labels) > 0) 
            {
                for (i = [0 : len(labels)-1]) {
                    color("green")
                    translate([(width[0]*(gf_pitch+wall_thickness*2)/vertical_chambers)/2+label_size_width/3*i, 
                               label_size_depth/2-text_size/4,
                               highlight_z/2])
                    linear_extrude(height = highlight_z, center = true, convexity = 10)
                    text(labels[i], size = text_size, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
                    echo("--- Label '", labels[i], "' at index ", i);
                }
            }
            if (highlight_text_square)
            {
                highlight_width = label_size_width-wall_thickness*5;
                highlight_depth = label_size_depth-wall_thickness*5;
                highlight_thickness = wall_thickness*1.5;
                translate([label_size_width/2-highlight_width/2+clearance[0],
                        label_size_depth/2-text_size/6-highlight_depth/2-highlight_thickness/2,
                        0])
                color("green")
                difference()
                {
                    chamfered_cube(
                        size = [highlight_width, highlight_depth, highlight_z],
                        cornerRadius = env_corner_radius()
                    );
                    translate([highlight_thickness/2, highlight_thickness/2, fudgeFactor])
                    chamfered_cube(
                        size = [highlight_width-highlight_thickness, highlight_depth-highlight_thickness, highlight_z+fudgeFactor],
                        cornerRadius = env_corner_radius()
                    );
                }
            }
        }
    }
}


module support_chamfer(basic_top_side_width, basic_top_side_depth, basic_top_z, 
                       one_side_round = true, switch_side = false)
{
    chamfer_size = basic_top_z*1.5;
    intersection()
    {
        translate([0,0,-basic_top_z*1.5])
        union()
        {
            chamfered_cube( size = [basic_top_side_width, basic_top_side_depth, basic_top_z*3],
                            cornerRadius = gf_cup_corner_radius
                          );
            if (one_side_round) 
            {   
                if (switch_side)
                    translate([gf_cup_corner_radius,0,0])
                    cube([basic_top_side_width-gf_cup_corner_radius, basic_top_side_depth, basic_top_z*3]);
                else
                    cube([basic_top_side_width-gf_cup_corner_radius, basic_top_side_depth, basic_top_z*3]);
            }
        }
        translate([0,0,-basic_top_z*1.5])
        cube([basic_top_side_width, basic_top_side_depth, chamfer_size]);
        translate([0,-chamfer_size/1.5,0])
        rotate([45,0,0])
        translate([0,0,-chamfer_size])
        cube([basic_top_side_width, chamfer_size, chamfer_size]);
    }
}


// default to customize
box_with_top(width = width, depth = depth,
             top_overture_depth = top_overture_depth, top_overture_width = top_overture_width,
             vertical_chambers = vertical_chambers,
             add_label = add_label, label_text = label_text);


// box_with_top(width = [1,0], depth = [3,0],
//              top_overture_depth = 1, top_overture_width = 1,
//              vertical_chambers = 1,
//              add_label = false);


// translate([-150,0,0])
// box_with_top(width = [2,0], depth = [3,0],
//              top_overture_depth = 1, top_overture_width = 3,
//              vertical_chambers = 4,
//              add_label = false);

// translate([-300,0,0])
// box_with_top(width = [2,0], depth = [6,0],
//              top_overture_depth = 1.25, top_overture_width = 2,
//              vertical_chambers = 3,
//              add_label = true, label_text = "M-M;M-F;F-F");

// translate([-450,0,0])
// box_with_top(width = width, depth = depth,
//              top_overture_depth = top_overture_depth, top_overture_width = top_overture_width,
//              vertical_chambers = vertical_chambers,
//              add_label = add_label, label_text = label_text);


// default_cup(width = [2,0], depth = [1,0], vertical_chambers = 0);