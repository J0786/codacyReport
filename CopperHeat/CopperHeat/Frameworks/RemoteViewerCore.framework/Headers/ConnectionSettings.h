// Copyright (C) 2020 GlavSoft LLC.
// All rights reserved.
//
// DO NOT USE OR REDISTRIBUTE THE CODE, UNLESS YOU HAVE OBTAINED A LICENSE.
//


#import <Foundation/Foundation.h>
#import "PixelFormatWrapper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConnectionSettings : NSObject

@property (atomic) NSString* host;
@property (atomic) NSNumber* port;
@property (atomic) PixelFormatWrapper* pixelFormat;
@property (atomic) NSNumber* encoding;
@property (atomic) NSNumber* jpegQuality;

@end

NS_ASSUME_NONNULL_END
