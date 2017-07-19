# person_localization
This code takes the output of head detector in the form of mat file and returns the x,y coordinates of heads in the image. Following is the brief description of the functions called by the *runme.m* script.

**get_candidate_locs.m** computes the candidate head locations using some heuristics. This step is optional, but in my experience rejecting all but good candidate locations at this point in code reduces the overall computation time. This code uses two simple heuristics; 
* First it rejects the pixel locations that have the probabilty of head lower than a threshold.
* Next it fits a 3d parabolid on the remaining pixel locations and rejects all pixels which do not fit a maxima.
Resulting pixel locations are treated as candidate locations for the next step.

**get_counts.m** takes the candidate locations as input and returns the actual locations of human heads and their count. Localization task is accomplished in following steps.
* *get_gaussians.m* fits a prespective aware head template at each candidate location.
* *get_costs.m* scores all templates locally and stores them in order of increasing cost of fit.
* *get_cost_surface.m* starts from an empty array, of size same as that of head probability map, and iteratively adds sorted prespective aware head templates to it. After each addition *global* cost of fit is computed and nearby locations that are geometrically implausible are suppressed. These steps are repeated until the cost keeps decreasing. Eventually the cost starts to rise and the loop is terminated at that point.

Resulting pixel locations are final head positions. 
