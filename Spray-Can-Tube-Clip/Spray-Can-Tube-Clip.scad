/****************************************************************************
 *
 * Spray Can Tube Clip
 *
 * (C) Dave Hylands <dhylands@gmail.com>
 *
 *********************** LICENSING TERMS *************************************
 * This part is not for commercial distribution without a commercial 
 * license acquired from the author. Distribution on a small scale 
 * basis (< 25 units) in the Reprap spirit is free of charge on the
 * basis of mentioning the Author with the bill of material, any 
 * wider distribution requires my explicit, written permission.
 *****************************************************************************/
/*
 * This a clip designed to hold the little (often red) tubes that come with
 * various forms of spray cans (typically for libricants).
 *
 */

//CUSTOMIZER VARIABLES

// Diameter of the can (mm)
CanDiameter = 66;

// Diameter of the hole to hold the tube (mm)
TubeDiameter = 2.3;

// Width of the clip which goes around the can (mm)
ArmWidth = 3;

// Height of the clip which goes around the can (mm)
ArmHeight = 3;

// Height of the piece which holds the tube (mm)
TubeHolderHeight = 6;

// Thickness of the bottom of the tube holder (mm)
BottomTubeThickness = 1;

//CUSTOMIZER VARIABLES END

// The * 1 is so that the variables won't show up in customizer.

$fn = 180 * 1;  // increase resolution of the curves.

CanHeight = 50 * 1;   // debug
TubeHeight = CanHeight - (BottomTubeThickness * 2);  // debug

// Calculate distance from center of can to center of tube
TubeCenter = (CanDiameter + TubeDiameter)/2 + ArmWidth;

module can() {
    cylinder(r=CanDiameter/2, h=CanHeight);
}

module tube() {
    translate([TubeCenter, 0, BottomTubeThickness])
        cylinder(r=TubeDiameter/2, h=TubeHeight);
}

// Display the can for debugging purposes
%can();
%tube();

module holderOutline() {
    // Make the clip which goes around the can
    offset(ArmWidth / 2)
        difference() {
            circle(r=(CanDiameter + ArmWidth)/2+.01);
            rotate(120)
                square([CanDiameter + ArmWidth,
                        CanDiameter + ArmWidth]);
            rotate(150)
                square([CanDiameter + ArmWidth,
                        CanDiameter + ArmWidth]);
            circle(r=(CanDiameter + ArmWidth)/2);
        }
    difference() {
        hull() {
            difference() {
                circle(r=CanDiameter/2 + ArmWidth);
                translate([-((CanDiameter + ArmWidth * 3) / 2), 0])
                    square([CanDiameter + ArmWidth * 3,
                            CanDiameter + ArmWidth * 3], 
                           center=true);
            }
            translate([TubeCenter, 0, 0])
                circle(r=TubeDiameter / 2 + ArmWidth);
        }
        circle(r=(CanDiameter + ArmWidth) / 2);
    }
}

module holderSolid() {
    linear_extrude(height=ArmHeight)
        // Put a fillet where the tube holder joins the clip
        offset(-ArmWidth/2)
        offset(ArmWidth)
        offset(-ArmWidth/2)
            holderOutline();
    translate([TubeCenter, 0, 0])
        cylinder(r=TubeDiameter/2 + ArmWidth, h=TubeHolderHeight);
}

module holder() {
    difference() {
        holderSolid();
        tube();
    }
}

holder();