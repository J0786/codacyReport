// Copyright (C) 2015-2020 GlavSoft LLC.
// All rights reserved.
//
// DO NOT USE OR REDISTRIBUTE THE CODE, UNLESS YOU HAVE OBTAINED A LICENSE.
//


#import <Foundation/Foundation.h>

#import "MousePointerView.h"
#import "PixelFormatWrapper.h"
#import "IRetrieveConnectionId.h"
#import "DesktopViewDelegate.h"

/**
 * RemoteViewerCore implements a local representation of a live remote screen updated in real time via the RFB protocol. It maintains screen data in its own frame buffer and notifies the target class (the adapter) about various events like changes in the frame buffer, incoming clipboard transfers from the server, protocol state changes and so on.
 *
 * Also, it implements remote control feature by passing arbitrary keyboard and pointer events to the remote computer.
 *
 * The interface of this class hides all the complexity of the RFB protocol and provides the caller with an easy way to maintain an RFB connection and get access to the screen data.
 * Each function of this class may be called from any thread and from any number of threads simultaneously on the same object, unless documented otherwise. Also, each function can be called on any stage of the protocol, and even from callback functions of the adapter (see more about callbacks and the adapter below), unless documented otherwise.
 */
@interface ViewerCore : NSObject

/**
 * @abstract Deprecated initialiser
 * @discussion The method initializes the object, attach it to the
 * specified data connection (e.g. an open TCP/IP socket), set callbacks for
 * events originating in the object, and start operation.
 * @param desktopView A pointer to instance implements DesktopViewDelegate protocol
 * @param mousePointerView A pointer to MousePointerView instance
*/
- (id)initWithDesktopView:(id <DesktopViewDelegate>)desktopView
         MousePointerView:(MousePointerView *)mousePointerView
  API_DEPRECATED("The method is no longer supported. Use instead:\ninitWithDesktopView:(DesktopView *)desktopView\n    MousePointerView:(MousePointerView *)mousePointerView\n    Host:(NSString *)host\n    Port:(int)port\n    PixelFormat:(PixelFormatWrapper *)pixelFormat\n    Encoding:(int)encodingType", ios(7.0, 7.1))
;

/**
 * @abstract ViewerCore initialiser with preferred encoding, jpeg quality lelel, and custom pixel format
 * @discussion The method initializes the object, attach it to the
 * specified data connection (e.g. an open TCP/IP socket), set callbacks for
 * events originating in the object, and start operation.
 * @param desktopView A pointer to DesktopView instance
 * @param mousePointerView A pointer to MousePointerView instance
 * @param host NSString remote host name
 * @param port int remote host port
 * @param pixelFormat Preferred pixel format, wrapped into PixelFormatWrapper
 * @param jpegQuality JPEG quality level from 0 to 9, where 0 is the best image quality, 9 is the worst image quality, and -1 is lossless
 * @param encodingType One of four encoding types: Tight, Hextile, ZRLE, and Raw
 * @param retrieveConnectionId Callback which implements IRetrieveConnectionId protocol to request TCPDISPATCH connection ID
*/
- (id)initWithDesktopView:(id <DesktopViewDelegate>)desktopView
         MousePointerView:(MousePointerView *)mousePointerView
                     Host:(NSString *)host
                     Port:(int)port
              PixelFormat:(PixelFormatWrapper *)pixelFormat
              JpegQuality:(int)jpegQuality
                 Encoding:(int)encodingType
     RetrieveConnectionId:(__weak id <IRetrieveConnectionId>)retrieveConnectionId;

/**
 * @abstract ViewerCore initialiser with preferred encoding, jpeg quality lelel, and custom pixel format
 * @discussion The method initializes the object, attach it to the
 * specified data connection (e.g. an open TCP/IP socket), set callbacks for
 * events originating in the object, and start operation.
 * @param desktopView A pointer to DesktopView instance
 * @param mousePointerView A pointer to MousePointerView instance
 * @param host NSString remote host name
 * @param port int remote host port
 * @param pixelFormat Preferred pixel format, wrapped into PixelFormatWrapper
 * @param jpegQuality JPEG quality level from 0 to 9, where 0 is the best image quality, 9 is the worst image quality, and -1 is lossless
 * @param encodingType One of four encoding types: Tight, Hextile, ZRLE, and Raw
*/
- (id)initWithDesktopView:(id <DesktopViewDelegate>)desktopView
         MousePointerView:(MousePointerView *)mousePointerView
                     Host:(NSString *)host
                     Port:(int)port
              PixelFormat:(PixelFormatWrapper *)pixelFormat
              JpegQuality:(int)jpegQuality
                 Encoding:(int)encodingType;

/**
 * @abstract Request full refresh of the framebuffer, so that the whole screen will be
 * re-sent from the server
 * @discussion The refresh is not guaranteed to happen
 * immediately, it will be completed when allowed by the protocol.
 *
 * This function does nothing when called before entering the main phase of
 * the protocol (when the framebuffer does not exist yet).
*/
- (void)sendRefresh;

/**
 * @abstract Stop operation, detach from the data connection and terminate all active threads
 * @discussion This method will return control to the caller immediately, and threads
 * may run for some time after the function has finished.
 *
 * This function does nothing when called before entering the main phase of
 * the protocol (when the framebuffer does not exist yet).
*/
- (void)stop;

/**
 * @brief Send a pointer (mouse) event
 * @param point Event position in remote host coordinates
 * @param mask Button mask defines which mouse buttons are pressed, and which are released
*/
- (void)sendPointerEvent:(CGPoint)point buttonMask:(UInt8)mask;

/**
 * @brief Send a keyboard event
 * @param key Key code
 * @param downFlag Pressed or released key event
*/
- (void)sendKeyboardEvent:(UInt32)key DownFlag:(BOOL)downFlag;

/**
 * @brief Send two keyboard events: the first with down flag set to YES, the second with down flag set to NO
 * @param key Key code
*/
- (void)sendKey:(UInt32)key;

/**
 * @brief Set remote control to "View Only" mode or turn it off
 * @param viewOnly YESs for "View Only", NO for standard mode with ability to control remote desktop
*/
- (void)setViewOnly:(BOOL)viewOnly;

/**
 * @brief Check if the viewer core in "View Only" mode
 * @return YES if viewer core is in "View Only" mode or NO otherwise
*/
- (BOOL)viewOnly;

/**
 * @brief Check if the object was started
*/
- (BOOL)wasStarted;

/**
 * @brief Check if the main thread is still active
*/
- (BOOL)isActive;

/**
 * @brief Informational function which returns the remote desktop name (as received from the server)
 * @return Remote desktop name. If the desktop name is not available for any reason (e.g. before entering the protocol phase where it will be sent), an empty  string is returned.
*/
- (NSString *)remoteDesktopName;

/**
 * @abstract Set the specified pixel format
 * @discussion The viewer will request that pixel format from the server, as well as a full screen update. The pixel format is not guaranteed to be applied immediately. It will be applied when allowed by the protocol, and adapter's onNewFrameBuffer() will be called after that.
 * @param viewerPixelFormat Pixel format, wrapped into PixelFormatWrapper
*/
- (void)setPixelFormat:(PixelFormatWrapper *)viewerPixelFormat;

- (void)enableDispatching:(id <IRetrieveConnectionId>) retrieveConnectionId;

/**
 * @brief Pause/resume updating the frame buffer
 * @param isStopped YES to pause updates, NO to resume them
*/
- (void)stopUpdating:(BOOL)isStopped;

/**
 * @brief Specifies whether viewer force full update requests
 * @param forceUpdate YES to request full updates, NO to operate with incremental updates
*/
- (void)forceFullUpdateRequests:(BOOL)forceUpdate;

/**
 * @abstract Defers an update requests till timeout(in milliseconds) is expired
 * @discussion Timeout starts when a previous request is sent. But anyway the next update request will not send until the response on the previous request is recieved even if timeout is expired.
 * @param milliseconds Timeout between update requests in milliseconds
*/
- (void)deferUpdateRequests:(int)milliseconds;

/**
 * @abstract Request full refresh of the framebuffer, so that the whole screen will be re-sent from the server
 * @discussion The refresh is not guaranteed to happen immediately, it will be completed when allowed by the protocol.
 *
 * This function does nothing when called before entering the main phase of the protocol (when the framebuffer does not exist yet).
*/
- (void)refreshFrameBuffer;

/**
 * @brief Send cut text (clipboard) to the server
 * @param cutText NSString with text to cut
*/
- (void)sendCutTextEvent:(NSString *)cutText;

/**
 * @abstract Set the preferred encoding type
 * @discussion Note that the server is not guaranteed to use this encoding, this is only a recommendation for the server. By default, Tight encoding is the preferred one.
*/
- (void)setPreferredEncoding:(int)encodingType;

/**
 * @abstract Allow or disallow CopyRect encoding
 * @discussion Correctly designed server is guaranteed not to use CopyRect if disabled via this function (although passing the corresponding message to the server may take time). Normally, CopyRect should be enabled, and it's enabled by default.
*/
- (void)allowCopyRect:(BOOL)allow;

/**
 * @abstract Set JPEG image quality level for Tight encoding
 * @discussion Set JPEG image quality level for Tight encoding (in theory, it can apply to other encodings if they use JPEG, but currently, only Tight encoding supports that). Valid levels are in the range 0..9. Also, -1 can be used to disable JPEG and ensure lossless compression (thus, it's possible to say that -1 stands for best image quality).
 * @param newJpegQualityLevel JPEG quality in range (-1..9)
*/
- (void)setJpegQualityLevel:(int)newJpegQualityLevel;

/**
 * @abstract Set the compression level for Tight encoging
 * @discussion Set the compression level for Tight encoging (in theory, it can apply to other encodings as well, and in fact old experimental encoders such as Zlib supported that, but here we do not support those encoders any more). Valid levels are in the range 0..9. Also, -1 can be used to let the server choose actual compression level.
 * @param newCompressionLevel Compression level in range (-1..9)
*/
- (void)setCompressionLevel:(int)newCompressionLevel;

/**
 * @abstract Enable or disable cursor shape updates (enabled by default)
 * @discussion If enabled, then server sends information about the cursor shape. If disabled, cursor is shown as a part of usual frame buffer updates.
 * @param enabled YES to enable, NO to disable
*/
- (void)enableCursorShapeUpdates:(BOOL)enabled;

/**
 * @abstract Ignore or show cursor shape updates (shown by default)
 * @discussion If cursor shape updates are enabled but ignored, remote cursor will not be shown. This option probably should not be changed unless something goes really wrong.
 * @param ignored YES to ignore, NO to show
*/
- (void)ignoreCursorShapeUpdates:(BOOL)ignored;

/**
 * @abstract This mode is used for notificating when processing of full update is completed
 * @param state YES to notify when update is done, NO otherwise
*/
- (void)enableNotifyOnUpdateEnd:(BOOL)state;

/**
 * @abstract Enabling external cursor drawing
 * @param enable YES to enable, NO to disable
*/
- (void)enableExternalCursor:(BOOL)enable;

@end
