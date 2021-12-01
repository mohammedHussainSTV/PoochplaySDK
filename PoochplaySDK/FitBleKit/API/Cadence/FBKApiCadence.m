/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKApiCadence.m
 * 内容摘要：踏频速度API
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiCadence.h"

@implementation FBKApiCadence

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
    
    self.deviceType = BleDeviceCadence;
    [self.managerController setManagerDeviceType:BleDeviceCadence];
    
    return self;
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
    [self.delegate getCadenceData:(NSDictionary *)resultData andDevice:self];
}


@end
