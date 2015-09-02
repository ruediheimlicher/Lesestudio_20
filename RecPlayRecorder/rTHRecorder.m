//
//  rTHRecorder.m
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 17.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import "rTHRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <AppKit/AppKit.h>
#import "THMemo.h"
//#import "THLevelPair.h"
//#import "THMeterTable.h"

@interface rTHRecorder() <AVAudioRecorderDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) THRecordingStopCompletionHandler completionHandler;
//@property (strong, nonatomic) THMeterTable *meterTable;

@end

@implementation rTHRecorder
- (id)init {
   self = [super init];
   if (self) {
      
      
      NSString *tmpDir = NSTemporaryDirectory();
      //NSString *filePath = [tmpDir stringByAppendingPathComponent:@"memo.caf"];
     NSString *filePath = [NSHomeDirectory()    stringByAppendingPathComponent:@"memo.caf"];
      
      tempfileURL = [NSURL fileURLWithPath:filePath];
      session = [[AVCaptureSession alloc] init];
      // kAudioFormatLinearPCM
      // kAudioFormatAppleLossless
      // kAudioFormatAppleIMA4
      // kAudioFormatMPEG4AAC // 'aac'
      NSDictionary *settings = @{
                                 AVFormatIDKey : @(kAudioFormatAppleIMA4),
                                 AVSampleRateKey : @44100.0f,
                                 AVNumberOfChannelsKey : @2,
                                 AVEncoderBitDepthHintKey : @16,
                                 AVEncoderAudioQualityKey : @(AVAudioQualityMedium)
                                 };
      
      NSError *error;
      self.recorder = [[AVAudioRecorder alloc] initWithURL:tempfileURL settings:settings error:&error];
      if (self.recorder)
      {
         self.recorder.delegate = self;
         self.recorder.meteringEnabled = YES;
         [self.recorder prepareToRecord];
      } else
      {
         NSLog(@"Error: %@", [error localizedDescription]);
      }
      
   //   _meterTable = [[THMeterTable alloc] init];
   }
   
   return self;
}



- (BOOL)record
{
   return [self.recorder record];
}

- (void)pause {
   [self.recorder pause];
}

- (void)stopWithCompletionHandler:(THRecordingStopCompletionHandler)handler
{
   NSLog(@"stopWithCompletionHandler");
   self.completionHandler = handler;
   [self.recorder stop];
   
   
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)success
{
   NSLog(@"audioRecorderDidFinishRecording");
   if (self.completionHandler)
   {
      NSLog(@"completionHandler");
      self.completionHandler(success);
      NSLog(@"completionHandler success: %d",success);
   }
}
- (BOOL)saveRecordingWithName:(NSString *)name completionHandler:(THRecordingSaveCompletionHandler)handler
{
   [self.recorder stop];
   NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
   //NSString *filename = [NSString stringWithFormat:@"%@-%f.m4a", name, timestamp];
   //NSString *filename = [NSString stringWithFormat:@"%@.m4a",name];
   NSString *filename = [NSString stringWithFormat:@"%@.ima4",name];
   
   NSString *docsDir = [self documentsDirectory];
   NSString *destPath = [[docsDir stringByAppendingPathComponent:@"Lesebox" ]stringByAppendingPathComponent:filename];
   
   NSURL *srcURL = tempfileURL;
   NSURL *destURL = [NSURL fileURLWithPath:destPath];
   NSLog(@"filename: %@ srcURL: %@ destURL: %@",filename,srcURL,destURL);
   NSError *error;
   BOOL success = [[NSFileManager defaultManager] copyItemAtURL:srcURL toURL:destURL error:&error];
   if (success)
   {
      NSError* err;
      BOOL killsuccess =[[NSFileManager defaultManager] removeItemAtURL:tempfileURL error:&err];
      bool killrec = [self.recorder deleteRecording];
      handler(YES, [THMemo memoWithTitle:name url:destURL]);
      [self.recorder prepareToRecord];
      NSLog(@"killurl: %@ killsuccess: %d \nerror: %@",self.recorder.url,killsuccess ,err );
   }
   else
   {
      handler(NO, error);
   }
   
   [session stopRunning];
   self.recorder = nil;

   return success;
}

- (NSString *)documentsDirectory {
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   return [paths objectAtIndex:0];
}
- (BOOL)fileManager:(NSFileManager *)fileManager
shouldCopyItemAtURL:(NSURL *)srcURL
              toURL:(NSURL *)dstURL
{
   NSLog(@"shouldCopyItemAtURL");
   return YES;
}
@end
