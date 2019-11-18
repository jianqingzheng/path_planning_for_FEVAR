   Copyright (c) 2019 Jian-Qing Zheng

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-------------------------------------------------------------------------------

Towards 3D Path planning from a single fluorosocopic image for robot assisted fenestrated endovascular aortic repair


Requirement:
	Version: Matlab R2016a to R2017a
	Platform: Windows, Linux


Script 'demo_2D3Dregist.m':
	This demostrates how to recover a 3D skeleton for the robotic path from a 2D intra-operative segmented aneurysm shape and a 3D pre-operative skeleton.It will import a 2D jpg image of pre-operative fluoroscopy, a 2D segmentation label, and a 3D skeleton. It will display the time cost for registration of 2D/3D skeletons, the intra-operative (ground truth) skeleton, pre-operative skeleton and our prediction, as well as the evaluated distance errors in 2D and 3D.


Folder 'function':
	It includes all the codes written for the deformable registration between 2D and 3D skeleton.
	
	* Please kindly read the license in each file.
	* For any academic publication using the codes in this folder, please kindly cite:
    		J. Q. Zheng, X. Y. Zhou, C. Riga and G. Z. Yang, "3D Path Planning from a Single 2D Fluoroscopic Image for Robot Assisted Fenestrated Endovascular Aortic Repair", IEEE International Conference on Robotics and Automation (ICRA), 2019.


Folder 'data':
	It includes the imported data used in demonstration.


Folder 'external':
	It includes redistributed codes used in the demonstration.
	* Please kindly read the license in each file.
