// Copyright (C) 2020 GlavSoft LLC.
// All rights reserved.
//
// DO NOT USE OR REDISTRIBUTE THE CODE, UNLESS YOU HAVE OBTAINED A LICENSE.
//

#import <Foundation/Foundation.h>

@interface EncodingDefsWrapper : NSObject

+ (int)RAW;
+ (int)COPYRECT;
+ (int)RRE;
+ (int)HEXTILE;
+ (int)TIGHT;
+ (int)ZRLE;

+ (int)COMPR_LEVEL_0;
+ (int)COMPR_LEVEL_1;
+ (int)COMPR_LEVEL_2;
+ (int)COMPR_LEVEL_3;
+ (int)COMPR_LEVEL_4;
+ (int)COMPR_LEVEL_5;
+ (int)COMPR_LEVEL_6;
+ (int)COMPR_LEVEL_7;
+ (int)COMPR_LEVEL_8;
+ (int)COMPR_LEVEL_9;

+ (int)QUALITY_LEVEL_0;
+ (int)QUALITY_LEVEL_1;
+ (int)QUALITY_LEVEL_2;
+ (int)QUALITY_LEVEL_3;
+ (int)QUALITY_LEVEL_4;
+ (int)QUALITY_LEVEL_5;
+ (int)QUALITY_LEVEL_6;
+ (int)QUALITY_LEVEL_7;
+ (int)QUALITY_LEVEL_8;
+ (int)QUALITY_LEVEL_9;

@end
