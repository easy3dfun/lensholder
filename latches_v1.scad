$fa = 1;   // minimum angle per fragment
$fs = 0.1;   // minimum size of fragment

// Parameters
latch_length = 10;
latch_thickness = 1;
latch_radius = 1; // Corner radius

// Create the basic "L" shape
module l_shape() {
        union() {
            square([latch_thickness, latch_length]);
            square([latch_length, latch_thickness]);
        }
}

// Apply rounding to both inside and outside
offset(r=latch_radius)
        l_shape();