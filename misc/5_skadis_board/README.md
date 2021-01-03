# Ikea Skadis board 3d print complements


- [Ikea Skadis board 3d print complements](#ikea-skadis-board-3d-print-complements)
  - [Models](#models)
    - [1. Board](#1-board)
      - [1.1 skadis_board.scad](#11-skadis_boardscad)
    - [2. Hook](#2-hook)
      - [2.1 File skadis_simple_hook.scad:](#21-file-skadis_simple_hookscad)
    - [3. Screen](#3-screen)
      - [3.1. File screen_stuff/screen_buttons.scad:](#31-file-screen_stuffscreen_buttonsscad)
      - [3.2. File screen_stuff/screen_speaker.scad:](#32-file-screen_stuffscreen_speakerscad)
      - [3.3. File screen_stuff/screen.scad:](#33-file-screen_stuffscreenscad)
    - [4. Assembly](#4-assembly)
      - [4.1. File assembly.scad:](#41-file-assemblyscad)


In this folder there are a set of objects I needed to attach to a Skadis board from IKEA. Each file has a set of modules to produce each of the objects.

## Models

### 1. Board

A model of the Skadis Board to make tests based on it.
#### 1.1 [skadis_board.scad](skadis_board.scad)

The board, with my specific size (note that there are different sizes available) and color looks like this:
| <img src="./media/skadis_board.PNG" alt="View openscad" width=200;/> |
|---|

### 2. Hook

To fix each of the pieces to the board theres a simple hook designed that has model for the single version or for an array of them. This piece is later integrated into the rest.
#### 2.1 [File skadis_simple_hook.scad:](skadis_simple_hook.scad)

| Simple Hook | Array of Hooks(2,2) |
|---|---|
| <img src="./media/skadis_hook.PNG" alt="View openscad" height=185;/> | <img src="./media/skadis_hook_array.PNG" alt="View openscad" height=185;/> |

### 3. Screen

This set of objects is made to fix an old-laptop-screen to the board.

#### 3.1. [File screen_stuff/screen_buttons.scad:](screen_stuff/screen_buttons.scad)

To control the screen there's a keypad that needs to be fixed. The clip looks like this:
| <img src="./media/screen_button_2.PNG" alt="View openscad" width=200;/> | <img src="./media/screen_button_2.PNG" alt="View openscad" width=200;/> |
|---|---|

#### 3.2. [File screen_stuff/screen_speaker.scad:](screen_stuff/screen_speaker.scad)

I have a pair of small speakers from another screen that need to be fixed close to the screen too. The clip for them looks like this:
| <img src="./media/screen_speaker_clip.PNG" alt="View openscad" width=200;/> |
|---|

#### 3.3. [File screen_stuff/screen.scad:](screen_stuff/screen.scad)

The actual screen with its clips to be attached to the board:
| <img src="./media/screen_2.PNG" alt="View openscad" width=200;/> | <img src="./media/screen_2.PNG" alt="View openscad" width=200;/> |
|---|---|


### 4. Assembly

#### 4.1. [File assembly.scad:](assembly.scad)
| <img src="./media/assembly_2.PNG" alt="View openscad" height=185;/> | <img src="./media/assembly_2.PNG" alt="View openscad" height=185;/> |
|---|---|