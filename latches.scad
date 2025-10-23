// Wall parameters
wall_length = 100;
wall_height = 20;
wall_thickness = 2;
steps_x = 40;
steps_y = 3;

// Calculate total number of points
nr_points = steps_x * steps_y * 2; // front and back faces

// Helper function to generate a single point
function generate_point(i) =
    (i < steps_x * steps_y) ?
        // Front face point
        [
            (i % steps_x) * wall_length / (steps_x - 1),
            0,
            floor(i / steps_x) * wall_height / (steps_y - 1)
        ]
    :
        // Back face point
        [
            ((i - steps_x * steps_y) % steps_x) * wall_length / (steps_x - 1),
            wall_thickness,
            floor((i - steps_x * steps_y) / steps_x) * wall_height / (steps_y - 1)
        ];

function transform_point(p) =
    let(
        L = wall_length,
        t = wall_thickness,
        s = p.x,
        o = p.y,
        r = min(3 * t, (2 * L) / 3.141592653589793), // corner radius
        arc = 1.5707963267948966 * r,                 // (pi/2)*r
        pre = (L - arc) / 2                           // straight length before/after arc
    )
    s < pre
    ? [ s, o, p.z ]  // first straight segment (along +X)
    : s < (pre + arc)
    ? let(
        s2 = s - pre,
        a = 90 * (s2 / arc) // degrees
      )
      [ pre + (r - o) * sin(a), r - (r - o) * cos(a), p.z ] // rounded 90° corner
    : let(
        s3 = s - (pre + arc)
      )
      [ pre + r - o, r + s3, p.z ]; // second straight segment (along +Y)

// Generate points using helper and transform functions
function generate_points() = [for (i = [0 : nr_points - 1]) transform_point(generate_point(i))];


// Generate faces (unchanged)
function generate_faces() = [
    // Front face triangles
    for (i = [0 : steps_y - 2])
        for (j = [0 : steps_x - 2])
            each [
                [
                    i * steps_x + j,
                    i * steps_x + j + 1,
                    (i + 1) * steps_x + j
                ],
                [
                    i * steps_x + j + 1,
                    (i + 1) * steps_x + j + 1,
                    (i + 1) * steps_x + j
                ]
            ],

    // Back face triangles (reversed winding)
    for (i = [0 : steps_y - 2])
        for (j = [0 : steps_x - 2])
            each [
                [
                    steps_x * steps_y + i * steps_x + j,
                    steps_x * steps_y + (i + 1) * steps_x + j,
                    steps_x * steps_y + i * steps_x + j + 1
                ],
                [
                    steps_x * steps_y + i * steps_x + j + 1,
                    steps_x * steps_y + (i + 1) * steps_x + j,
                    steps_x * steps_y + (i + 1) * steps_x + j + 1
                ]
            ],

    // Side faces - left edge
    for (i = [0 : steps_y - 2])
        each [
            [
                i * steps_x,
                steps_x * steps_y + i * steps_x,
                (i + 1) * steps_x
            ],
            [
                steps_x * steps_y + i * steps_x,
                steps_x * steps_y + (i + 1) * steps_x,
                (i + 1) * steps_x
            ]
        ],

    // Side faces - right edge
    for (i = [0 : steps_y - 2])
        each [
            [
                i * steps_x + steps_x - 1,
                (i + 1) * steps_x + steps_x - 1,
                steps_x * steps_y + i * steps_x + steps_x - 1
            ],
            [
                steps_x * steps_y + i * steps_x + steps_x - 1,
                (i + 1) * steps_x + steps_x - 1,
                steps_x * steps_y + (i + 1) * steps_x + steps_x - 1
            ]
        ],

    // Top edge
    for (j = [0 : steps_x - 2])
        each [
            [
                (steps_y - 1) * steps_x + j,
                (steps_y - 1) * steps_x + j + 1,
                steps_x * steps_y + (steps_y - 1) * steps_x + j
            ],
            [
                steps_x * steps_y + (steps_y - 1) * steps_x + j,
                (steps_y - 1) * steps_x + j + 1,
                steps_x * steps_y + (steps_y - 1) * steps_x + j + 1
            ]
        ],

    // Bottom edge
    for (j = [0 : steps_x - 2])
        each [
            [
                j,
                steps_x * steps_y + j,
                j + 1
            ],
            [
                j + 1,
                steps_x * steps_y + j,
                steps_x * steps_y + j + 1
            ]
        ]
];

// Create the wall
polyhedron(
    points = generate_points(),
    faces = generate_faces()
);
