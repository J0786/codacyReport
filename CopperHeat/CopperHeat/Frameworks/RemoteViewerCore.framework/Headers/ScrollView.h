// Copyright (C) 2015-2020 GlavSoft LLC.
// All rights reserved.
//
// DO NOT USE OR REDISTRIBUTE THE CODE, UNLESS YOU HAVE OBTAINED A LICENSE.
//

#import <UIKit/UIKit.h>
#import "MousePointerView.h"

@interface ScrollView : UIScrollView <UIScrollViewDelegate>

- (void)setMousePointerView:(MousePointerView *)mousePointerView;
- (BOOL)useExternalCursor;
- (void)updateMousePointerPosition:(CGPoint)position;

@end
