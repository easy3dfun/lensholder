module lensholder_clamps_spheres() {
    for (i = [0:3]) {
        angle = i*90;
        x = (diameter_with_tolerance/2) * cos(angle);
        y = (diameter_with_tolerance/2) * sin(angle);
        translate([x, y, sphere_pos_z])
                sphere(r=sphere_diameter);
    }
}