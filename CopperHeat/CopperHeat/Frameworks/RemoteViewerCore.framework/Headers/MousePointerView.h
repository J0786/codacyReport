// Copyright (C) 2015-2019 GlavSoft LLC.
// All rights reserved.
//
// DO NOT USE OR REDISTRIBUTE THE CODE, UNLESS YOU HAVE OBTAINED A LICENSE.
//

#import "TargetConditionals.h"

#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
@interface MousePointerView : UIView
#elif TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
@interface MousePointerView : NSView
#endif

- (void)updatePosition:(CGPoint)position;
- (void)updateScale:(float)scale;
- (void)updateCursorShape:(unsigned char *)cursor Bitmask:(const char *)bitmask Width:(UInt16)width Height:(UInt16)height HotSpot:(CGPoint)hotSpot;
- (CGPoint)hotSpot;
- (CGPoint)position;

@end
