
// Height of the coockie cutter
height = 10;

// Minimum wall width of th emodel
wall_width = 1.2;

// Width of the hotend of the rxtruder
extruder_width = 0.4;

// Path of the SVG file to load
svg_path = "svg/rompecabezas.svg";


// Taken from https://3dprinting.stackexchange.com/questions/15130/openscad-linear-extrude-from-multiple-path-svg-import
module buildPyramidalExtrude(height, maxOffset, minOffset, nSlices = 10)
{
    heightIncrement = height/nSlices;
    offsetIncrement = (maxOffset-minOffset)/(nSlices-1);
    for(i=[1:nSlices])
        linear_extrude(height=i*heightIncrement)
              offset(r = maxOffset-(i)*offsetIncrement)
                children();
}

module coockieCutter(height, wall_width, extruder_width = 0.4)
union() {
    translate(v = [0,0,height-wall_width*2]) 
    buildPyramidalExtrude(wall_width*2,wall_width/2, extruder_width/2)
        children();
    linear_extrude(height = height-wall_width*2) {
        offset(delta = wall_width/2)
            children();
    }
    linear_extrude(height = wall_width) {
        offset(delta = wall_width*2) // delta is on each side, its already doubling the input
            children();
    }
}


coockieCutter(height, wall_width, extruder_width)
    import(file = svg_path, center = true);