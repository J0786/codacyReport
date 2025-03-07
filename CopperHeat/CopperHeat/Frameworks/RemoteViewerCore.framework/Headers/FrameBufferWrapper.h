// Copyright (C) 2015,2016,2017 GlavSoft LLC.
// All rights reserved.
//
// DO NOT USE OR REDISTRIBUTE THE CODE, UNLESS YOU HAVE OBTAINED A LICENSE.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface FrameBufferWrapper : NSObject {
}

- (void)assignProperties:(void *)frameBufferParam;
- (float)width;
- (float)height;
- (UInt32 *)intBuffer;
- (BOOL)checkBigEndian;
- (size_t)bitsPerPixel;
- (size_t)bytesPerPixel;

@end
