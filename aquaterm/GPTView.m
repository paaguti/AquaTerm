#import "GPTView.h"
#import "GPTModel.h"

@implementation GPTView
- (id)initWithFrame:(NSRect)frameRect 
{
    // Recursively init superclasses...
    
    if (self = [super initWithFrame:frameRect])
    {
        // If all is well, init own objects...
    }
    // Return the initialized object...
    return self;
}
-(void)dealloc
{
    // Let superclasses do thier own work...
    [super dealloc];
}

-(BOOL)isOpaque
{
    return YES;
}

-(void)drawRect:(NSRect)aRect
{
    //
    // Get the model associated with this view
    //
    GPTModel *modelReference = [[[self window] windowController] model];	// FAQ: Typecast to GPTWindowController to avoid warning?
    NSRect theBounds = [self bounds];
    //
    // Erase background and draw a stylish line around the view 
    //
    [[NSColor whiteColor] set];
    [[NSBezierPath bezierPathWithRect:theBounds] fill];
    [[NSColor blackColor] set];
    [[NSBezierPath bezierPathWithRect:theBounds] stroke];
    //
    // Tell the model to draw itself
    //       
    [modelReference renderInRect:theBounds];
}
@end














