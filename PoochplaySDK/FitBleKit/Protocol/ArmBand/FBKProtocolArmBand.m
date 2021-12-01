/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKProtocolArmBand.m
 * 内容摘要：臂带蓝牙协议
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import "FBKProtocolArmBand.h"
#import "FBKDateFormat.h"
#import "FBKArmBandCmd.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolArmBand
{
    FBKArmBandCmd *m_armBandSelfCmd;
    FBKProNTrackerCmd *m_ArmBandCmd;
    FBKProNTrackerAnalytical *m_ArmBandAnalytical;
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
    
    m_armBandSelfCmd = [[FBKArmBandCmd alloc] init];
    
    m_ArmBandCmd = [[FBKProNTrackerCmd alloc] init];
    m_ArmBandCmd.delegate = self;
    
    m_ArmBandAnalytical = [[FBKProNTrackerAnalytical alloc] init];
    m_ArmBandAnalytical.delegate = self;
    m_ArmBandAnalytical.analyticalDeviceType = BleDeviceArmBand;
    
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
    m_ArmBandCmd.delegate = nil;
    m_ArmBandCmd = nil;
    
    m_ArmBandAnalytical.delegate = nil;
    m_ArmBandAnalytical = nil;
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
    ArmBandCmdNumber ArmBandCmd = (ArmBandCmdNumber)cmdId;
    
    switch (ArmBandCmd)
    {
        case ArmBandCmdSetTime:
            [m_ArmBandCmd setUTC];
            break;
            
        case ArmBandCmdOpenRealTImeSteps:
            [m_ArmBandCmd openRealTimeStepsCmd:(NSString *)object];
            break;
            
        case ArmBandCmdGetDeviceSupport:
            [m_ArmBandCmd getDeviceSupportCmd];
            break;
            
        case ArmBandCmdSetMaxHR:
            [m_ArmBandCmd setHeartRateMaxCmd:(NSString *)object];
            break;
            
        case ArmBandCmdEnterHRVMode:
            [m_ArmBandCmd enterHRVModeCmd:(NSString *)object];
            break;
            
        case ArmBandCmdSetHrColor:
            [m_ArmBandCmd setHeartRateColor:(FBKDeviceHRColor *)object];
            break;
            
        case ArmBandCmdGetTotalRecord:
            [m_ArmBandCmd getTotalRecordCmd];
            break;
            
        case ArmBandCmdGetStepRecord:
            [m_ArmBandCmd getStepRecordCmd];
            break;
            
        case ArmBandCmdGetHRRecord:
            [m_ArmBandCmd getHeartRateRecordCmd];
            break;
            
        case ArmBandCmdAckCmd:
            [m_ArmBandCmd getAckCmd:(NSString *)object];
            break;
            
        case ArmBandCmdSendCmdSuseed:
            [m_ArmBandCmd sendCmdSuseed:(NSString *)object];
            break;
            
        case ArmBandCmdSetShock:{
            NSString *value = (NSString *)object;
            int valueNumber = [value intValue];
            NSData *cmdData = [m_armBandSelfCmd setShock:valueNumber];
            [self.delegate writeSpliceByte:cmdData withUuid:FBKARMBANDWRITEFD0A];
            break;
        }
            
        case ArmBandCmdGetShock:{
            NSData *cmdData = [m_armBandSelfCmd getShock];
            [self.delegate writeSpliceByte:cmdData withUuid:FBKARMBANDWRITEFD0A];
            break;
        }
            
        case ArmBandCmdCloseShock:{
            NSData *cmdData = [m_armBandSelfCmd closeShock];
            [self.delegate writeSpliceByte:cmdData withUuid:FBKARMBANDWRITEFD0A];
            break;
        }
            
        case ArmBandCmdMaxInterval:{
            NSString *value = (NSString *)object;
            int valueNumber = [value intValue];
            NSData *cmdData = [m_armBandSelfCmd setMaxInterval:valueNumber];
            [self.delegate writeSpliceByte:cmdData withUuid:FBKARMBANDWRITEFD0A];
            break;
        }
            
        case ArmBandCmdLightSwitch:{
            NSString *value = (NSString *)object;
            int valueNumber = [value intValue];
            BOOL isOpen = NO;
            if (valueNumber) {
                isOpen = YES;
            }
            NSData *cmdData = [m_armBandSelfCmd setLightSwitch:isOpen];
            [self.delegate writeSpliceByte:cmdData withUuid:FBKARMBANDWRITEFD0A];
            break;
        }
            
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
    
    if ([upUuid isEqualToString:FBKNEWBANDNOTIFYFD19]) {
        [m_ArmBandAnalytical receiveBlueData:hexString];
    }
    else if ([upUuid isEqualToString:FBKHEARTRATENOTIFY2A37]) {
        NSDictionary *dataDic = [self getRealTimeData:hexString isHeart:YES];
        [self.delegate analyticalBleData:dataDic withResultNumber:FBKAnalyticalRealTimeHR];
    }
    else if ([upUuid isEqualToString:FBKARMBANDNOTIFYFD09]) {
        NSData *byteData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:hexString]];
        [self spliceData:byteData];
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
    [m_ArmBandAnalytical receiveBlueDataError];
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

            m_ArmBandCmd.m_softVersion = softVersion;
            
            [m_ArmBandCmd setUTC];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
            
        case FBKAnalyticalSendSuseed:
            [m_ArmBandCmd sendCmdSuseed:(NSString *)resultData];
            break;
            
        case FBKAnalyticalAck:
            [m_ArmBandCmd getAckCmd:(NSString *)resultData];
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


/*-******************************************************************************
* 方法名称：getRateData
* 功能描述：解析心率数据
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)spliceData:(NSData *)resultData {
    const uint8_t *bytes = [resultData bytes];
    int firstNum = bytes[0]&0xFF;
    if (firstNum == 210) {
        int keyMark = bytes[2]&0xFF;
        if (keyMark == 9) {
            FBKAnalyticalNumber resultNumber = FBKArmBandResultSetShock;
            [self.delegate analyticalBleData:@"1" withResultNumber:resultNumber];
        }
        else if (keyMark == 10) {
            NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
            int switchMark = bytes[3]&0xFF;
            int shockNumber = bytes[4]&0xFF;
            [resultMap setObject:[NSString stringWithFormat:@"%i",switchMark] forKey:@"switchMark"];
            [resultMap setObject:[NSString stringWithFormat:@"%i",shockNumber] forKey:@"shockNumber"];
            
            FBKAnalyticalNumber resultNumber = FBKArmBandResultGetShock;
            [self.delegate analyticalBleData:resultMap withResultNumber:resultNumber];
        }
        else if (keyMark == 11) {
            FBKAnalyticalNumber resultNumber = FBKArmBandResultCloseShock;
            [self.delegate analyticalBleData:@"1" withResultNumber:resultNumber];
        }
        else if (keyMark == 12) {
            FBKAnalyticalNumber resultNumber = FBKArmBandResultMaxInterval;
            [self.delegate analyticalBleData:@"1" withResultNumber:resultNumber];
        }
        else if (keyMark == 13) {
            FBKAnalyticalNumber resultNumber = FBKArmBandResultLightSwitch;
            [self.delegate analyticalBleData:@"1" withResultNumber:resultNumber];
        }
    }
}


@end
