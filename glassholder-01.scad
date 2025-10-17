/*
    A box to hold a raw lens.
    The lens can be pressed into it and then is held
    down by the little spheres.
*/

/* Quality */
$fa = 3;   // minimum angle per fragment
$fs = 0.5;   // minimum size of fragment

test_print = false;    // Set to true to only create a fraction of the object

/* Parameters in mm */
lens_diameter    = 60;
tolerance        = 0.5;   // Gap on each side so the lens easily fits
wall_thickness   = 1;     // Walls of the box
bottom_thickness = 1;     // Bottom of the box
box_height       = 5;
sphere_diameter  = 1;   // Size of the spheres
sphere_pos_z     = 4;     // Vertical position of the spheres
corner_radius    = 8;     // Radius for the rounded corners of the square box

/* Calculations */

diameter_with_tolerance = lens_diameter + 2*tolerance;
outer_side = diameter_with_tolerance + 2*wall_thickness;
inner_side = diameter_with_tolerance;
inner_corner_radius = corner_radius - wall_thickness;

if (test_print)
    intersection() {
        lens_box();
        cube([lens_diameter+10,10,15],center=true);
    }
else
    lens_box();

// --------------------------------------------------
// Modules
// --------------------------------------------------

module lens_box() {
    the_box();
    the_spheres();
    the_latches();
}

module the_box() {
    difference() {
        outer_box();
        storage_space();
    }
}

module the_latches() {
    difference() {
        inlay_walls();
        rotate(45) cube([90,60,20], center=true);
    }
}

module inlay_walls() {
    translate([0,0,0])
        scale([0.965, 0.965, 1.5])
            extra_walls();
}

module extra_walls() {
    difference() {
        outer_box();
        translate([0,0,-4]) scale([1,1,3]) storage_space();
    }
}

module outer_box() {
        // Outer box (square with rounded corners)
        linear_extrude(height=box_height) {
            minkowski() {
                square(outer_side - 2*corner_radius, center=true);
                circle(r=corner_radius);
            }
        }
}

module storage_space() {
        // Inner cavity for the lens
        translate([0,0,bottom_thickness])
        linear_extrude(height=box_height) {
            minkowski() {
                square(inner_side - 2*inner_corner_radius, center=true);
                circle(r=inner_corner_radius);
            }
        }
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