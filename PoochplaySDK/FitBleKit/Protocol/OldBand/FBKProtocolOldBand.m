/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKProtocolOldBand.m
 * 内容摘要：老手环蓝牙协议
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKProtocolOldBand.h"
#import "FBKDeviceBaseInfo.h"
#import "FBKDateFormat.h"

@implementation FBKProtocolOldBand
{
    FBKProOldBandCmd *m_oldBandCmd;
    FBKProOldBandAnalytical *m_oldBandAnalytical;
    FBKDeviceUserInfo  *m_userInfo;
    FBKDeviceSleepInfo *m_sleepInfo;
    NSString *m_bikeWhell;
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
    
    m_oldBandCmd = [[FBKProOldBandCmd alloc] init];
    m_oldBandCmd.delegate = self;
    
    m_oldBandAnalytical = [[FBKProOldBandAnalytical alloc] init];
    m_oldBandAnalytical.delegate = self;
    
    m_userInfo  = [[FBKDeviceUserInfo alloc] init];
    m_sleepInfo = [[FBKDeviceSleepInfo alloc] init];
    m_bikeWhell = [[NSString alloc] init];
    
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
    m_oldBandCmd.delegate = nil;
    m_oldBandCmd = nil;
    
    m_oldBandAnalytical.delegate = nil;
    m_oldBandAnalytical = nil;
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
    OTrackerCmdNumber trackerCmd = (OTrackerCmdNumber)cmdId;
    
    switch (trackerCmd)
    {
        case OTrackerCmdSetTime:
            break;
            
        case OTrackerCmdSetUserInfo:
            m_userInfo = (FBKDeviceUserInfo *)object;
            break;
            
        case OTrackerCmdSetSleepInfo:
            m_sleepInfo = (FBKDeviceSleepInfo *)object;
            break;
            
        case OTrackerCmdSetBikeInfo:
            m_bikeWhell = (NSString *)object;
            break;
            
        case OTrackerCmdAckCmd:
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
    
    if ([upUuid isEqualToString:FBKOLDBANDNOTIFYFC20])
    {
        [self.delegate synchronizationStatus:DeviceBleSynchronization];
        [m_oldBandAnalytical receiveBlueData:hexString];
    }
    else if ([upUuid isEqualToString:FBKOLDBANDNOTIFYFC22])
    {
        NSDictionary *dataDic = [self getRealTimeData:hexString isHeart:NO];
        [self.delegate analyticalBleData:dataDic withResultNumber:FBKAnalyticalOldBandRTSteps];
    }
    else if ([upUuid isEqualToString:FBKOLDBANDNOTIFYFD17])
    {
        NSString *findMark = [[hexString substringFromIndex:5] substringToIndex:1];
        [self.delegate analyticalBleData:findMark withResultNumber:FBKAnalyticalOldBandFindPhone];
    }
    else if ([upUuid isEqualToString:FBKHEARTRATENOTIFY2A37])
    {
        NSDictionary *dataDic = [self getRealTimeData:hexString isHeart:YES];
        [self.delegate analyticalBleData:dataDic withResultNumber:FBKAnalyticalOldBandRTHR];
    }
    
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
- (void)analyticalSucceed:(id)resultData withResultNumber:(int)resultNumber
{
    switch (resultNumber)
    {
        case 1:
            [m_oldBandCmd setUserInfo:(NSString *)resultData andNowInfo:m_userInfo];
            break;
            
        case 2:
            [m_oldBandCmd getTimeHand:(NSString *)resultData];
            break;
            
        case 6:
            [self.delegate synchronizationStatus:DeviceBleSyncOver];
            [self.delegate analyticalBleData:resultData withResultNumber:FBKAnalyticalOldBandBigData];
            break;
           
        case 7:
            [m_oldBandCmd setPramInfo:(NSString *)resultData andNowInfo:m_sleepInfo andBikeInfo:m_bikeWhell];
            break;
            
        default:
            [m_oldBandCmd ackCmd:(NSString *)resultData];
            break;
    }
}


/********************************************************************************
 * 方法名称：getRateData
 * 功能描述：解析心率数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)getRealTimeData:(NSString *)myString isHeart:(BOOL)status
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    
    int j=0;
    Byte bytes[20];
    
    for(int i=0;i<[myString length];i++)
    {
        int int_ch; //// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [myString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16; //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [myString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch; ///将转化后的数放入Byte数组里
        j++;
    }
    
    if (status)
    {
        int c0 = bytes[0]&0xFF;
        NSString *dataLength = [NSString stringWithFormat:@"%d",c0];
        [resultDic setObject:dataLength forKey:@"dataLength"];
        
        int c1 = bytes[1]&0xFF;
        NSString *nowXinLv = [NSString stringWithFormat:@"%d",c1];
        [resultDic setObject:nowXinLv forKey:@"heartRate"];
        [resultDic setObject:@"0" forKey:@"mark"];
        
        NSMutableArray *intervalArray = [[NSMutableArray alloc] init];
        int intervalLength = (int)myString.length/2;
        if (intervalLength > 2 && intervalLength%2 == 0) {
            for (int i = 2; i < intervalLength; i++) {
                if (i%2 == 0) {
                    int hiByte = bytes[i]&0xFF;
                    int lowByte = bytes[i+1]&0xFF;
                    NSString *interval = [NSString stringWithFormat:@"%d",(hiByte<<8) + lowByte];
                    [intervalArray addObject:interval];
                }
            }
        }
        
        if (intervalArray.count > 0) {
            [resultDic setObject:intervalArray forKey:@"interval"];
        }
        
        NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
        [resultDic setObject:nowTime forKey:@"createTime"];
        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
    }
    else
    {
        NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
        [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *handTime = [NSDate date];
        NSString *locTime = [myFormatter stringFromDate:handTime];
        [resultDic setObject:locTime forKey:@"locTime"];
        [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:locTime]] forKey:@"timestamps"];
        
        int c2 = bytes[2]&0xFF;
        int c3 = bytes[3]&0xFF;
        int c4 = bytes[4]&0xFF;
        NSString *stepNum = [NSString stringWithFormat:@"%d",c4+(c3<<8)+(c2<<16)];
        [resultDic setObject:stepNum forKey:@"stepNum"];
        
        int c5 = bytes[5]&0xFF;
        int c6 = bytes[6]&0xFF;
        int c7 = bytes[7]&0xFF;
        NSString *stepDistance = [NSString stringWithFormat:@"%.1f",(float)(c7+(c6<<8)+(c5<<16))/100000];
        [resultDic setObject:stepDistance forKey:@"stepDistance"];
        
        int c8 = bytes[8]&0xFF;
        int c9 = bytes[9]&0xFF;
        int c10 = bytes[10]&0xFF;
        NSString *stepKcal = [NSString stringWithFormat:@"%.1f",(float)(c10+(c9<<8)+(c8<<16))/10];
        [resultDic setObject:stepKcal forKey:@"stepKcal"];
    }

    return resultDic;
}


@end

