# Shape-feature-of-infrared-image
graduation project
=
shape_feature is the main function which includes the following two parts:
1. Shape feature. 
_
   ## (1) Image preprocessing, which contains contrast enhancement, image sharpening. 
   ## (2) Harris and FAST algorithm to detect feature points. 
   ## (3) Use ORB method to transfer the featrue points into binary string.
   ## (4) Use hamming distance to match the feature points.
2. Contour feature. Use shape context method.
_
   ## (1) Use Jitendra's sampling to sample the contour.
   ## (2) Contour feature extraction.
   ## (3) Similarity measurement.
   ## (4) Use KM algorithm and Hungarian algorithm to match the contour points;
