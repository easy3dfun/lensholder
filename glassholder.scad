/*
    A box to hold a raw lens.
    The lens can be pressed into it and then is held
    down by the little spheres.
*/

include <symmetrical_press_fit_box>

/* Quality */
$fa = 3;   // minimum angle per fragment
$fs = 0.5;   // minimum size of fragment

test_print = false;    // Set to true to only create a fraction of the object

/* Parameters in mm */
lens_diameter    = 60;
tolerance        = 0.5;   // Gap on each side so the lens easily fits
wall_thickness   = 1;     // Walls of the box
bottom_thickness = 1;     // Bottom of the box
box_height       = 7;
sphere_diameter  = 1;   // Size of the spheres
sphere_pos_z     = 4;     // Vertical position of the spheres
corner_radius    = 8;     // Radius for the rounded corners of the square box

/* Calculations */
diameter_with_tolerance = lens_diameter + 2*tolerance;
outer_side = diameter_with_tolerance + 2*wall_thickness;
inner_side = diameter_with_tolerance;
inner_corner_radius = corner_radius - wall_thickness;

lens_box();

// --------------------------------------------------
// Modules
// --------------------------------------------------

module lens_box() {
    the_box();
    color([0.3,0.9,0.3]) the_spheres();
}

module the_box() {
    symmetrical_press_fit_box(
        /* Parameters in mm */
        content_diameter = 60,
        tolerance        = 0.5,   // Gap on each side so the lens easily fits
        wall_thickness   = 1,     // Walls of the box
        bottom_thickness = 1,     // Bottom of the box
        box_height       = 7,
        corner_radius    = 8,     // Radius for the rounded corners of the square box
    );
}

module the_spheres() {
    for (i = [0:3]) {
        angle = i*90;
        x = (diameter_with_tolerance/2) * cos(angle);
        y = (diameter_with_tolerance/2) * sin(angle);
        translate([x, y, sphere_pos_z])
                sphere(r=sphere_diameter);
    }
}

