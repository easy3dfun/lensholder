    long_length = 60;
    short_length = 40;
    thickness = 5;
    corner_radius = 5;
    
    // Helper module to create rounded corner points
    function arc_points(center, radius, start_angle, end_angle, steps=10) = 
        [for(i=[0:steps]) 
            center + radius * [cos(start_angle + i*(end_angle-start_angle)/steps),
                              sin(start_angle + i*(end_angle-start_angle)/steps)]
        ];
    
    // Define corner positions and create the rounded polygon
    points = concat(
        [[corner_radius, 0]],
        [[long_length - corner_radius, 0]],
        arc_points([long_length - corner_radius, corner_radius], corner_radius, -90, 0),
        [[long_length, thickness]],
        [[thickness + corner_radius, thickness]],
        arc_points([thickness + corner_radius, thickness + corner_radius], corner_radius, -90, -180),
        [[thickness, short_length - corner_radius]],
        arc_points([corner_radius, short_length - corner_radius], corner_radius, 90, 180),
        [[0, corner_radius]],
        arc_points([corner_radius, corner_radius], corner_radius, 180, 270)
    );
    
    polygon(points);