// Parameters (adjust as needed)
arm_width = 30;        // Width of the arms
short_length = 100;     // Length of the short arm
long_length = 100;     // Length of the long arm
height = 20;           // Thickness in Z
rounding_radius = 14;   // Radius for rounding the joint (inside and outside)

// 2D L-shaped profile
module l_profile() {
    union() {
        square([short_length, arm_width]);
        square([arm_width, long_length]);
    }
}

// Extrude the Minkowski sum of the profile and a circle for rounding
linear_extrude(height = height) {
    minkowski() {
        l_profile();
        circle(r = rounding_radius, $fn = 64);  // Higher $fn for smoother curves
    }
}