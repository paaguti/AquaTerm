//
//  AQTImage.h
//  AquaTerm
//
//  Created by Per Persson on Tue Feb 05 2002.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AQTGraphic.h"

typedef struct _AQTAffineTransformStruct {
  float m11, m12, m21, m22;
  float tX, tY;
} AQTAffineTransformStruct;

@interface AQTImage : AQTGraphic
{
  NSData *bitmap;
  NSSize bitmapSize;
  AQTAffineTransformStruct transform;
  BOOL fitBounds;
}
- (instancetype)initWithBitmap:(const char *)bytes size:(NSSize)size bounds:(NSRect)bounds NS_DESIGNATED_INITIALIZER;
@property (readonly, retain) NSData *bitmap;
@property (nonatomic) AQTAffineTransformStruct transform;
@property (readonly) BOOL fitBounds;
@property (readonly) NSSize bitmapSize;
@end
