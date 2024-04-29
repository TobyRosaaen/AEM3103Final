# AEM3103Final
  # Paper Airplane Numerical Study
  Final Project: AEM 3103 Spring 2024

  - By: Toby Rosaaen, Owen Carlson, Charlie Tripp

  ## Summary of Findings

  | Parameter | Minimum | Nominal | Maximum | 
  |-----------------------------------------|
  | Velocity  |  2 m/s  | 3.55 m/s | 7.5 m/s |
  
  


  Using the function EqMotion we analyzed the flight of an paper airplane while varying mutiple flight parameters
  In the first figure the velocity and flight path angle are varied while eveything else is held constant.
  In the second figure the velcoty and flight path angle values are randomized while everything is held constant,
  this was done 100 times and the outputs were fitted polynomially. The polynomial fit is the neon green line. 

  # Code Listing
  <p> EqMotion - Summarizes equations of motion into a vector <br> FinalFunc - Calculates and displays all relavent information </p>

  # Figures

  ## Fig. 1: Single Parameter Variation
![HeightVsRange](https://github.com/TobyRosaaen/AEM3103Final/assets/167818556/5acdf430-79f4-4e8d-a9ce-b437a52a7778)

The top graph shows the height vs range of the paper plane at a lower, nominal, and higher velocity while keeping the flight path angle constant. The bottom graph shows the height vs range of the paper plane at a lower, nominal, and higher flight path angle while keeping the velocity constant.

  ## Fig. 2: Monte Carlo Simulation
![RandomParameters](https://github.com/TobyRosaaen/AEM3103Final/assets/167818556/6b73c09a-5194-4510-bb78-2744c3bcc5af)


 This figure shows 100 different trials of the paper airplane, where each trial is a randomly picked flight path angle or velocity within their range of values. The neon green line is polynomial fit

 ## Fig. 3: Time Derivatives
![Derivatives](https://github.com/TobyRosaaen/AEM3103Final/assets/167818556/343ecd16-4b2e-47ef-a5d3-414ee8e85757)

The top graph shows the time rate of change of the height. The bottom graph shows the time rate of change of the range. Both of these graphs are their respective velocities over time.

  ## Graphical Animation
![animate](https://github.com/TobyRosaaen/AEM3103Final/assets/167818556/dd8962b6-fc71-41e0-ad64-b5d9783edcfb)
