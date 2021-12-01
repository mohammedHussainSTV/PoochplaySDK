/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKApiHeartRate.h
 * 内容摘要：心率设备API
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiHeartRate.h"

@implementation FBKApiHeartRate

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
    
    self.deviceType = BleDeviceHeartRate;
    [self.managerController setManagerDeviceType:BleDeviceHeartRate];
    
    return self;
}


/********************************************************************************
 * 方法名称：getRecordHrData
 * 功能描述：获取历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getRecordHrData
{
    [self editCharacteristicNotifyApi:YES withCharacteristic:FBKOLDBANDNOTIFYFC20];
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
    FBKAnalyticalOldBand resultType = (FBKAnalyticalOldBand)resultNumber;
    
    switch (resultType)
    {
        case FBKAnalyticalOldBandRTHR:
        {
            [self.delegate getRealTimeHeartRate:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalOldBandBigData:
        {
            [self editCharacteristicNotifyApi:NO withCharacteristic:FBKOLDBANDNOTIFYFC20];
            NSDictionary *dataDic = (NSDictionary *)resultData;
            [self.delegate getHeartRateRecord:dataDic andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


@end
