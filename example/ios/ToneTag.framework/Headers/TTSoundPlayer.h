//
//  TTSoundPlayer.h
//  ToneTagSDK
//
//  Created by Praveen on 05/03/19.
//  Copyright © 2019 ToneTag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef enum {
    channel_A = 0,
    channel_B = 1,
    channel_C = 2
}channel_type;  //for multi ultrasonic channels A/B/C

typedef enum {
    player_10ByteUS = 1,
    player_30ByteUS = 2,
    player_28ByteMultiUS = 3
}player_type;  //for player in tone repeat mode

@protocol TTOnToneTagPlayerDelegate <NSObject>

@optional
/**
 @Description After playing tone, status will be returned
 @param status 1 tone played successful, 0 tone was not played.
 */

-(void)TTOnPlaybackFinished:(BOOL)status withString:(NSString *)string;

/**
 @Description    If any error occured inside SDK then this delegate will pass the error to app
 @param error description in NSError format, contains description in plain text. No decryption required for this.
 */
-(void)TTOnPlayerError:(NSError *)error;

@end

@interface TTSoundPlayer:NSObject <AVAudioPlayerDelegate>

@property (nonatomic, weak) id <TTOnToneTagPlayerDelegate> TTPlayerDelegate;

/**
     @Description  Initialize and get the instance of recorder. Refer to sample app for referece.
     @param subKey  pass subscription key, provided by ToneTag.
     @return id instance of ToneTagManager
 */

-(id)initPlayerWithManager:(AudioStreamBasicDescription *) format session:(AVAudioSession *) audioSession key:(NSString *)subKey;

/**
 *Note*
 Get instance for player with initPlayerWithManager before using this method.
 
 @Description  Use this method to start playing user defined tone.
 @param string   user defined input pass 30 max digits or 15-18 alphanumeric.
 @param channel int 0/1/2 for channel A/B/C
 */
-(void)TTPlay30USString:(NSString *)string forChannel:(channel_type)channel;

/**
 @Description    Manually set device volume
 @param volume  valid range is between 0 to 1 float supported. Anything above 1 will have undefined behavior.
 */
- (void)setSystemVolume:(CGFloat)volume;

/**
 @Description Stop playing current tone.
 */
-(void)TTStopPlayer;
    
@end
