# EWT Project Contest

This file is maintained by the contributing author to the EWT Project, in order to be eligible for the contest. For details of the contest, including dates, prizes and eligibility, see http://www.energywavetheory.com/project. For contest instructions for submitting entries, see https://energywavetheory.com/project/competition-instructions.

** *
### Contact Information
* Name: 
* Email: 
* Country: 
* Bank account: 


### Summary of Changes
Detail major changes included in the branch and how they correct or improve the simulator.
*


### Video (Recommended)
Contest participants are strongly recommended to do a brief (**5 minutes or less**) video that highlights the changes, which may be a public or private video on their platform of choice.
*


### PREVIOUS Entry Example. From Phase 1.

 My EWT simulation uses DirectX11 (so I updated the license to include DirectX MIT license). It uses optimized copute shaders for maximum performance.
  One needs Microsoft Visual Studio 2017 to compile the source code (Community Edition will do). Also you need DirectX installed (basically make sure you have latest video drivers).
  
  What is done so far:
  - the universe (ether) is built like a grid. You can actually choose the grid size: 8K, 16K, 32K, 64K. The default is 64K meaning 256 x 256 granules.
  - each granule "knows" its original position and will try to return to it (using an elastic force for that)
  - some external forces are applied to all granules from outside to the center of the grid (these forces are applied only if the granules positions meet some ctiteria, in order to avoid applying these external forces each and every frame)
  - if the granules "collide" with each other they will transfer their momentum to that other granule (ellastic collisions, conservation of momentum and energy is applied)
  
  In order to start the simulation one must start \EWT_Simulator\EWT_Simulator.exe (at this moment the executable cannot be in root directory, I'll investigate that).
  Also please note that the application tends to loose focus after running, so please re-focus it.
  
  * Video URL: https://drive.google.com/file/d/1OstgwoC2ImFr23vyiAMXnI3orzkWgmkg/view?usp=sharing
