//
//  AQTStringDrawingAdditions.h
//  AquaTerm
//
//  Created by Per Persson on Thu Oct 14 2004.
//  Copyright (c) 2004-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/NSString.h>
#import <Foundation/NSAttributedString.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

/* Using an undocumented method in NSFont. */
@interface NSFont (NSFontHiddenMethods)
- (NSGlyph)_defaultGlyphForChar:(unichar)theChar;
@end

@interface NSString (AQTStringDrawingAdditions)
-(NSBezierPath *)aqtBezierPathInFont:(NSFont *)aFont;
@end

@interface NSAttributedString (AQTStringDrawingAdditions)
-(NSBezierPath *)aqtBezierPathInFont:(NSFont *)aFont;
@end

NS_ASSUME_NONNULL_END
