// Copyright (C) 2020 GlavSoft LLC.
// All rights reserved.
//
// DO NOT USE OR REDISTRIBUTE THE CODE, UNLESS YOU HAVE OBTAINED A LICENSE.
//

#ifndef ViewControllerCallbackDelegate_h
#define ViewControllerCallbackDelegate_h

#import <Foundation/Foundation.h>

@protocol ViewControllerCallbackDelegate <NSObject>

- (void)onEstablished;
- (void)onError:(NSString *)errorMessage;
- (void)onDisconnect:(NSString *)message;
- (void)updateMouseToolPosition:(CGPoint)position;
- (NSString *)askPassword;

@end
#endif /* ViewControllerCallbackDelegate_h */
