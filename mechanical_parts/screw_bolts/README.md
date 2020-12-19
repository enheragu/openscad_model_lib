

- [1. Screw and bolt generator](#1-screw-and-bolt-generator)
  - [1.1. Available Modules](#11-available-modules)
    - [1.1.3. Available model and metris:](#113-available-model-and-metris)

# 1. Screw and bolt generator


## 1.1. Available Modules 

Each module probides functionality to generate both screw visual for assembly and swer negative, with a given tolerance, to be used with differences on other pieces.

See below list of available functions on each module along with metrics available.
All modules in `screw_nut` folder include a set of model generator to generate the different objects. All this function share a common naming and input parameters:

```OpenSCAD
<type_name>_screw(metric_tag, length);
<type_name>_screw_negative(metric_tag, length, diameter_tolerance, length_tolerance);

// Some excetion might change this, as with nuts that has no length param
```

> Note that `type_name` matches the file name without the numer.

See below examples of each of them:


 |File                             | Model                          | Negative                               |
 :--------------------------------:|:--------------------------------:|:------------------------------------:
[1_allen_screw.scad](1_allen_screw.scad) | Generated with `allen_screw("M2", 10);`<br/> <img src="media/1_allen_screw.PNG" height=200;/> | Generated with `allen_screw_negative("M2", 10, 0.2, 0.2);`<br/> <img src="media/1_allen_screw_negative.PNG" height=200;/>
[2_hexagon_nut.scad](2_hexagon_nut.scad) | Generated with `hexagon_nut("M5");`<br/> <img src="media/2_hexagon_nut.PNG" height=200;/> | Generated with `hexagon_nut_negative("M5",0.4,0.4);`<br/> <img src="media/2_hexagon_nut_negative.PNG" height=200;/>


### 1.1.3. Available model and metris:

- [1_allen_screw.scad](1_allen_screw.scad):
  
    ```OpenSCAD
        // allen_screw(metric_tag, length);
        // allen_screw_negative(metric_tag, length, diameter_tolerance, length_tolerance);
        metrics = ["M1.6", "M2", "M2.5", "M3", "M4", "M5", "M6", "M8", "M10", "M12"];
    ```

- [2_hexagon_nut.scad](2_hexagon_nut.scad):
  
    ```OpenSCAD
        // hexagon_nut(type);
        // hexagon_nut_negative(type, tolerance_diam = 0, tolerance_length = 0);
        metrics = ["M1.6", "M2", "M2.5", "M3", "M4", "M5", "M6", "M8", "M10", "M12"];
    ```