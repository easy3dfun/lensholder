/*
    Two of these objects make a closable box.
*/

//> include_bottom corner_arc.scad

module symmetrical_press_fit_box(
  /* Parameters in mm */
  content_diameter = 60,
  tolerance        = 0.5,   // Gap on each side so the content easily fits
  wall_thickness   = 1,     // Walls of the box
  bottom_thickness = 1,     // Bottom of the box
  box_height       = 7,
  corner_radius    = 8,     // Radius for the rounded corners of the square box
  show_copy        = false, // Shows a rotated copy of the box so one can see how two of these play together
) {

if(show_copy)
  translate([0, 0, box_height*2+0.01])
    rotate([180,0,0])
      symmetrical_press_fit_box();

  /* Calculations */
  diameter_with_tolerance = content_diameter + 2*tolerance;
  outer_side = diameter_with_tolerance + 2*wall_thickness;
  inner_side = diameter_with_tolerance;
  inner_corner_radius = corner_radius - wall_thickness;

  color([0.6,0.6,0.6]) the_box();
  color([0.8,0.2,0.2]) corner_points();
  color([0.2,0.4,0.9]) difference() {
    the_corners();
    translate([0, 0, box_height*2])
      rotate([180, 0, 0])
        corner_points(2);
  };

  // --------------------------------------------------
  // Modules
  // --------------------------------------------------

  module corner_points(w=1, h=1, d=1) {
      point_radius = 1.5;
      w = w * point_radius;
      h = h * point_radius;
      d = d * point_radius;
      point_height = 8; // How high up the sphere is from the bottom
      corner_dist = 10;
      z_pos = bottom_thickness + point_height / 2;
      // The following offset is putting about 1mm of the sphere into the box
      offset_from_center = inner_side / 2 + 1;
      
      intersection() {
          outer_box(outer_side-0.01);  // Clip inside the wall of the box
          union() {
              translate([offset_from_center - corner_dist, offset_from_center, z_pos]) {
                  corner_point(w, h, d);
              }

              translate([offset_from_center, offset_from_center-corner_dist, z_pos]) {
                  corner_point(h, w, d);
              }

              translate([-offset_from_center + corner_dist, -offset_from_center, z_pos]) {
                  corner_point(w, h, d);
              }

            translate([-offset_from_center, -offset_from_center + corner_dist, z_pos]) {
                  corner_point(h, w, d);
              }

          }
      }
  }

  module corner_point(w, h, d) {
    scale([w, h, d]) sphere(r=1);
  }

  module the_box() {
      difference() {
          outer_box();
          storage_space();
      }
  }

 module the_corners() {
    corner_length = 30;
    x_offset = inner_corner_radius * (1 - PI/4);
    for(i=[0:1]) {
      rotate([0, 0, i*180])
      translate([inner_side/2-corner_length/2-x_offset, -inner_side/2, 0])
      corner_arc(
        length       = corner_length,
        height       = 11,
        thickness    = 1,
        rad          = corner_radius - wall_thickness,
        shape_factor = 0,
        arc_width    = 10,
      );
    }
  }
  
  module outer_box(size=outer_side) {
          // Outer box (square with rounded corners)
          linear_extrude(height=box_height) {
              minkowski() {
                  square(size - 2*corner_radius, center=true);
                  circle(r=corner_radius);
              }
          }
  }

  module storage_space() {
          // Inner cavity for the content
          translate([0,0,bottom_thickness])
          linear_extrude(height=box_height) {
              minkowski() {
                  square(inner_side - 2*inner_corner_radius, center=true);
                  circle(r=inner_corner_radius);
              }
          }
  }

}
