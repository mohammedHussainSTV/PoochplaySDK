/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKManagerController.h
 * 内容摘要：调度层
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 *******************************************************************************/

#import "FBKManagerController.h"
#import "FBKDeviceBaseInfo.h"
#import "FBKSpliceBle.h"

@implementation FBKManagerController
{
    NSString *m_deviceId;
    FBKDeviceBaseInfo *m_deviceBaseInfo;
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
    
    m_deviceId = [[NSString alloc] init];
    m_deviceBaseInfo = [[FBKDeviceBaseInfo alloc] init];
    self.bleController = [[FBKBleController alloc] init];
    self.bleController.delegate = self;
    
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：setDeviceType
 * 功能描述：设置设备类型
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setManagerDeviceType:(BleDeviceType)type
{
    self.deviceType = type;
    
    switch (type) {
            
        case BleDeviceNewBand:
        {
            FBKProtocolNTracker *bandNew = [[FBKProtocolNTracker alloc] init];
            bandNew.delegate = self;
            self.protocolBase = bandNew;
            break;
        }
            
        case BleDeviceNewScale:
        {
            FBKProtocolNScale *scaleNew = [[FBKProtocolNScale alloc] init];
            scaleNew.delegate = self;
            self.protocolBase = scaleNew;
            break;
        }
            
        case BleDeviceOldScale:
        {
            FBKProtocolOldScale *scaleOld = [[FBKProtocolOldScale alloc] init];
            scaleOld.delegate = self;
            self.protocolBase = scaleOld;
            break;
        }
            
        case BleDeviceSkipping:
        {
            FBKProtocolSkipping *skipping = [[FBKProtocolSkipping alloc] init];
            skipping.delegate = self;
            self.protocolBase = skipping;
            break;
        }
            
        case BleDeviceCadence:
        {
            FBKProtocolCadence *cadence = [[FBKProtocolCadence alloc] init];
            cadence.delegate = self;
            self.protocolBase = cadence;
            break;
        }
            
        case BleDeviceOldBand:
        {
            FBKProtocolOldBand *bandOld = [[FBKProtocolOldBand alloc] init];
            bandOld.delegate = self;
            self.protocolBase = bandOld;
            break;
        }
            
        case BleDeviceHeartRate:
        {
            FBKProtocolOldBand *heartRate = [[FBKProtocolOldBand alloc] init];
            heartRate.delegate = self;
            self.protocolBase = heartRate;
            break;
        }
            
        case BleDeviceRosary:
        {
            FBKProtocolRosary *rosary = [[FBKProtocolRosary alloc] init];
            rosary.delegate = self;
            self.protocolBase = rosary;
            break;
        }
            
        case BleDeviceBikeComputer:
        {
            FBKProtocolBikeComputer *bikeComputer = [[FBKProtocolBikeComputer alloc] init];
            bikeComputer.delegate = self;
            self.protocolBase = bikeComputer;
            break;
        }
            
        case BleDeviceArmBand:
        {
            FBKProtocolArmBand *ArmBand = [[FBKProtocolArmBand alloc] init];
            ArmBand.delegate = self;
            self.protocolBase = ArmBand;
            break;
        }
            
        case BleDeviceKettleBell:
        {
            FBKProtocolKettleBell *KettleBell = [[FBKProtocolKettleBell alloc] init];
            KettleBell.delegate = self;
            self.protocolBase = KettleBell;
            break;
        }
            
        case BleDeviceHubConfig:
        {
            FBKProtocolHubConfig *HubConfig = [[FBKProtocolHubConfig alloc] init];
            HubConfig.delegate = self;
            self.protocolBase = HubConfig;
            break;
        }
            
        case BleDeviceBoxing:
        {
            FBKProtocolBoxing *Boxing = [[FBKProtocolBoxing alloc] init];
            Boxing.delegate = self;
            self.protocolBase = Boxing;
            break;
        }
            
        default:
        {
            break;
        }
    }
}


/********************************************************************************
 * 方法名称：startConnectBleApi
 * 功能描述：开始连接蓝牙设备
 * 输入参数：deviceId-设备ID
 * 返回数据：
 ********************************************************************************/
- (void)startConnectBleManage:(NSString *)deviceId withDeviceType:(BleDeviceType)type andIdType:(DeviceIdType)idType periferal:(CBPeripheral *) perfireral manager:(CBCentralManager *) manager
{
    m_deviceId = deviceId;
    self.protocolBase.delegate = self;
    [self.bleController startConnectBleDevice:nil withDeviceId:deviceId andDeviceType:self.deviceType compareWithIdType:idType periferal:perfireral manager:manager];
}


/********************************************************************************
 * 方法名称：disconnectBleManage
 * 功能描述：断开蓝牙连接
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)disconnectBleManage
{
    self.isConnected = NO;
    self.protocolBase.delegate = nil;
    [self.bleController disconnectBleDevice];
}


/********************************************************************************
 * 方法名称：editCharacteristicNotifyApi
 * 功能描述：操作通道状态
 * 输入参数：status-开关
 * 返回数据：
 ********************************************************************************/
- (void)editCharacteristicNotifyManage:(BOOL)status withCharacteristic:(NSString *)uuid
{
    [self.bleController editCharacteristicNotify:uuid withStatus:status];
}


/********************************************************************************
 * 方法名称：readCharacteristicApi
 * 功能描述：读操作
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readCharacteristicManage:(NSString *)uuid
{
    [self.bleController readCharacteristic:uuid];
}


/********************************************************************************
 * 方法名称：writeDataManage
 * 功能描述：写入数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)writeDataManage:(NSData *)byteData withCharacteristic:(NSString *)uuid writeWithResponse:(BOOL)response
{
    [self.bleController writeByte:byteData sendCharacteristic:uuid writeWithResponse:response];
}


/********************************************************************************
 * 方法名称：receiveApiCmd
 * 功能描述：接收API命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveApiCmd:(int)cmdNumber withObject:(id)object
{
    if (!self.isConnected)
    {
        [self.delegate bleConnectError:@"Ble is disconnect"];
    }
    
    [self.protocolBase receiveBleCmd:cmdNumber withObject:object];
}


#pragma mark - **************************** 蓝牙回调 *****************************
/********************************************************************************
 * 方法名称：bleConnectError
 * 功能描述：蓝牙连接失败信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectError:(id)errorInfo andDeviceType:(BleDeviceType)type
{
    [self.delegate bleConnectError:errorInfo];
}


/********************************************************************************
 * 方法名称：bleConnectStatus
 * 功能描述：蓝牙连接状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDeviceType:(BleDeviceType)type
{
    switch (status)
    {
        case DeviceBleConnected:
        {
            NSArray *uuidArray = [m_deviceBaseInfo getScanUuidArray:type andEditType:CharacteristicNotify];
            
            for (int i = 0; i < uuidArray.count; i++)
            {
                NSString *uuid = [NSString stringWithFormat:@"%@",[uuidArray objectAtIndex:i]];
                [self.bleController editCharacteristicNotify:uuid withStatus:YES];
            }
            
            break;
        }
            
        case DeviceBleReconnect:
            [self.protocolBase bleErrorReconnect];
            break;
            
        default:
            break;
    }
    
    if (status == DeviceBleConnected || status == DeviceBleSynchronization || status == DeviceBleSyncOver || status == DeviceBleSyncFailed)
    {
        self.isConnected = YES;
    }
    else
    {
        self.isConnected = NO;
    }
    
    [self.delegate bleConnectStatus:status];
}


/********************************************************************************
 * 方法名称：bleConnectWriteStatus
 * 功能描述：蓝牙写入状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectWriteStatus:(BOOL)Succeed andDeviceType:(BleDeviceType)type
{
    
}


/********************************************************************************
 * 方法名称：bleConnectByteData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectByteData:(CBCharacteristic *)characteristic andDeviceType:(BleDeviceType)type
{
    NSString *uuid = [NSString stringWithFormat:@"%@",characteristic.UUID];
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:FBKALLDEVICEREPOWER]]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerPower:[resultDic objectForKey:@"power"]];
        return;
    }
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:FBKDEVICEREFIRMVERSION]]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerFirmwareVersion:[resultDic objectForKey:@"firmwareVersion"]];
        return;
    }
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:FBKDEVICEREHARDVERSION]]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerHardwareVersion:[resultDic objectForKey:@"hardwareVersion"]];
        return;
    }
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:FBKDEVICERESOFTVERSION]]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerSoftwareVersion:[resultDic objectForKey:@"softwareVersion"]];
        return;
    }
    
    NSString * hexString = [FBKSpliceBle bleDataToString:characteristic.value];
    [self.protocolBase receiveBleData:hexString withUuid:uuid];
}


#pragma mark - **************************** 解析回调 *****************************
/********************************************************************************
 * 方法名称：writeBleByte
 * 功能描述：向蓝牙写入数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)writeBleByte:(NSData *)byteData
{
    NSArray *uuidArray = [m_deviceBaseInfo getScanUuidArray:self.deviceType andEditType:CharacteristicWrite];
    
    if (uuidArray.count > 0 && self.isConnected)
    {
        NSString *uuid = [NSString stringWithFormat:@"%@",[uuidArray objectAtIndex:0]];
        [self.bleController writeByte:byteData sendCharacteristic:uuid writeWithResponse:NO];
    }
}


- (void)writeSpliceByte:(NSData *)byteData withUuid:(NSString *)uuidString {
    if (self.isConnected) {
        [self.bleController writeByte:byteData sendCharacteristic:uuidString writeWithResponse:NO];
    }
}


/********************************************************************************
 * 方法名称：analyticalBleData
 * 功能描述：解析完成的Ble数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalBleData:(id)resultData withResultNumber:(int)resultNumber
{    
    [self.delegate analyticalData:resultData withResultNumber:resultNumber];
}


/********************************************************************************
 * 方法名称：synchronizationStatus
 * 功能描述：大数据同步状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)synchronizationStatus:(DeviceBleStatus)status
{
    [self.delegate bleConnectStatus:status];
}


@end

