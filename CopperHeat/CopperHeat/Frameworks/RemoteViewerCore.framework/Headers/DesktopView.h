// Copyright (C) 2015-2020 GlavSoft LLC.
// All rights reserved.
//
// DO NOT USE OR REDISTRIBUTE THE CODE, UNLESS YOU HAVE OBTAINED A LICENSE.
//

#import <UIKit/UIKit.h>
#import "DesktopViewDelegate.h"
#import "ViewerCore.h"

@interface DesktopView : UIView <DesktopViewDelegate, UIAlertViewDelegate, CALayerDelegate>
{
  NSString *host;
  int port;
}

@property BOOL isConnected;

/**
 * @abstract Capture full-framed screenshot to store it in device's gallery
*/
- (UIImage *)capture;

/**
 * @abstract Capture small compress screenshot to use it as a thumbnail for connection
*/
- (UIImage *)captureThumbnail;

/**
 * @abstract Switchs the way iOS draws remote desktop content
 * @warning Experimental feature!
 * @discussion If TiledLayer is on, then iOS optimizes memory usage, but there is lack of drawing speed.
 * If TiledLayer is off, then the app consumes much more memory, but draws remote desktop very fast.
 * @param on YES to use CATiledLayer, NO to use ordinal CALayer
*/
+ (void)setTiledLayerOn:(BOOL)on;

@end
