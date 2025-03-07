// Copyright (C) 2017-2020 GlavSoft LLC.
// All rights reserved.
//
// DO NOT USE OR REDISTRIBUTE THE CODE, UNLESS YOU HAVE OBTAINED A LICENSE.
//


#import <Foundation/Foundation.h>

@interface PixelFormatWrapper : NSObject

- (id)initWithBitsPerPixel:(UInt8)bitsPerPixel
                colorDepth:(UInt8)colorDepth

                    redMax:(UInt16)redMax
                  greenMax:(UInt16)greenMax
                   blueMax:(UInt16)blueMax

                  redShift:(UInt8)redShift
                greenShift:(UInt8)greenShift
                 blueShift:(UInt8)blueShift

                 bigEndian:(UInt8)bigEndian;

- (id)init16Bit;
- (id)init32Bit;
- (const void *)pixelFormat;

- (size_t)bitsPerPixel;

@end
