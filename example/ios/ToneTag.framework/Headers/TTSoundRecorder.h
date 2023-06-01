//
//  TTSoundRecorder.h
//  ToneTagSDK
//
//  Created by Praveen on 05/03/19.
//  Copyright © 2019 ToneTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToneTagManager.h"

@protocol TTOnToneTagRecorderDelegate <NSObject>
@required
#pragma mark - Protocol declaration
/**
 @Description When tone is received and data is extracted, data will be passed to app using this.
 @param string   received data string in plain text.
 */

- (void)TTOnDataFound:(NSString *)string;

@optional

/**
 @Description Shows whether recorder is started or not, if not then refer to TTOnError
 @param status   1= started, 0 = failed
 */
- (void)TTRecordingStatus:(BOOL)status;

/**
 @Description    If any error occured inside SDK then this delegate will pass the error to app
 @param error description in NSError format, contains description in plain text. No decryption required for this.
 */
-(void)TTOnError:(NSError *)error;

/**
 @Description    (Optional) To inform if recorder has stopped correctly.
 @param code    if code = 0 then normal stop else refer TTOnError response
 */
-(void)TTOnRecorderStops:(int)code;
@end

@interface TTSoundRecorder:NSObject

@property (nonatomic,weak) id <TTOnToneTagRecorderDelegate> TTRecorderDelegate;

-(id)initRecorderWithManager:(AudioStreamBasicDescription *)format session:(AVAudioSession *)audioSession key:(NSString *)subKey;

/**
 @Description    Method to start Recording
 */
-(void)TTStartRecording;

/**
 @Description    Method to stop recorder
 */
-(void)TTStopRecording;

/**
 @Description To check if recorder is on or not.
 @return BOOL Yes=recorder on , No=recorder off
 */
-(BOOL)isRecorderOn;
@end
