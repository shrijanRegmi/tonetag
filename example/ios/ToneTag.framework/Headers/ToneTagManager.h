//
//  ToneTagManager.h
//  ToneTagSDK
//
//  Created by Praveen on 05/03/19.
//  Copyright © 2019 ToneTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol TTToneTagManagerDelegate <NSObject>
/**
 @Description If any error occures during creating instance or subscription key.
 @param error NSError contains code and description.
 */

-(void)TTToneTagManagerError:(NSError *)error;

@end


@interface ToneTagManager : NSObject

@property (nonatomic, weak) id <TTToneTagManagerDelegate> ToneTagManagerDelegate;


#pragma mark - Instances
 
/**
 @Description   mandatory & required for getting Sound Recording functional. Please add microphone usage permission in your app.
 @param subKey Pass subscription key provided by ToneTag
 @return id instance of ToneTag sound recorder.
 */
-(id)getSoundRecorderInstanceWithSubscriptionKey:(NSString *)subKey;

/**
 @Description   mandatory & required for getting Sound Player functional.
 @param subKey Pass subscription key provided by ToneTag
 @return id instance of ToneTag sound player.
 */
-(id)getSoundPlayerInstanceWithSubscriptionKey:(NSString *)subKey;

    
#pragma mark - Subscription Keys
/**
 @Description   To find if subscription key is valid. Optionally used for subscription key validation.
 @param subKey  pass subscription key, provided by ToneTag.
 @return    BOOL 'YES' = Subscription key has expired.
                    'NO' = Subscription key is still valid.
 */
+(BOOL)isKeyExpired:(NSString *)subKey;

/**
 @Description   To find when is the expirey date of the subscription key.
 @param subKey  pass subscription key, provided by ToneTag.
 @return    NSDate  returns NSDate format.
            *Note*
            returns 'Nil' - if other than ToneTag provided subscription key is passed.
 */
+(NSDate *)getKeyExpiryDate:(NSString *)subKey;

/**
 @Description Find SDK build info
 @return Info string
 */
+(NSString *) getBuildInfo;

@end
