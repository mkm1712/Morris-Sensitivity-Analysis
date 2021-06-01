This folder contains Matlab code for generation of parameter sample trajectories based on the concept of Sampling for Uniformity (SU) by Khare et al. () for the parameter screening method of Elementary Effects (Morris Method)






There are total 15 files (listed below):

(1)  SU_Sampling(NumFact, N, r, trunc) 
	- This is the main function which is to be called to generate trajectories, syntax: [Traj, D, time] = SU_Sampling(NumFact, N, r, trunc)
		
	- Inputs: NumFact-Number of parameters, N-Oversampling size (Q in manuscript), r-number of trajectories
, trunc (0 or 1) - if 0 then no truncation is done, if 1 then sample is generated from parameter space truncated at 0.125 and 0.875	
	- Outputs: Traj-set of parameter trajectories in trunccated unit hyperspace, D-Euclidean distance between trajectories and time-time in seconds required for sample generation

	- If the 'r' specified by the user is odd an error message 'Error: Number of Trajectoris (r) should be even' will be flashed on the screen and no trajectories will be generated
	
(2)  Sampling_Stat 
	- This function is called by SU_Sampling for N times. During each call it returns set of 'r' trajectories and corresponding Euclidean distance

(3)  Repeat Count
	- This function is called by SU_Sampling to check if any of the sample points of final trajectories is repeated. If any point is repeated a message 'Caution: One or more sample points are repeated' will is flashed

(4)  UNIQ_TRAJ_GEN_CHECK 
	- This function is called by Sampling_Stat. It generates the first and the last points of all trajectories (by calling other functions) and provides cehck for their uniqueness

(5)  UNI_DEL
	- This function is called by Sampling_Stat. It generates delta vector or pertubation vector which is used to generate intermediate points (2nd to k th) of all trajectories

(6)  TRAJ_GEN
	- This function is called by Sampling_Stat. It generates co-ordinates of (2nd to k th) points using first and last points and delta vector.

(7)  TRAJ_DIST
	- This function is called by Sampling_Stat. It calculates the Euclidean distance between trajectories.

(8)  SAMGEN1
	- This function is called by UNIQ_TRAJ_GEN_CHECK k times. During each call it returns first and last points of 'r' trajectories for one parameter.

(9)  UNI_TRAJ
	- This function is called by UNIQ_TRAJ_GEN_CHECK. It provides a check if the first and last points of 'r' trajectories are unique or not.

(10) FIRST_QT_GEN
	- This function is called by SAMGEN1. It selectes (randomly) trajectories for which 1st parameter level will appear as the first point.

(11) Count
	- This function is called by SAMGEN1. 

(12) UNICHECK
	- This function is called by FIRST_QT_GEN to provide a check for trajectory number uniquesness.

(13) DEL_CHECK
	- This function is called by UNI_DEL. It provides check for unqueness of del vector.

(14) DIST1
	- This function is called by TRAJ_DIST. It calculates geometric distance between any two trajectories.
(15) TRAJ_TRANS
	- This function is called by SU_Sampling. It converts samples points from truncated unit hyperspace to non-truncated unit hyperspace coordinates

NOTE:
Currently this code uses 4 parameter levels by default, which is not adjustable.
	
	
For clarification about this code please contact Y.P. Khare (khareyogesh1@gmail.com)


