//
//  OBJView.m
//
//

#import <UIKit/UIKit.h>
#import "SM3DAR.h"

@interface OBJView : TexturedGeometryView 
{
    NSString *objName;
}

- (id) initWithOBJ:(NSString*)_objName textureNamed:(NSString*)name;

@end
