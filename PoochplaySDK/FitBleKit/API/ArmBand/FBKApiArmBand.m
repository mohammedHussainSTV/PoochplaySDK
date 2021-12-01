/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKApiArmBand.m
 * 内容摘要：臂带API
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import "FBKApiArmBand.h"

@implementation FBKApiArmBand


#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init
{
    self = [super init];
    
    self.deviceType = BleDeviceArmBand;
    [self.managerController setManagerDeviceType:BleDeviceArmBand];
    
    return self;
}


/********************************************************************************
 * 方法名称：setArmBandTime
 * 功能描述：设置时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setArmBandTime
{
    [self.managerController receiveApiCmd:ArmBandCmdSetTime withObject:nil];
}


/********************************************************************************
 * 方法名称：setHeartRateMax
 * 功能描述：设置心率最大值
 * 输入参数：maxRate-心率最大值
 * 返回数据：
 ********************************************************************************/
- (void)setHeartRateMax:(NSString *)maxRate
{
    [self.managerController receiveApiCmd:ArmBandCmdSetMaxHR withObject:maxRate];
}


/********************************************************************************
* 方法名称：setHeartRateColor
* 功能描述：设置心率区间颜色
* 输入参数：hrColor-心率区间颜色
* 返回数据：
********************************************************************************/
- (void)setHeartRateColor:(FBKDeviceHRColor *)hrColor {
    [self.managerController receiveApiCmd:ArmBandCmdSetHrColor withObject:hrColor];
}


/********************************************************************************
* 方法名称：enterHRVMode
* 功能描述：进入HRV模式
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)enterHRVMode:(BOOL)status {
    NSString *statusString = @"0";
    if (status) {
        statusString = @"1";
    }
    [self.managerController receiveApiCmd:ArmBandCmdEnterHRVMode withObject:statusString];
}


/********************************************************************************
 * 方法名称：getArmBandTotalHistory
 * 功能描述：获取所有历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getArmBandTotalHistory
{
    [self.managerController receiveApiCmd:ArmBandCmdGetTotalRecord withObject:nil];
}


/*-***********************************************************************************
* Method: setShock
* Description: set Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setShock:(int)shockNumber {
    [self.managerController receiveApiCmd:ArmBandCmdSetShock withObject:[NSString stringWithFormat:@"%i",shockNumber]];
}


/*-***********************************************************************************
* Method: getShock
* Description: get Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (void)getShock {
    [self.managerController receiveApiCmd:ArmBandCmdGetShock withObject:nil];
}


/*-***********************************************************************************
* Method: closeShock
* Description: close Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (void)closeShock {
    [self.managerController receiveApiCmd:ArmBandCmdCloseShock withObject:nil];
}


/*-***********************************************************************************
* Method: setMaxInterval
* Description: set Max Interval
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setMaxInterval:(int)maxNumber {
    [self.managerController receiveApiCmd:ArmBandCmdMaxInterval withObject:[NSString stringWithFormat:@"%i",maxNumber]];
}


/*-***********************************************************************************
* Method: setLightSwitch
* Description: set Light Switch
* Parameter:
* Return Data:
*************************************************************************************/
- (void)setLightSwitch:(BOOL)isOpen {
    NSString *statusString = @"0";
    if (isOpen) {
        statusString = @"1";
    }
    [self.managerController receiveApiCmd:ArmBandCmdLightSwitch withObject:statusString];
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber
{
    FBKAnalyticalNumber resultType = (FBKAnalyticalNumber)resultNumber;
    
    switch (resultType)
    {
        case FBKAnalyticalRealTimeHR:
        {
            [self.delegate armBandRealTimeHeartRate:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalDeviceVersion:
        {
            [self.delegate armBandVersion:(NSString *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRTStepFrequency:
        {
            [self.delegate armBandStepFrequency:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalBigData:
        {
            [self.delegate armBandDetailData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKArmBandResultSetShock: {
            [self.delegate setShockStatus:YES andDevice:self];
            break;
        }
        
        case FBKArmBandResultGetShock: {
            [self.delegate getShockStatus:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKArmBandResultCloseShock: {
            [self.delegate closeShockStatus:YES andDevice:self];
            break;
        }
            
        case FBKArmBandResultMaxInterval: {
            [self.delegate setMaxIntervalStatus:YES andDevice:self];
            break;
        }
            
        case FBKArmBandResultLightSwitch: {
            [self.delegate setLightSwitchStatus:YES andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


@end
