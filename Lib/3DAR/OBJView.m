//
//  OBJView.m
//
//

#import <OpenGLES/ES1/gl.h>
#import "OBJView.h"

extern float degreesToRadians(float degrees);
extern float radiansToDegrees(float radians);

static Geometry *staticGeometry = nil;
static Texture *staticTexture = nil;

@implementation OBJView

- (void) dealloc
{
    [staticTexture release];
    [staticGeometry release];
    [objName release];
    
    [super dealloc];
}

- (id) initWithOBJ:(NSString*)_objName textureNamed:(NSString*)name 
{
    if (self = [super initWithTextureNamed:name]) 
    {  
        // Geometry
        objName = [_objName retain];        
        NSString *path = [[NSBundle mainBundle] pathForResource:objName ofType:nil];

        staticGeometry = [Geometry newOBJFromResource:path];
        
//        if (staticGeometry == nil)
//        {
//            staticGeometry = [Geometry newOBJFromResource:path];
//        }
//        else
//        {
//            [staticGeometry retain];
//        }
        
        self.geometry = staticGeometry;
        self.geometry.cullFace = NO;
        self.sizeScalar = 1.0;           // .08;  // 80 mm targets    
    }
    
    return self;
}

- (void) buildView 
{
    
    // Texture
    
    if (staticTexture == nil && [self.textureName length] > 0) 
    {
        NSLog(@"Loading texture named %@", self.textureName);
        
        NSString *textureExtension = [[self.textureName componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *textureBaseName = [self.textureName stringByDeletingPathExtension];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:textureBaseName ofType:textureExtension];
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath];         
        UIImage *textureImage =  [[UIImage alloc] initWithData:imageData];        
        CGImageRef cgi = textureImage.CGImage;
        

        // Create this texture only one time.
        
        staticTexture = [Texture newTextureFromImage:cgi];
        
        [imageData release];
        [textureImage release];
    }
    else 
    {
        [staticTexture retain];
    }

    self.texture = staticTexture;
}

- (void) displayGeometry 
{
    if (self.texture == nil && [self.textureName length] > 0) 
    {
        NSLog(@"Loading texture named %@", self.textureName);
        NSString *textureExtension = [[self.textureName componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *textureBaseName = [self.textureName stringByDeletingPathExtension];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:textureBaseName ofType:textureExtension];
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath];         
        UIImage *textureImage =  [[UIImage alloc] initWithData:imageData];        
        CGImageRef cgi = textureImage.CGImage;

        self.texture = [[Texture newTextureFromImage:cgi] autorelease];        

        [imageData release];
        [textureImage release];
    }

//    glRotatef(headingDegrees, 0, 0, 1);
//    glRotatef((pitchDegrees-90), 1, 0, 0);  // square.obj is oriented up.
    
    glScalef(self.sizeScalar, self.sizeScalar, self.sizeScalar);
  
    
    if (self.texture)
        [self.geometry displayFilledWithTexture:self.texture];
    else
        [self.geometry displayShaded:self.color];
        //[self.geometry displayWireframe];
}

- (void) didReceiveFocus
{
    NSLog(@"OBJView: didReceiveFocus");
}


@end
