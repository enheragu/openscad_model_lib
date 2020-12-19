- [1. Pin header Connectors](#1-pin-header-connectors)
  - [1.1. Available Modules](#11-available-modules)
    - [1.1.3. Available model:](#113-available-model)

# 1. Pin header Connectors

## 1.1. Available Modules 

Each module probides functionality to generate pin header connecotrs (standard breadboard compatible).

See below list of available functions on each module.

 |File                             | Single                          | Array                               |
 :--------------------------------:|:--------------------------------:|:------------------------------------:
[0_common_pin.scad](0_common_pin.scad) | Generated with `common_pin(6,0.5);`<br/> <img src="media/0_common_pin.PNG" height=200;/> |
[1_female_pin.scad](1_female_pin.scad) | Generated with `female_pin();`<br/> <img src="media/1_female_pin.PNG" height=200;/> | Generated with `female_pin_array(5,1);`<br/> <img src="media/1_female_pin_array.PNG" height=200;/>
[2_male_pin.scad](2_male_pin.scad) | Generated with `male_pin();`<br/> <img src="media/2_male_pin.PNG" height=200;/> | Generated with `male_pin_array(5,1);`<br/> <img src="media/2_male_pin_array.PNG" height=200;/>
 
 

### 1.1.3. Available model:
- [0_common_pin.scad](0_common_pin.scad)
  
    ```OpenSCAD
        // common_pin(height, in_pin_side, tolerance = 0)
    ```

- [1_female_pin.scad](1_female_pin.scad)
  
    ```OpenSCAD
        // female_pin(pin_entrance_tolerance = 0.4)
        // female_pin(row = 1, column = 1, pin_entrance_tolerance = 0.4)
    ```
- [2_male_pin.scad](2_male_pin.scad)
  
    ```OpenSCAD
        // male_pin()
        // male_pin_array(row = 1, column = 1)
    ```