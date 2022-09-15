## MTT-System-GNN-Tracker

## Project Description
This project presents implementation of a multiple object tracking system. We implemented Global Nearest Neighbour Tracker in conjuction with EKF to track constant velocity targets. We formulate multiple hypotheses using k-best algorithm for 2D assignment of measurement-to-tracks. The probability of target existence is used to confirm/delete and maintain tracks in the track management system. 

The tracker estimates the state vector and state vector covariance matrix for each track. Each detection is assigned to at most one track. If the detection cannot be assigned to any track, the tracker initializes a new track after a set threshold.

Any new track starts in a tentative state. If enough detections are assigned to a tentative track, its status changes to confirmed. If the detection already has a known classification (the ObjectClassID field of the returned track is nonzero), that track is confirmed immediately. When a track is confirmed, the tracker considers the track to represent a physical object. If detections are not assigned to the track within a specifiable number of updates, the track is deleted.


## Demonstration

<p align="center">
  <img src="/media/tracker.gif" />
</p>



## Platform
* MATLAB

## Implementation
 
Navigate to the ```MTT-System-GNN-Tracker``` folder

Open ```main.m``` file and ```RUN``` it in MATLAB workspace.
