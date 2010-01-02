// makehuman_facegroup_documentation.pov
// -------------------------------------

// This scene file is used to generate the facegroup documentation for MakeHuman.
// This can be found online as part of the full API documentation in the Developers
// Guide at http://makehuman.wiki.sourceforge.net/DG_API.
// 
// This scene file uses the include file generated from the MakeHuman 
// application using the POV-Ray export functionality. The model exported from
// MakeHuman should be in the default pose. This figure is centred at the origin 
// with the top of the head at 7.4 units high (y) and the bottoms of the feet at 
// -7.4*y. The model is facing out along the positive z-axis with arms outstretched.
//
// The code here may serve as a sort of advanced set of examples for those using  
// the files exported from MakeHuman and could be of value to those seeking to 
// add props or those wishing to render sub-components of the humanoid model.
//
// This file is licensed under the terms of the CC-LGPL. 
// This license permits you to use, modify and redistribute the content.
// 
// Render times vary for the different images, but most render in just a few seconds.
// 


// Typical command-line settings:  +kfi300 +kff320 +fJ +ofacegroup_ 
// 
// This file contains a series of separate sets of images, controlled using the 
// 'Image_Number' variable. This scene file is designed to use the POV-Ray animation
// command-line settings to generate sets of images at a time. For example, the 
// images showing the face groups used to construct the left hand, can be generated 
// using command-line options +kfi300 +kff320. POV-Ray generates 21 separate images
// for each of these frames, numbering them 300 to 320.
//  
// The following image numbers are used:
//
//   Image_Number = 1 Just draws whichever group you set it up to render. 
//   Image_Number = 2 No Image. This just writes a file listing the group names
//                    for whichever group you set it up to list. 
//   Image_Number = 3 shows the face groups indicating joint positions. 
//   Image_Number = 5 shows the upper teeth face group with the names for each tooth. 
//   Image_Number = 6 shows the lower teeth face group with the names for each tooth. 
//
//   Image_Number = 100 to 179 for the head.         Min Resolution: 640x480, AA 0.3 
//   Image_Number = 190 to 192 for the neck.         Min Resolution: 640x480, AA 0.3
//   Image_Number = 200 to 220 for the left foot.    Min Resolution: 640x480, AA 0.3 
//   Image_Number = 221 to 241 for the right foot.   Min Resolution: 640x480, AA 0.3 
//   Image_Number = 280 to 285 for the left leg.     Min Resolution: 800x600, AA 0.3
//   Image_Number = 286 to 291 for the right leg.    Min Resolution: 800x600, AA 0.3
//   Image_Number = 300 to 320 for the left hand.    Min Resolution: 640x480, AA 0.3
//   Image_Number = 321 to 341 for the right hand.   Min Resolution: 640x480, AA 0.3
//   Image_Number = 380 to 383 for the left arm.     Min Resolution: 800x600, AA 0.3
//   Image_Number = 384 to 387 for the right arm.    Min Resolution: 800x600, AA 0.3
//   Image_Number = 400 to 444 for the body.         Min Resolution: 800x600, AA 0.3
//
// To render a single image you can either use command-line option +kfiN, where N is
// the image number you want (e.g. kfi1), or you can set the Image_Number variable 
// directly below (e.g. #declare Image_Number = 5;) 
//
// You can render all of the detailed images using command-line settings:
//    +kfi100 +kff450 +fJ +ofacegroup_  
// This takes about 8 hours and about 90 of those images will be black (where there 
// are gaps in the sequence), but the empty scenes only add a couple of seconds per 
// frame, so add just a couple of minutes to the total render time.
//

// If you need to update the MakeHuman documentation:
// --------------------------------------------------                              
// The online documentation uses JPEG images with quite a high rate of compression.
// POV-Rays command-line option '+fJ' can be used to generate JPEGs directly, but
// they are not very highly compressed. The free IrfanView software can be used to
// further compress the files in batch mode, which takes just a few seconds for 
// hundreds of files. A quality setting of 60% is fine and reduces file sizes to
// about 10% of the size generated by POV-Ray.                     
//
// Use +ofacegroup_ to set the file name prefix used for the online documentation.
// Otherwise you'll need to rename the images before loading them up onto the makehuman 
// site at makehuman.sourceforge.net/FaceGroups/. There are batch scripts in that  
// directory that can be used to rename various sets of files under Windows (and with 
// minor adjustments under Unix/Linux).
//

#declare Image_Number = frame_number;

#include "makehuman.inc"  

// This frame can be tailored to draw any group you need from "makehuman_groupings.inc".
// You'll need to adjust the camera. The figure is centred at the origin with the top of
// the head at 7.4 units high (y) and the bottoms of the feet at -7.4*y. The model is 
// facing out along the positive z-axis with arms outstretched. 
#if (Image_Number=1)
  camera {location <0,7.2,4> look_at 7.2*y}
  light_source {<-10,20,50>, rgb 1}
  #include "makehuman_groupings.inc"

  #declare MakeHuman_SelectedGroups = MakeHuman_HeadGroup;
  object {MakeHuman_Mesh(0) pigment {rgb <1,0.01,0.01>}}
#end

// This frame writes a set of face group names to disk. It generates an empty image.
// You can tailor this to list face group names for any of the facegroups defined in 
// the file "makehuman_groupings.inc".
#if (Image_Number=2) 
  #include "makehuman_groupings.inc"
  #fopen IDENTIFIER "handfacegroupnames.txt" write
  #local I = 0;
  #while (I<21)
    #write( IDENTIFIER,str(I,3,0) ,MakeHuman_LeftHandGroup[I],"\n")
    #local I = I + 1;
  #end  
  #local I = 0;
  #while (I<21)
    #write( IDENTIFIER,str(I,3,0) ,MakeHuman_RightHandGroup[I],"\n")
    #local I = I + 1;
  #end  
#end

// This frame plots the joint positions of the model.
#if (Image_Number=3)
  // Use animation command-line options:
  // +kfi3 +kff3 
  // +fJ for JPEG image file format
  // Best rendered a 800x600 or above
  camera {location <0,0,-20> look_at 0 }
  light_source {<-10,10,-40>, rgb 1}

  #include "makehuman_groupings.inc"
  #local ThisObject = union { 
    #declare MakeHuman_SelectedGroups = MakeHuman_WholeAnatomyGroup
    object {MakeHuman_Mesh(0) pigment {rgbt <1,1,1,0.95>} finish {ambient 0}}
    #declare MakeHuman_SelectedGroups = MakeHuman_JointsArray;
    object {MakeHuman_Mesh(0) pigment {rgb <1,0,0>}}
  }

  // Add objects to the scene
  object {ThisObject rotate y*180 translate -4*x}
  object {ThisObject rotate -y*90 translate 7.5*x}

//  // Add text naming this face group.
//  object {TextObject
//    scale 2
//    translate <-max_extent(TextObject).x,-3.6,0>
//  }
#end

// These two frames illustrate the upper and lower teeth adding the names of the face 
// groups used to define the teeth.
#if (Image_Number=5 | Image_Number=6)
  camera {location <0,1.008,1.25> look_at 1.251*z }
  light_source {<-10,20,-5>, rgb 1}
  #include "makehuman_groupings.inc"

  #if (Image_Number=5)
    #declare MakeHuman_SelectedGroups = MakeHuman_UpperTeethGroup;
  #else 
    #declare MakeHuman_SelectedGroups = MakeHuman_LowerTeethGroup;
  #end
  
  // Generate a POV-Ray mesh2 object
  #declare TeethObject = object {MakeHuman_Mesh(0) pigment {rgb <1,1,0.85>}}
  object {TeethObject
    #if (Image_Number=5)
      translate -y*min_extent(TeethObject)
      rotate 180*z 
    #else
      translate -y*max_extent(TeethObject)
    #end
  } 
  
  // Set the dimension for lines (cylinders) that will lead from the text to the 
  // corresponding teeth.
  #local I = 0;
  #while (I<dimension_size(MakeHuman_SelectedGroups,1)/2)
    #if (Image_Number=5)
      #switch (I)             
        #case (0)
          #local Extension = 0.2; 
        #break
        #case (1)
          #local Extension = 0.15; 
        #break
        #case (2)
          #local Extension = 0.06; 
        #break
        #case (3)
          #local Extension = 0.03; 
        #break
        #case (4)
          #local Extension = 0.01; 
        #break
        #else #local Extension = 0; 
      #end
    #else 
      #switch (I)             
        #case (0)
          #local Extension = 0.21; 
        #break
        #case (1)
          #local Extension = 0.16; 
        #break
        #case (2)
          #local Extension = 0.128; 
        #break
        #case (3)
          #local Extension = 0.07; 
        #break
        #case (4)
          #local Extension = 0.04; 
        #break
        #case (6)
          #local Extension = -0.02; 
        #break
        #case (7)
          #local Extension = -0.03; 
        #break
        #else #local Extension = 0; 
      #end
    #end
    
    // Add the text.
    text{
      ttf "arial.ttf"
      MakeHuman_SelectedGroups[I],
      0.1,0
      pigment {rgb 2} 
      scale 0.03 
      rotate x*90
      #if (Image_Number=5)
        translate <0.38,-0.1,1.6-0.09*I> 
      #else
        translate <-0.7,-0.1,1.6-0.09*I>
      #end
    }
    text{
      ttf "arial.ttf"
      MakeHuman_SelectedGroups[I+dimension_size(MakeHuman_SelectedGroups,1)/2],
      0.1,0
      pigment {rgb 2} 
      scale 0.03 
      rotate x*90
      #if (Image_Number=5)
        translate <-0.7,-0.1,1.6-0.09*I>
      #else
        translate <0.38,-0.1,1.6-0.09*I> 
      #end
    }
    // Draw the horizontal lines.
    cylinder {< (0.32-Extension),-0.1,1.605-0.09*I><0.36,-0.1,1.605-0.09*I>,0.002 pigment {rgb <2,2,0>}}
    cylinder {<-(0.32-Extension),-0.1,1.605-0.09*I><-0.36,-0.1,1.605-0.09*I>,0.002 pigment {rgb <2,2,0>}}
    #local I = I + 1;
  #end
  // Add a few diagonal lines for the top (front) teeth. 
  #if (Image_Number=5)
    cylinder {< 0.12,-0.1,1.605>< 0.07,-0.1,1.55>,0.002 pigment {rgb <2,2,0>}}
    cylinder {<-0.12,-0.1,1.605><-0.07,-0.1,1.55>,0.002 pigment {rgb <2,2,0>}}
  #else
    cylinder {< 0.11,-0.1,1.605>< 0.04,-0.1,1.482>,0.002 pigment {rgb <2,2,0>}}
    cylinder {<-0.11,-0.1,1.605><-0.04,-0.1,1.482>,0.002 pigment {rgb <2,2,0>}}
    cylinder {< 0.16,-0.1,1.515>< 0.12,-0.1,1.465>,0.002 pigment {rgb <2,2,0>}}
    cylinder {<-0.16,-0.1,1.515><-0.12,-0.1,1.465>,0.002 pigment {rgb <2,2,0>}}
  #end
#end
 
 

 
// This macro is used by each of the sections of SDL below. 
// It builds a composit object combining:
//   o  A mesh2 object that represent a recognizable component such as  
//      the head, hands, feet etc.
//   o  A union of thin cylinders representing the edges of the triangular 
//      faces of the model.
//   o  A smaller mesh2 object representing the specific face group being illustrated.
// The larger mesh2 object incorporates some transparency.
#macro ShowElement (MakeHuman_SelectedGroups,ParentGroupName,Offset)   
  #debug concat(ParentGroupName,"Group Dimension: ",str(dimension_size(MakeHuman_SelectedGroups,1),3,0),"\n")
  #debug concat(ParentGroupName,"Group: ",str(frame_number,3,0)," ",MakeHuman_SelectedGroups[frame_number-Offset],"\n")
  #local Orientation = 1;
  
  // Define cylinders showing the edges
  #ifndef (MakeHuman_Cylinder_Radius) #declare MakeHuman_Cylinder_Radius = 0.003; #end
  #local CylinderObject = object {
    MakeHuman_Cylinders(0) 
    texture {
      pigment {rgbt <0,0.04,0,0.6>}
      finish {ambient 0.2}
    }
  }

  // Define a complete but translucent mesh of a recognizable component
  #local MeshObject = object {MakeHuman_Mesh(0) pigment {rgbt <1,1,1,0.75>}}

  // Define the specific face group
  #if (frame_number<=21)
    #declare MakeHuman_SelectedGroups = array[1]{MakeHuman_SelectedGroups[frame_number]};
  #else
    #declare MakeHuman_SelectedGroups = array[1]{MakeHuman_SelectedGroups[frame_number-Offset]};
  #end

  #local FaceGroup = object {MakeHuman_Mesh(0.001) pigment {rgb <1,1,0.01>}}

  // Define the text naming this face group
  #declare TextObject = text{
    ttf "arial.ttf"
    MakeHuman_SelectedGroups[0],
    0.1,0
    pigment {rgb 2} 
    scale 0.2
  }

  // Return a union of these objects
  union {
    object {CylinderObject }
    object {MeshObject     }
    object {FaceGroup      }
  }
#end
 

// These frames illustrate the face groups used to construct the head.
#if (Image_Number>=100 & Image_Number<=179)   
  // Use animation command-line options:
  // +kfi100 +kff179   
  // +fJ for JPEG image file format

  #include "makehuman_groupings.inc" 
  #declare MakeHuman_SelectedGroups = MakeHuman_HeadGroup;
  #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups ,"Head" , 100)}
  
  //The camera position and lighting depend on what we're looking at.
  #local LR = substr(MakeHuman_HeadGroup[frame_number-100],1,2);
  #switch (0)
    #case (strcmp(LR,"l-"))
      camera {location <-2.5,7.1,2.75> look_at 7.1*y}
//      camera {location <-0.5,7.35,2> look_at 7.35*y+1.25*z}                  // Nose Closeup
      light_source {<-10,20,50>, rgb 1}
    #break
    #case (strcmp(LR,"r-"))
      camera {location < 2.5,7.1,2.75> look_at 7.1*y}
//      camera {location < 0.5,7.35,2> look_at 7.35*y+1.25*z}                  // Nose Closeup
      light_source {< 10,20,50>, rgb 1}
    #break
    #else
      camera {orthographic angle 55 location <0,7.1,4> look_at 7.1*y}
//      camera {orthographic angle 25 location <1,6.4,1.8> look_at 6.7*y+1*x+1.25*z}     // Nose Closeup
      light_source {<-10,20,50>, rgb 1}
  #end  
  
  // Add objects to the scene
  #if (strcmp(LR,"l-")=0 | strcmp(LR,"r-")=0) 
    object {ThisObject}
  #else
    // For centralised groups add two at right angles
    object {ThisObject             translate  x}
    object {ThisObject rotate y*90 translate -x*1.55}
  #end
  
  // Add text naming this face group.
  object {TextObject
    #switch (0)
      #case (strcmp(LR,"l-"))
        translate <-1,5.9,-1>
        rotate  y*138
      #break
      #case (strcmp(LR,"r-"))
        translate <-0.3,5.9,-1>
        rotate -y*138
      #break
      #else
        translate <-max_extent(TextObject).x/2,5.85,-1>
        rotate  y*180
    #end
  }
#end   

// These frames illustrate the face groups used to construct the neck.
#if (Image_Number>=190 & Image_Number<=192)   
  // Use animation command-line options:
  // +kfi190 +kff192 
  // +fJ for JPEG image file format
  camera {orthographic location <0,0,-2> look_at 0 angle 80}
  light_source {<-10,10,-40>, rgb 1}

  #include "makehuman_groupings.inc"
  #declare MakeHuman_SelectedGroups = MakeHuman_NeckGroup;
  #declare MakeHuman_Cylinder_Radius = 0.004;
  #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups ,"Neck" , 190)}

  // Add objects to the scene
  object {ThisObject
    translate <0,-6.25,0>
    translate -0.7*x
  }
  object {ThisObject
    translate <0,-6.25,0> 
    rotate y*180
    translate  0.7*x
  }
  
  // Add text naming this face group.
  object {TextObject
    translate <-max_extent(TextObject).x/2,-1,0>
  }
#end

// These frames illustrate the face groups used to construct the feet.
#if (Image_Number>=200 & Image_Number<=241)   
  // Use animation command-line options:
  // +kfi200 +kff220 for left foot, +kfi221 +kff241 for right foot  
  // +fJ for JPEG image file format
  camera {orthographic location <0,-5.5,0.01> look_at -7.4*y angle 80}
  light_source {<-10,20,-4>, rgb 1}

  #include "makehuman_groupings.inc"
  #if (frame_number<=220)                                        
    #declare MakeHuman_SelectedGroups = MakeHuman_LeftFootGroup;
    #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups,"Left Foot" ,200)}
    #local Orientation = 1;
  #else 
    #declare MakeHuman_SelectedGroups = MakeHuman_RightFootGroup;
    #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups,"Right Foot",221)}
    #local Orientation = -1;
  #end
  
  // Add objects to the scene
  object {ThisObject
    rotate -Orientation*y*90 translate <Orientation*0.7,0,0.2>
  }
  object {ThisObject
    rotate -Orientation*y*90 translate <Orientation*0.7,0,0.2>
    translate  y*7.5  
    rotate -x*180
    translate -y*7.5
    translate -z*0.25
  }
  
  // Add text naming this face group.
  object {TextObject
    translate <-max_extent(TextObject).x/2,0,0>
    rotate  <90,180,0>
    translate <0,-7.2,1.1>
  }
#end

// These frames illustrate the face groups used to construct the legs.
#if (Image_Number>=280 & Image_Number<=291)   
  // Use animation command-line options:
  // +kfi280 +kff285 for left leg, +kfi286 +kff291 for right leg  
  // +fJ for JPEG image file format
  camera {orthographic location <0,0,-8.5> look_at 0 angle 80}
  light_source {<-10,10,-40>, rgb 1}

  #include "makehuman_groupings.inc"
  #declare MakeHuman_Cylinder_Radius = 0.008;
  #if (frame_number<=285)                                        
    #declare MakeHuman_SelectedGroups = MakeHuman_LeftLegGroup;
    #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups,"Left Leg" ,280)}
    #local Orientation = 1;
  #else 
    #declare MakeHuman_SelectedGroups = MakeHuman_RightLegGroup;
    #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups,"Right Leg",286)}
    #local Orientation = -1;
  #end
  
  // Add objects to the scene
  object {ThisObject
    translate <0,3.75,0> 
    translate -2.6*Orientation*x
  }
  object {ThisObject
    translate <0,3.75,0>
    rotate -Orientation*y*90
    translate -0.75*Orientation*x
  }
  object {ThisObject
    translate <0,3.75,0> 
    rotate y*180
    translate 0.1*Orientation*x
  }
  object {ThisObject
    translate <0,3.75,0>
    rotate  Orientation*y*90
    translate 2.9*Orientation*x
  }
 
  // Add text naming this face group.
  object {TextObject
    scale 2
    translate <-max_extent(TextObject).x,-5,-1.2>
  }
#end

// These frames illustrate the face groups used to construct the hands.
#if (Image_Number>=300 & Image_Number<=341)   
  // Use animation command-line options:
  // +kfi300 +kff320 for left hand, +kfi321 +kff341 for right hand  
  // +fJ for JPEG image file format
  camera {orthographic location <0,0,-1.85> look_at 0 angle 80}
  light_source {<-10,20,-40>, rgb 1}

  #include "makehuman_groupings.inc"
  #if (frame_number<=320)                                        
    #declare MakeHuman_SelectedGroups = MakeHuman_LeftHandGroup;
    #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups ,"Left Hand" , 300)}
    #local Orientation = 1;
  #else 
    #declare MakeHuman_SelectedGroups = MakeHuman_RightHandGroup;
    #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups,"Right Hand",321)}
    #local Orientation = -1;
  #end
  
  // Add objects to the scene
  object {ThisObject
    translate <Orientation*6.95,-5.2,0>
    rotate -Orientation*z*90
    rotate  Orientation*y*90
    translate  0.4*x*Orientation
  }
  object {ThisObject
    translate <Orientation*6.95,-5.2,0>
    rotate -Orientation*z*90
    rotate -Orientation*y*90
    translate -0.4*x*Orientation
  }
  
  // Add text naming this face group.
  object {TextObject
    translate <-max_extent(TextObject).x/2,-1.05,0>
  }
  sphere {0,0.05 pigment {rgb <1,0,0>}}
#end

// These frames illustrate the face groups used to construct the arms.
#if (Image_Number>=380 & Image_Number<=387)   
  // Use animation command-line options:
  // +kfi380 +kff383 for left arm, +kfi384 +kff387 for right arm  
  // +fJ for JPEG image file format
  camera {orthographic location <0,0,-5> look_at 0 angle 80}
  light_source {<-10,10,-40>, rgb 1}

  #include "makehuman_groupings.inc"
  #declare MakeHuman_Cylinder_Radius = 0.008;
  #if (frame_number<=383)                                        
    #declare MakeHuman_SelectedGroups = MakeHuman_LeftArmGroup;
    #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups,"Left Arm" ,380)}
    #local Orientation = 1;
  #else 
    #declare MakeHuman_SelectedGroups = MakeHuman_RightArmGroup;
    #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups,"Right Arm",384)}
    #local Orientation = -1;
  #end
  
  // Add objects to the scene
  object {ThisObject
    translate <Orientation*4.5,-5,0>
    translate  2*y
  }
  object {ThisObject
    translate <Orientation*4.5,-5,0>
    rotate -x*180
    translate  1*y
  }
  object {ThisObject
    translate <Orientation*4.5,-5,0>
    rotate -x*90
    translate -0.6*y
  }
  object {ThisObject
    translate <Orientation*4.5,-5,0>
    rotate -x*270
    translate -1.7*y
  }

  // Add text naming this face group.
  object {TextObject
    scale 2
    translate <-max_extent(TextObject).x,-2.8,-0.8>
  }
#end

// These frames illustrate the face groups used to construct the body.
#if (Image_Number>=400 & Image_Number<=444)   
  // Use animation command-line options:
  // +kfi400 +kff444 
  // +fJ for JPEG image file format
  // Best rendered a 800x600 or above
  camera {orthographic location <0,0,-6.3> look_at 0 angle 80}
  light_source {<-10,10,-40>, rgb 1}

  #include "makehuman_groupings.inc"
  #declare MakeHuman_SelectedGroups = MakeHuman_BodyGroup;
  #declare MakeHuman_Cylinder_Radius = 0.008;
  #local ThisObject = object {ShowElement (MakeHuman_SelectedGroups ,"Body" , 400)}

  #local LR = substr(MakeHuman_BodyGroup[frame_number-400],1,2);
  #switch (0)
    #case (strcmp(LR,"l-"))
      #local Orientation = 1;
    #break
    #case (strcmp(LR,"r-"))
      #local Orientation = -1;
    #break
    #else
      #local Orientation = 1;
  #end  

  // Add objects to the scene
  object {ThisObject
    translate <0,-2.5,0>
    translate -Orientation*2.6*x
  }
  object {ThisObject
    translate <0,-2.5,0> 
    rotate y*180
    translate  Orientation*2.6*x
  }
  
  // Add text naming this face group.
  object {TextObject
    scale 2
    translate <-max_extent(TextObject).x,-3.6,0>
  }
#end
