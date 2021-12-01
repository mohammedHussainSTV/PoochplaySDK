/*-***********************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: FBKArmBandCmd.m
* Function : Arm Band Cmd
* Editor   : Peng Yu
* Version  : 1.0.1
* Date     : 2020.05.07
*************************************************************************************/

#import "FBKArmBandCmd.h"
#import "FBKSpliceBle.h"

@implementation FBKArmBandCmd


/*-***********************************************************************************
* Method: setShock
* Description: set Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)setShock:(int)shockNumber {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",5] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",9] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",shockNumber] forKey:@"byte3"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte4"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: getShock
* Description: get Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)getShock {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",4] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",10] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte3"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: closeShock
* Description: close Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)closeShock {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",4] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",11] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte3"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: setMaxInterval
* Description: set Max Interval
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)setMaxInterval:(int)maxNumber {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",5] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",12] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",maxNumber] forKey:@"byte3"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte4"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: setLightSwitch
* Description: set Light Switch
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)setLightSwitch:(BOOL)isOpen {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",5] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",13] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte3"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte4"];
    if (isOpen) {
        [cmdMap setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte3"];
    }
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


@end
