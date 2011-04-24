//
//  GameViewController.m
//  MapAttack
//
//  Created by P. Mark Anderson on 4/23/11.
//  Copyright 2011 Spot Metrix, Inc. All rights reserved.
//

#import "GameViewController.h"
#import "CGPointUtil.h"
#import "MapAttackPlace3D.h"
#import "NSDictionary+BSJSONAdditions.h"

@interface GameViewController (PrivateMethods)
- (void) addJoystick;
- (void) addBirdseyeView;
@end


@implementation GameViewController

@synthesize mapView;

- (void)dealloc 
{
    self.mapView = nil;
    
    [super dealloc];
}



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [SM3DARMapView class];
    
    self.view.multipleTouchEnabled = YES;
    
//    joystickView = [[UIView alloc] initWithFrame:self.view.frame];
//    joystickView.multipleTouchEnabled = YES;
//    [self.view addSubview:joystickView];
    
    mapView.sm3dar.focusView = nil;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addJoystick];
    [self addBirdseyeView];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -

- (void) addJoystick
{
    Coord3D c = { 0, 0, 0 };
    cameraOffset = c;
    [mapView.sm3dar setCameraOffset:cameraOffset];
    

    joystick = [Joystick new];
    //    joystick.center = CGPointMake(74, 120);
    //    joystick.transform = CGAffineTransformMakeRotation(M_PI/2);
    joystick.center = CGPointMake(80, 406);
    
//    [joystickView addSubview:joystick];
    [self.view addSubview:joystick];
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updateJoystick) userInfo:nil repeats:YES];    
    
    
    // Z
    
    joystickZ = [Joystick new];
    //    joystickZ.center = CGPointMake(74, 360);
    //    joystickZ.transform = CGAffineTransformMakeRotation(M_PI/2);
    joystickZ.center = CGPointMake(240, 406);
    
//    [joystickView addSubview:joystickZ];
    [self.view addSubview:joystickZ];
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updateJoystickZ) userInfo:nil repeats:YES];    
    
}


- (void) updateJoystick 
{
    [joystick updateThumbPosition];
    
    CGFloat s = 6.2; // 4.6052;
    
    CGFloat xspeed =  joystick.velocity.x * exp(fabs(joystick.velocity.x) * s);
    CGFloat yspeed = -joystick.velocity.y * exp(fabs(joystick.velocity.y) * s);
    
    if (abs(xspeed) > 0.0 || abs(yspeed) > 0.0) 
    {        
        Coord3D ray = [mapView.sm3dar ray:CGPointMake(160, 240)];
        
        cameraOffset.x += (ray.x * yspeed);
        cameraOffset.y += (ray.y * yspeed);
        //        cameraOffset.z += (ray.z * yspeed);
        
        CGPoint perp = [CGPointUtil perpendicularCounterClockwise:CGPointMake(ray.x, ray.y)];        
        cameraOffset.x += (perp.x * xspeed);
        cameraOffset.y += (perp.y * xspeed);
        
        //NSLog(@"Camera (%.1f, %.1f, %.1f)", offset.x, offset.y, offset.z);
        
        [mapView.sm3dar setCameraOffset:cameraOffset];
    }
}

- (void) updateJoystickZ
{
    [joystickZ updateThumbPosition];
    
    CGFloat s = 6.2; // 4.6052;
    
    //CGFloat xspeed =  joystickZ.velocity.x * exp(fabs(joystickZ.velocity.x));
    CGFloat yspeed = -joystickZ.velocity.y * exp(fabs(joystickZ.velocity.y) * s);    
    
    /*
     if (abs(xspeed) > 0.0) 
     {   
     APP_DELEGATE.gearSpeed += xspeed;
     
     if (APP_DELEGATE.gearSpeed < 0.0)
     APP_DELEGATE.gearSpeed = 0.0;
     
     if (APP_DELEGATE.gearSpeed > 5.0)
     APP_DELEGATE.gearSpeed = 5.0;
     
     NSLog(@"speed: %.1f", APP_DELEGATE.gearSpeed);
     }
     */
    
    if (abs(yspeed) > 0.0) 
    {        
        cameraOffset.z += yspeed;
        
        [mapView.sm3dar setCameraOffset:cameraOffset];
    }
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchCount++;
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];    
    
    if ([touch view] != self.view)
        return;
    
    CGPoint point = [touch locationInView:mapView.sm3dar.view];    
    
    NSLog(@"touches: %i", touchCount);
    
    if (touchCount == 1)
    {
        joystick.center = point;
        joystick.transform = CGAffineTransformMakeRotation([mapView.sm3dar screenOrientationRadians]);
        joystickZ.hidden = YES;
    }
    else if (touchCount == 2)
    {
        joystickZ.center = point;
        joystickZ.transform = CGAffineTransformMakeRotation([mapView.sm3dar screenOrientationRadians]);
        joystickZ.hidden = NO;
    }
    else
    {
        touchCount = 0;
    }
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchCount--;
    if (touchCount < 0)
        touchCount = 0;
}

#pragma mark -

- (void) fetchMapAttackStatus
{
    NSString *url = @"http://mapattack.org/game/1Lx/status.json";
    
    NSString *json = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] 
                                              encoding:NSUTF8StringEncoding 
                                                 error:nil];
    
    NSDictionary *places = [NSDictionary dictionaryWithJSONString:json];
    
    for (NSDictionary *onePlace in [places objectForKey:@"places"]) 
    {
        //MapAttackPlace *place = [[MapAttackPlace alloc] initWithProperties:onePlace];
        MapAttackPlace3D *place = [[MapAttackPlace3D alloc] initWithProperties:onePlace];
        
        NSLog(@"adding place");
        
        [mapView addAnnotation:place]; 
        [place release];        
    }
        
    [mapView zoomMapToFit];
}

- (void) sm3darLoadPoints:(SM3DAR_Controller *)sm3dar
{
    NSLog(@"sm3darLoadPoints");
    
    [self fetchMapAttackStatus];
}

- (void) addBirdseyeView
{
    CGFloat birdseyeViewRadius = 50.0;
    
    birdseyeView = [[BirdseyeView alloc] initWithLocations:mapView.sm3dar.pointsOfInterest
                                                    around:mapView.sm3dar.currentLocation 
                                            radiusInPixels:birdseyeViewRadius];
    
    birdseyeView.center = CGPointMake(self.view.frame.size.width - (birdseyeViewRadius) - 10, 
                                      10 + (birdseyeViewRadius));
    
    [self.view addSubview:birdseyeView];
    
    mapView.sm3dar.compassView = birdseyeView;    
}

- (void) sm3darDidHideMap:(SM3DAR_Controller *)sm3dar
{
    birdseyeView.hidden = NO;
    joystick.hidden = NO;
    joystickZ.hidden = NO;
}

- (void) sm3darDidShowMap:(SM3DAR_Controller *)sm3dar
{
    birdseyeView.hidden = YES;
    joystick.hidden = YES;
    joystickZ.hidden = YES;
}

@end
