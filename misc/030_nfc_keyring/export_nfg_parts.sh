#!/bin/bash
# Script para exportar variantes de box_with_top en gridfinity_with_top.scad
OPENSCAD=~/Escritorio/AppImages/OpenSCAD-2026.01.15-x86_64.AppImage

$OPENSCAD -o stl/nfc_keyring_base_lower.stl -D 'export="BL";' nfc_keyring.scad
$OPENSCAD -o stl/nfc_keyring_base_upper.stl -D 'export="BT";' nfc_keyring.scad
$OPENSCAD -o stl/nfc_keyring_molino_kwon_logo.stl -D 'export="LT";' nfc_keyring.scad
$OPENSCAD -o stl/nfc_keyring_nfc_logo.stl -D 'export="LNFC";' nfc_keyring.scad
$OPENSCAD -o stl/no_nfc_keyring_base_solid.stl -D 'export="S";' nfc_keyring.scad