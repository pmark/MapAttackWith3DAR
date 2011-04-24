//
//  GameViewController.h
//  MapAttack
//
//  Created by P. Mark Anderson on 4/23/11.
//  Copyright 2011 Spot Metrix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SM3DAR.h"
#import "Joystick.h"
#import "BirdseyeView.h"

@class SM3DARMapView;

@interface GameViewController : UIViewController <MKMapViewDelegate, SM3DAR_Delegate>
{
	IBOutlet SM3DARMapView *mapView;
    NSArray *events;
    BirdseyeView *birdseyeView;
    
    Joystick *joystick;
    Joystick *joystickZ;
    Coord3D cameraOffset;
    UIView *joystickView;
    NSInteger touchCount;
}

@property (nonatomic, retain) IBOutlet SM3DARMapView *mapView;

@end
