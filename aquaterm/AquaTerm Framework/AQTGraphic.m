//
//  AQTGraphic.m
//  AquaTerm
//
//  Created by ppe on Wed May 16 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import "AQTGraphic.h"

typedef struct _AQTColor_v100 {
   float red;
   float green;
   float blue;
} AQTColor_v100;

@implementation AQTGraphic
@synthesize clipped = _isClipped;
@synthesize clipRect = _clipRect;

- (id)replacementObjectForPortCoder:(NSPortCoder *)portCoder
{
   if ([portCoder isBycopy])
      return self;
   return [super replacementObjectForPortCoder:portCoder];
}

-(instancetype)init
{
   if (self = [super init]) {
      _color.red = 1.;
      _color.green = 1.;
      _color.blue = 1.;
      _color.alpha = 1.;
   }
   return self;
}

#if !__has_feature(objc_arc)
-(void)dealloc
{
   [_cache release];
   [super dealloc];
}
#endif

-(NSString *)description
{
   return NSStringFromRect(_bounds);
}

#define AQTGraphicColorKey @"ColorKey"
#define AQTGraphicBoundsKey @"BoundsKey"
#define AQTGraphicClipRectKey @"ClipRectKey"
#define AQTGraphicIsClippedKey @"IsClippedKey"

+ (BOOL)supportsSecureCoding;
{
   return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
   [coder encodeObject:[NSValue value:&_color withObjCType:@encode(AQTColor)] forKey:AQTGraphicColorKey];
   [coder encodeRect:_bounds forKey:AQTGraphicBoundsKey];
   [coder encodeRect:_clipRect forKey:AQTGraphicClipRectKey];
   [coder encodeBool:_isClipped forKey:AQTGraphicIsClippedKey];
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
   AQTRect r;
   if (self = [super init]) {
      if (coder.allowsKeyedCoding && [coder containsValueForKey:AQTGraphicColorKey]) {
         NSValue *tmpColor = [coder decodeObjectOfClass:[NSValue class] forKey:AQTGraphicColorKey];
         [tmpColor getValue:&_color];
         _bounds = [coder decodeRectForKey:AQTGraphicBoundsKey];
         _clipRect = [coder decodeRectForKey:AQTGraphicClipRectKey];
         _isClipped = [coder decodeBoolForKey:AQTGraphicIsClippedKey];
      } else {
         [coder decodeValueOfObjCType:@encode(AQTColor) at:&_color];
         [coder decodeValueOfObjCType:@encode(AQTRect) at:&r];
         _bounds.origin.x = r.origin.x; _bounds.origin.y = r.origin.y;
         _bounds.size.width = r.size.width; _bounds.size.height = r.size.height;
         [coder decodeValueOfObjCType:@encode(AQTRect) at:&r];
         _clipRect.origin.x = r.origin.x; _clipRect.origin.y = r.origin.y;
         _clipRect.size.width = r.size.width; _clipRect.size.height = r.size.height;
         [coder decodeValueOfObjCType:@encode(BOOL) at:&_isClipped];
      }
   }
   return self;
}

- (BOOL)shouldShowBounds
{
   return _shouldShowBounds;
}

- (void)toggleShouldShowBounds
{
   _shouldShowBounds = !_shouldShowBounds;
}
//
//	Stubs, needs to be overridden by subclasses
//
@synthesize bounds = _bounds;
@synthesize color = _color;

- (void)setIsClipped:(BOOL)newClip
{
   self.clipped = newClip;
}

@end
