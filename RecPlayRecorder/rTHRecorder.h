//
//  rTHRecorder.h
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 17.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@protocol THRecorderControllerDelegate <NSObject>
- (void)interruptionBegan;
@end

typedef void(^THRecordingStopCompletionHandler)(BOOL);
typedef void(^THRecordingSaveCompletionHandler)(BOOL, id);

@class THMemo;
@class THLevelPair;

@interface rTHRecorder : NSObject
{
   NSURL *  tempfileURL;
   AVCaptureSession			*session;
}

@property (nonatomic, readonly) NSString *formattedCurrentTime;
@property (weak, nonatomic) id <THRecorderControllerDelegate> delegate;




// Recorder methods
- (BOOL)record;

- (void)pause;

- (void)stopWithCompletionHandler:(THRecordingStopCompletionHandler)handler;

- (void)saveRecordingWithName:(NSString *)name
            completionHandler:(THRecordingSaveCompletionHandler)handler;

- (THLevelPair *)levels;

// Player methods
- (BOOL)playbackMemo:(THMemo *)memo;

@end
