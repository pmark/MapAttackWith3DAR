//
//  MapAttackDotView.m
//  GeoEvents
//
//  Created by P. Mark Anderson on 4/22/11.
//  Copyright 2011 Redwater software. All rights reserved.
//

#import "MapAttackDotView.h"


@implementation MapAttackDotView

- (id) initWithOBJ:(NSString*)_objName textureNamed:(NSString*)name 
{
    if (self = [super initWithTextureNamed:name]) 
    {    
    }
    
    return self;
}

- (void) didReceiveFocus
{
    NSLog(@"didReceiveFocus");
}


@end
