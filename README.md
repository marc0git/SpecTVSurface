# SpecTVSurface
### Nonlinear Spectral Geometry Processing via the TV Transform

![alt text](https://github.com/marc0git/SpecTVSurface/blob/master/teasertv.png)

This repository contains the MATLAB implementation of:
M.Fumero, M.Moeller, E.Rodolà, *Nonlinear Spectral Geometry Processing via the TV Transform.*
ACM Trans. Graph.39, 6, Article 199, presented at SIGGRAPH 2020.  
https://dl.acm.org/doi/abs/10.1145/3414685.3417849

<p align="center">

![gif link](https://media.giphy.com/media/wKb9gZ5zrdFeYItdUB/giphy.gif)

The repository contains two minimal example of spectral deompositions


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
example.m
scalar_example.m

```t
The scripts ' example.m ' and 'scalar_example.m' contains minimal implementations of the computation of TV spectral demposition on a scalar function and on a normal vector field signal, respectively.
The latter contains embeds also an interactive GUI that you can play with to apply filter in the TV spectral domain.
