//
//  MapattackPlace.m
//  GeoEvents
//
//  Created by P. Mark Anderson on 4/22/11.
//  Copyright 2011 Redwater software. All rights reserved.
//

#import "MapAttackPlace.h"

@implementation MapAttackPlace

@synthesize placeID;
@synthesize points;
@synthesize active;
@synthesize team;
@synthesize coordinate;

- (void) dealloc
{
    [placeID release];
    [team release];
    
    [super dealloc];
}

- (id) initWithProperties:(NSDictionary *)props
{
    CLLocationCoordinate2D c;
    c.longitude = [[props objectForKey:@"longitude"] doubleValue];
    c.latitude = [[props objectForKey:@"latitude"] doubleValue];
    
    if (self = [super init])
    {
        self.placeID = [props objectForKey:@"place_id"];
        self.points = [[props objectForKey:@"points"] integerValue];

        id value = [props objectForKey:@"team"];
  
        if (value && value != [NSNull null])
            self.team = value;
        else
            self.team = nil;
        
        self.active = [[props objectForKey:@"active"] boolValue];
        self.coordinate = c;
    }
    
    return self;
}

- (NSString *)title
{
    NSString *t = self.team;
    
    if (!t || [t length] == 0)
    {
        t = @"Open";
    }
    
    return t;
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%i", self.points];
}

@end
