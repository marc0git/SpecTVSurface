# SpecTVSurface
### Nonlinear Spectral Geometry Processing via the TV Transform
[![Generic badge](https://img.shields.io/badge/MATLAB-R2020a-orange.svg)](https://www.mathworks.com)


![alt text](https://github.com/marc0git/SpecTVSurface/blob/master/teasertv.png)

This repository contains the MATLAB implementation of:
M.Fumero, M.Moeller, E.Rodolà, *Nonlinear Spectral Geometry Processing via the TV Transform.*
ACM Trans. Graph.39, 6, Article 199, presented at SIGGRAPH 2020.  
https://dl.acm.org/doi/abs/10.1145/3414685.3417849



![gif link](https://media.giphy.com/media/wKb9gZ5zrdFeYItdUB/giphy.gif)


# Structure

```bash
.
├── DATA               # Directory containing input meshes
│   ├── bob.off
│   ├── garg.off
└── gui
    ├── startgui.m    
└── meshIO
    ├── loadoff.m
└── meshUtilities
    ├── adjacency_mat.m
    ├── calc_LB_FEM.m        
    ├── calc_tri_areas.m
    ├── compute_normals.m     
    ├── div.m   
    ├── edges.m     
    ├── edges_legths.m         
    ├── gaussian.m  
    ├── gaussian_indicator.m
    ├── grad.m 
    ├── gradient_edge.m
    ├── icosphere.m
    ├── lumpedAreas.m  
    ├── total_variation.m
    ├── vertex2triang.m
    └── vertex_from_normals.m
└── plotUtilities    
    ├── add_lights.m       
    ├── add_shadow.m
    ├── draw_shape.m
    ├── inset.m  
    ├── plot_mesh.m
    └── render_options.m 
└── specTV   
    ├── L2squaredProx.m     
    ├── L2squaredProxMasked.m
    ├── PDHG_ACC.m
    ├── PDHG_ACC_n.m
    ├── decomposeNormals.m
    └── decomposeScalar.m
└── utils 
    ├── Pfilter.m   
    ├── axisangle2matrix.m
    ├── findpeaks.m
    ├── normalizerow.m
    ├── normv.m
    ├── pickregion.m
    ├── repdiag.m
    ├── spdiag.m
    └── timescale_iss.m
└── example.m
└── scalar_example.m

```
## Usage
The scripts `example.m` and `scalar_example.m` contain minimal implementations of the computation of TV spectral dempositions for a scalar function and dor a normal vector field signal defined on surfaces, respectively.
The latter also embeds an interactive GUI that you can play with to apply filters in the TV spectral domain.


## GUI usage
Below you can find an example of computing a localized low pass filter on the wing of the gargoyle model, using the GUI


https://user-images.githubusercontent.com/32999329/110501601-a26a8000-80fa-11eb-8779-d5acab546438.mp4



## Cite
If you make use of this code in your own work, please cite our paper:
```
@article{10.1145/3414685.3417849,
author = {Fumero, Marco and M\"{o}ller, Michael and Rodol\`{a}, Emanuele},
title = {Nonlinear Spectral Geometry Processing via the TV Transform},
year = {2020},
issue_date = {December 2020},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
volume = {39},
number = {6},
issn = {0730-0301},
url = {https://doi.org/10.1145/3414685.3417849},
doi = {10.1145/3414685.3417849},
journal = {ACM Trans. Graph.},
month = nov,
articleno = {199},
numpages = {16},
keywords = {spectral geometry, total variation}
}
```

