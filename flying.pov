// Created by Kevin Cole <kjcole@ubuntu> 2012.12.27
// This software is released under the the Creative Commons 
// Attribution-NonCommercial-ShareAlike 3.0 licence (CC BY-NC-SA 3.0)
// http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US
//
// Animated "Kermit" on a swing, with flying camera.
//

#include "colors.inc"      // Basic colors
#include "woods.inc"       // Wood grains
#include "skies.inc"       // Skies
#include "transforms.inc"  // Non-standard transformation macros

global_settings { max_trace_level 20 }

//light_source { < 300, 300, -500> White }  // From the right, above, behind camera
light_source { <-250, 300, -200> White }
light_source { <-10, 0, -1000> Gray50 }

//background { color Gray50 }
background { color <0.75, 0.75, 1> }
sky_sphere { S_Cloud2 }

plane { <0, 1, 0>, -1
  pigment {
    checker color Red, color Blue
  }
}

//sphere { <0, 0, 0> 1     // DEBUG - Orientation sphere
//  pigment { Green }      // DEBUG - Orientation sphere
//}                        // DEBUG - Orientation sphere

#declare Half_Torus = difference {
  torus {
    4,1           // Major (orbit), minor (planet)
    sturm         // Use slower but more accurate calculations
    rotate x*-90  // so we can see it from the top
  }
  box { <-5, -5, -1>, <5, 0, 1> } // Masks out lower half
}

#declare Flip_It_Over    = x*180;
#declare Torus_Translate = 8;

#declare Chain_Segment = cylinder {
  <0, 4, 0>, <0, -4, 0>, 1
}

#declare Chain_Gold = texture {
  pigment { BrightGold }
  finish {
    ambient .1
    diffuse .4
    reflection .25
    specular 1
    metallic
  }
}

#declare Link = union {
  object {
    Half_Torus
    translate y*Torus_Translate/2    // Move half-torus up
  }
  object {
    Half_Torus
    rotate Flip_It_Over              // Upside down
    translate -y*Torus_Translate/2   // Move upside-down half-torus down
  }
  object {
    Chain_Segment                    // Joining cylinder
    translate x*Torus_Translate/2    // Move it to right side of half-tori
  }
  object {
    Chain_Segment                    // Joining cylinder
    translate -x*Torus_Translate/2   // Move it to left side of half-tori
  }
  texture { Chain_Gold }
}  

#declare Link_Translate = Torus_Translate*2-2*y;

#declare Link_Pair =  union {
    object { Link }
    object { Link translate y*Link_Translate rotate y*90 }
  }

#declare Chain = union {
  object { Link_Pair translate  y*Link_Translate*2 }
  object { Link_Pair translate  y*Link_Translate*4 }
  object { Link_Pair translate  y*Link_Translate*6 }
  object { Link_Pair}
  object { Link_Pair translate -y*Link_Translate*2 }
  object { Link_Pair translate -y*Link_Translate*4 }
  object { Link_Pair translate -y*Link_Translate*6 }
  rotate y*90
}

#declare Chains = union {
  object { Chain scale 0.1 translate -5*x }
  object { Chain scale 0.1 translate  5*x }
//rotate <0, 45, 30>
}

#declare Top_Bar = object {
  cylinder { <-10, 10, 0>, <10, 10, 0>, 1 }
}

#declare Seat = object {
  box { <-6, -5, -1>, <6, 0, 0> }
  texture { T_Wood1 }
  rotate 90*x
  translate <0, -9, 2.5>
}

#declare Swing = union {
  object { Chains }
  object { Seat }
//object { Top_Bar }
}

#declare Right_Eye = union {
  sphere { <-0.8, 16.5, -2.0>, 0.65  // Right eye
    pigment { Black }
  }
  difference {
    sphere { <-0.8, 16.5, -2.0>, 0.66  // Right eye
      pigment { White }
    }
    cylinder { <-0.8, 16.5, -2.0> <-0.6, 16.5, -2.66>, 0.2  // Right pupil
      pigment { Black }
    }
  }
}

#declare Left_Eye = union {
  sphere { <0.8, 16.5, -2.0>, 0.65   // Left eye
    pigment { Black }
  }
  difference {
    sphere { <0.8, 16.5, -2.0>, 0.66   // Left eye
      pigment { White }
    }
    cylinder { <0.8, 16.5, -2.0> <1.0, 16.5, -2.66>, 0.2  // Left pupil
      pigment { Black }
    }
  }
}

#declare Head = union {
//sphere { <0, 16, 0>, 2.5 }
  sphere   { <0, 16.5, 0>, 2 }
  cylinder { <0, 16.5, 0>, <0, 15.5, 0>, 2 }
  sphere   { <0, 15.5, 0>, 2 }
  object { Right_Eye }
  object { Left_Eye }
}

#declare Neck = union {
  cylinder { <0, 13.5, 0>, <0, 13, 0>, 0.5 }
  sphere   { <0, 13.5, 0>, 0.5 }
  sphere   { <0, 13,   0>, 0.5 }
}

#declare Torso = union {
  cylinder { <0, 11.5, 0>, <0, 9.5, 0>, 1.5 }
  sphere   { <0, 11.5, 0>, 1.5 }
  sphere   { <0,  9.5, 0>, 1.5 }
  sphere   { <-0.5, 8.5, 0>, 1.2 }
  sphere   { < 0.5, 8.5, 0>, 1.2 }
}

#declare Right_Arm = union {
  cylinder { <-1.5, 12, 0>, <-4, 12, 0>, 0.66 }
  sphere   { <-1.5, 12, 0>, 0.66 }
  sphere   { <-4,   12, 0>, 0.66 }
}

#declare Left_Arm = union {
  Right_Arm
  translate 5.5*x
}

#declare Right_Leg = union {
  cylinder { <-1, 8,  0>, <-1, 8, -5>, 0.66 }
  sphere   { <-1, 8,  0>, 0.66 }
  sphere   { <-1, 8, -5>, 0.66 }
  cylinder { <-1, 8, -5>, <-1, 4, -5>, 0.66 }
  sphere   { <-1, 4, -5>, 0.66 }
  cone     { <-1, 4, -5>, 0.66,
             <-1, 4, -7>, 0.2 }
  sphere   { <-1, 4, -7>, 0.2 }
}

#declare Left_Leg = object {
  Right_Leg
  translate 2*x
}

#declare Kid = union {
  object { Head }
  object { Neck }
  object { Torso }
  object { Right_Arm }
  object { Left_Arm }
  object { Right_Leg }
  object { Left_Leg }
  pigment { Green }
}

camera {
  look_at  <0  10, 0>
  location <-35*sin(radians(clock*2)), 10, -35*cos(radians(clock*2))>
}

union {
  object { Swing 
    translate 15*y
  }
  object { Kid
    translate -0.2*y
  }
//rotate <0, 45, 30>       // Side view

  // Animate!
  #declare Angle = 0;
  #switch (clock)
    #range (0, 44)
      #declare Angle = clock;
    #break
    #range (45, 134)
      #declare Angle = 45 - (clock - 45);
    #break
    #range (135, 179)
      #declare Angle = (clock - 135) - 45;
    #break
  #end
  Rotate_Around_Trans(<Angle, 0, 0>, <0, 25.5, 0>)
}
