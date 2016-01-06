//
//  AQTGraphic+NonSwiftable.m
//  AquaTerm
//
//  Created by C.W. Betts on 1/5/16.
//
//

#import <Cocoa/Cocoa.h>
#import "AQTGraphic+NonSwiftable.h"
#import <AquaTerm/AQTFunctions.h>
#import "AQTStringDrawingAdditions.h"

/* _aqtMinimumLinewidth is used by view to pass user prefs to line drawing routine,
 this is ugly, but I can't see a simple way to do it without affecting performance. */
static float _aqtMinimumLinewidth;


@implementation AQTGraphic (NonSwiftable)

-(void)_setCache:(id)object
{
	[object retain];
	[_cache release];
	_cache = object;
}

-(id)_cache
{
	return _cache;
}

@end


@implementation AQTLabel (AQTLabelDrawing)
-(void)_aqtLabelUpdateCache
{
	NSFont *normalFont;
	NSAffineTransform *aTransform = [NSAffineTransform transform];
	NSAffineTransform *shearTransform = [NSAffineTransform transform];
	NSAffineTransformStruct ts;
	NSBezierPath *tmpPath = [NSBezierPath bezierPath];
	NSSize tmpSize;
	NSPoint adjust = NSZeroPoint;
	// Make sure we get a valid font....
	if ((normalFont = [NSFont fontWithName:fontName size:fontSize]) == nil)
		normalFont = [NSFont systemFontOfSize:fontSize]; // Fall back to a system font
	// Convert (attributed) string into a path
	tmpPath = [string aqtBezierPathInFont:normalFont]; // Implemented in AQTStringDrawingAdditions
	tmpSize = [tmpPath bounds].size;
	// Place the path according to position, angle and align
	adjust.x = -(float)(justification & 0x03)*0.5*tmpSize.width; // hAlign:
	switch (justification & 0x1C) { // vAlign:
		case 0x00:// AQTAlignMiddle: // align middle wrt *font size*
			adjust.y = -([normalFont descender] + [normalFont capHeight])*0.5;
			break;
		case 0x08:// AQTAlignBottom: // align bottom wrt *bounding box*
			adjust.y = -[tmpPath bounds].origin.y;
			break;
		case 0x10:// AQTAlignTop: // align top wrt *bounding box*
			adjust.y = -([tmpPath bounds].origin.y + tmpSize.height) ;
			break;
		case 0x04:// AQTAlignBaseline: // align baseline (do nothing)
		default:
			// default to align baseline (do nothing) in case of error
			break;
	}
	// Avoid multiples of 90 degrees (pi/2) since tan(k*pi/2)=inf, set beta to 0.0 instead.
	float beta = (fabs(shearAngle - 90.0*roundf(shearAngle/90.0))<0.1)?0.0:-shearAngle;
	// shearTransform is an identity transform so we can just stuff the shearing into m21...
	ts = [shearTransform transformStruct];
	ts.m21 = -tan(beta*atan(1.0)/45.0); // =-tan(beta*pi/180.0)
	[shearTransform setTransformStruct:ts];
	[tmpPath transformUsingAffineTransform:shearTransform];
	// Now, place the sheared label correctly
	[aTransform translateXBy:position.x yBy:position.y];
	[aTransform rotateByDegrees:angle];
	[aTransform translateXBy:adjust.x yBy:adjust.y];
	[tmpPath transformUsingAffineTransform:aTransform];
	
	[self _setCache:tmpPath];
}

@end

@implementation AQTPath (AQTPathDrawing)
-(void)_aqtPathUpdateCache
{
	_aqtMinimumLinewidth = [[NSUserDefaults standardUserDefaults] floatForKey:@"MinimumLinewidth"];
	int32_t i;
	CGFloat lw = [self isFilled]?1.0:linewidth; // FIXME: this is a hack to avoid tiny gaps between filled patches
	NSBezierPath *scratch = [NSBezierPath bezierPath];
	[scratch appendBezierPathWithPoints:path count:pointCount];
	[scratch setLineJoinStyle:NSRoundLineJoinStyle]; //CM FIXME - This looks like a bug. This explains why join styles don't work in the TestView... //CM
	[scratch setLineCapStyle:(NSLineCapStyle)lineCapStyle];
	[scratch setLineWidth: MAX(lw, _aqtMinimumLinewidth)];
	if([self hasPattern]) {
		CGFloat temppat[patternCount];
		for( i = 0; i < patternCount; i++) temppat[i] = pattern[i];
		[scratch setLineDash:temppat count:patternCount phase:patternPhase];
	}
	if([self isFilled]) {
		[scratch closePath];
	}
	if(EQ(path[0].x, path[pointCount-1].x) && EQ(path[0].y, path[pointCount-1].y)) {
		// This looks like a closed path..., make it so.
		[scratch closePath];
	}
	[self _setCache:scratch];
}
@end
