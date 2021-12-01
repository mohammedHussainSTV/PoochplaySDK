/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKProtocolBoxing.m
 * 内容摘要：拳击器蓝牙协议
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2019年03月26日
 ********************************************************************************/

#import "FBKProtocolBoxing.h"
#import "FBKDateFormat.h"

@implementation FBKProtocolBoxing
{
    FBKProNTrackerCmd *m_boxingCmd;
    FBKProNTrackerAnalytical *m_boxingAnalytical;
}


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
    
    m_boxingCmd = [[FBKProNTrackerCmd alloc] init];
    m_boxingCmd.delegate = self;
    
    m_boxingAnalytical = [[FBKProNTrackerAnalytical alloc] init];
    m_boxingAnalytical.delegate = self;
    m_boxingAnalytical.analyticalDeviceType = BleDeviceBoxing;
    
    return self;
}


/********************************************************************************
* 方法名称：dealloc
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)dealloc
{
    m_boxingCmd.delegate = nil;
    m_boxingCmd = nil;
    
    m_boxingAnalytical.delegate = nil;
    m_boxingAnalytical = nil;
}


#pragma mark - **************************** 接收数据  *****************************
/********************************************************************************
 * 方法名称：receiveBleCmd
 * 功能描述：接收拼接命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleCmd:(int)cmdId withObject:(id)object
{
    BoxingCmdNumber boxingCmd = (BoxingCmdNumber)cmdId;
    
    switch (boxingCmd)
    {
        case BoxingCmdSetTime:
            [m_boxingCmd setUTC];
            break;
            
        case BoxingCmdGetTotalRecord:
            [m_boxingCmd getTotalRecordCmd];
            break;
            
        case BoxingCmdAckCmd:
            [m_boxingCmd getAckCmd:(NSString *)object];
            break;
            
        case BoxingCmdSendCmdSuseed:
            [m_boxingCmd sendCmdSuseed:(NSString *)object];
            break;
            
        default:
            break;
    }
}


/********************************************************************************
 * 方法名称：receiveBleData
 * 功能描述：接收蓝牙原数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleData:(NSString *)hexString  withUuid:(NSString *)uuid
{
    NSString *upUuid = [uuid uppercaseString];
    
    if ([upUuid isEqualToString:FBKNEWBANDNOTIFYFD19])
    {
        [m_boxingAnalytical receiveBlueData:hexString];
    }
}


/********************************************************************************
 * 方法名称：bleErrorReconnect
 * 功能描述：蓝牙异常重连
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleErrorReconnect
{
    [m_boxingAnalytical receiveBlueDataError];
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：sendBleCmdData
 * 功能描述：传输写入的数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)sendBleCmdData:(NSData *)byteData;
{
    [self.delegate writeBleByte:byteData];
}


/********************************************************************************
 * 方法名称：analyticalSucceed
 * 功能描述：解析数据返回
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalSucceed:(id)resultData withResultNumber:(FBKAnalyticalNumber)resultNumber
{
    switch (resultNumber)
    {
        case FBKAnalyticalDeviceVersion:
        {
            int softVersion = [[NSString stringWithFormat:@"%@",(NSString *)resultData] intValue];
            if (softVersion == 1 || softVersion == 2)
            {
                softVersion = 1;
            }
            
            m_boxingCmd.m_softVersion = softVersion;
            
            [m_boxingCmd setUTC];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
            
        case FBKAnalyticalSendSuseed:
            [m_boxingCmd sendCmdSuseed:(NSString *)resultData];
            break;
            
        case FBKAnalyticalAck:
            [m_boxingCmd getAckCmd:(NSString *)resultData];
            break;
            
        case FBKAnalyticalBigData:
            [self.delegate synchronizationStatus:DeviceBleSyncOver];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
            
        case FBKAnalyticalSyncing:
            [self.delegate synchronizationStatus:DeviceBleSynchronization];
            break;
            
        default:
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
    }
}

@end
