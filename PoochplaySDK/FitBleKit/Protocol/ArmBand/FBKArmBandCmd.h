/*-***********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: FBKArmBandCmd.h
* Function : Arm Band Cmd
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.05.07
*************************************************************************************/
#import <Foundation/Foundation.h>

@interface FBKArmBandCmd : NSObject

- (NSData *)setShock:(int)shockNumber;

- (NSData *)getShock;

- (NSData *)closeShock;

- (NSData *)setMaxInterval:(int)maxNumber;

- (NSData *)setLightSwitch:(BOOL)isOpen;

@end
