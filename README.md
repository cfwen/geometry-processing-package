Geometry Processing Package
===========================

- algebra

 | Function | Description |
 | -------- | ----------- |
 | compute_adjacency_matrix.m | - compute adjacency matrix|
 | compute_bd.m               | - find boundary|
 | compute_connectivity.m     | - find connectivity information|
 | compute_dual_graph.m       | - compute dual graph of mesh|
 | compute_edge.m             | - find edges|
 | compute_face_ring.m        | - find face ring of all face|
 | compute_halfedge.m         | - find halfedges|
 | compute_vertex_face_ring.m | - find face ring of all vertex|
 | compute_vertex_ring.m      | - find vertex ring of all/any vertex|
 | face_area.m                | - compute all face area|
 | generalized_laplacian.m    | - discretize generalized laplace operator on mesh|
 | gradient.m                 | - discretize gradient operator on mesh|
 | laplace_beltrami.m         | - discretize Laplace Beltrami on mesh|
 | vertex_area.m              | - compute vertex area|
 
- graphics

 | Function | Description |
 | -------- | ----------- |
 | plot_mesh.m                | - plot mesh|
 | plot_path.m                | - plot path on mesh|
 
- io

 | Function | Description |
 | -------- | ----------- |
 | read_obj.m                 | - read mesh data from obj file|
 | read_off.m                 |  - read mesh data from off file|
 | read_ply.m                 |  - read mesh data from ply file|
 | write_obj.m                |  - write mesh data to obj file|
 | write_off.m                |  - write mesh data to off file|
 | write_ply.m                |  - write mesh data to ply file|
 
- misc

 | Function | Description |
 | -------- | ----------- |
 | sparse_to_csc.m            | - convert sparse matrix to csc format|
 | sparse_to_csr.m            | - convert sparse matrix to csr format|
 | csc_to_sparse.m            | - convert csc format to sparse matrix|
 | csr_to_sparse.m            | - convert csr format to sparse matrix|
 
- parameterization

 | Function | Description |
 | -------- | ----------- |
 | disk_harmonic_map.m        | - harmonic map from surface to unit disk|
 | rect_harmonic_map.m        | - harmonic map from surface to unit square|
 | spherical_conformal_map.m  | - spherical conformal map from genus zero surface to unit sphere|
 
- topology

 | Function | Description |
 | -------- | ----------- |
 | clean_mesh.m               | - clean mesh by removing unreferenced vertex|
 | compute_greedy_homotopy_basis.m | - compute a basis of homotopy group|
 | compute_homology_basis.m   | - compute a basis of homology group|
 | cut_graph.m                | - find a cut graph of mesh|
 | dijkstra.m                 | - dijkstra shortest path algorithm|
 | minimum_spanning_tree.m    | - Prim's minimum spanning tree algorithm|
 | slice_mesh.m               | - slice mesh open along a collection of edges|
 
- tutorial

 | Function | Description |
 | -------- | ----------- |
 | tutorial0                  | - a quick start tutorial|
 | tutorial1                  | - a tutorial brings you go through the package|
 | tutorial2                  | - a tutorial brings you go through the advanced functions of the package|
