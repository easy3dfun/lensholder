module lensholder_clamps_spheres() {
    for (i = [0:3]) {
        angle = i*90;
        x = (diameter_with_tolerance/2) * cos(angle);
        y = (diameter_with_tolerance/2) * sin(angle);
        translate([x, y, sphere_pos_z])
                sphere(r=sphere_diameter);
    }
}

module lensholder_clamps_tori() {
  torus_thickness = 0.33;
  torus_radius = 0.75;
  for (i = [0:36]) {
    angle = i*10;
      x = (diameter_with_tolerance/2+0.2) * cos(angle);
      y = (diameter_with_tolerance/2+0.2) * sin(angle);
      translate([x, y, sphere_pos_z])
        rotate([90,0,i*10])
          rotate_extrude(convexity = 10)
            translate([torus_radius, 0, 0])
              circle(r = torus_thickness);
  }
}