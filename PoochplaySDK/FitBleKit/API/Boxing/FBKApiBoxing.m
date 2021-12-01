/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKApiArmBand.m
 * 内容摘要：臂带API
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import "FBKApiBoxing.h"

@implementation FBKApiBoxing

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
    
    self.deviceType = BleDeviceBoxing;
    [self.managerController setManagerDeviceType:BleDeviceBoxing];
    
    return self;
}


/********************************************************************************
 * 方法名称：setBoxingTime
 * 功能描述：设置时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setBoxingTime
{
    [self.managerController receiveApiCmd:BoxingCmdSetTime withObject:nil];
}


/********************************************************************************
 * 方法名称：getBoxingTotalHistory
 * 功能描述：获取所有历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getBoxingTotalHistory
{
    [self.managerController receiveApiCmd:BoxingCmdGetTotalRecord withObject:nil];
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
        case FBKAnalyticalDeviceVersion:
        {
            [self.delegate armBandVersion:(NSString *)resultData andDevice:self];
            break;
        }

        case FBKAnalyticalRTFistInfo:
        {
            [self.delegate realtimeFistInfo:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalBigData:
        {
            [self.delegate armBoxingDetailData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}

@end
