#!/bin/bash
# Script para exportar variantes de box_with_top en gridfinity_with_top.scad
OPENSCAD=~/Escritorio/AppImages/OpenSCAD-2026.01.15-x86_64.AppImage

$OPENSCAD -o ~/Escritorio/gridfinity_with_top_1-3_simple.stl \
    -D 'width=[1,0];depth=[3,0];top_overture_depth=1;vertical_chambers=1;' \
    gridfinity_with_top.scad

$OPENSCAD -o ~/Escritorio/gridfinity_with_top_1-5_simple.stl \
    -D 'width=[1,0];depth=[5,0];top_overture_depth=1;vertical_chambers=1;' \
  gridfinity_with_top.scad

$OPENSCAD -o ~/Escritorio/gridfinity_with_top_3-5_4chambers.stl \
    -D 'width=[3,0];depth=[5,0];top_overture_depth=1;vertical_chambers=4;' \
    gridfinity_with_top.scad

$OPENSCAD -o ~/Escritorio/gridfinity_with_top_2-6_text_MM-MF-FF.stl \
    -D 'width=[2,0];depth=[6,0];top_overture_depth=1.25;vertical_chambers=3;add_label=true;label_text="M-M;M-F;F-F";' \
    gridfinity_with_top.scad

$OPENSCAD -o ~/Escritorio/gridfinity_with_top_2-4_text_MM-MF-FF.stl \
    -D 'width=[2,0];depth=[4,0];top_overture_depth=1.25;vertical_chambers=3;add_label=true;label_text="M-M;M-F;F-F";' \
    gridfinity_with_top.scad