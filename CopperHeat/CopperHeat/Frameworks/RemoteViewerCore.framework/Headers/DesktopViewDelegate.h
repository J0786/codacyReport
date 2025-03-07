// Copyright (C) 2020 GlavSoft LLC.
// All rights reserved.
//
// DO NOT USE OR REDISTRIBUTE THE CODE, UNLESS YOU HAVE OBTAINED A LICENSE.
//

#ifndef DesktopViewDelegate_h
#define DesktopViewDelegate_h

#import <Foundation/Foundation.h>
#import "FrameBufferWrapper.h"

@protocol DesktopViewDelegate

- (id)initWithViewController:(__weak id)controller;
- (void)setCallback:(__weak id)viewerCore;
- (void)setFrameBuffer:(__weak FrameBufferWrapper *)frameBuffer;

/**
 * @abstract Connection has been established event
*/
- (void)onEstablished;

/**
 * @abstract This event after update of frame buffer "fb" in rectangle "update"
 * @discussion Frame buffer contents has been changed. During this callback, the frame buffer is locked, and the rectangle is guaranteed to be valid (no guarantees about other areas of the frame buffer).
 * @param rect CGRect rectangle of updated fragment of framebuffer
*/
- (void)onPerformUpdate:(CGRect)rect;

/**
 * @abstract Error has been occured event
 * @param message Details about the error
*/
- (void)onError:(NSString *)message;

/**
 * @abstract RemoteViewerCore has been disconnected by calling stop() or connection with server is disconnected.
 * @param message Details about the reason of disconnect
*/
- (void)onDisconnect:(NSString *)message;

/**
 * @abstract Show "Connecting..." progress dialog
*/
- (void)showProgressDialog;

/**
 * @abstract Hide "Connecting..." progress dialog
*/
- (void)hideProgressDialog;

/**
 * @abstract Password request callback
*/
- (NSString *)askPassword;

@end

#endif /* DesktopViewDelegate_h */
