/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKApiBsaeMethod.m
 * 内容摘要：API基础类
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月08日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@implementation FBKApiBsaeMethod

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
    
    self.managerController = [[FBKManagerController alloc] init];
    self.managerController.delegate = self;
    self.deviceId = [[NSString alloc] init];
    
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：startConnectBleApi
 * 功能描述：开始连接蓝牙设备
 * 输入参数：deviceId-设备ID   type-设备类型
 * 返回数据：
 ********************************************************************************/
- (void)startConnectBleApi:(NSString *)deviceId andIdType:(DeviceIdType)idType periferal:(CBPeripheral *) perfireral manager:(CBCentralManager *) manager
{
    self.deviceId = deviceId;
    [self.managerController startConnectBleManage:deviceId withDeviceType:self.deviceType andIdType:idType periferal:perfireral manager:manager];
}


/********************************************************************************
 * 方法名称：disconnectBleApi
 * 功能描述：断开蓝牙连接
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)disconnectBleApi
{
    [self.managerController disconnectBleManage];
}


/********************************************************************************
 * 方法名称：editCharacteristicNotifyApi
 * 功能描述：操作通道状态
 * 输入参数：status-开关
 * 返回数据：
 ********************************************************************************/
- (void)editCharacteristicNotifyApi:(BOOL)status  withCharacteristic:(NSString *)uuid
{
    [self.managerController editCharacteristicNotifyManage:status withCharacteristic:uuid];
}


/********************************************************************************
 * 方法名称：readCharacteristicApi
 * 功能描述：读操作
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readCharacteristicApi:(NSString *)uuid
{
    [self.managerController readCharacteristicManage:uuid];
}


/********************************************************************************
 * 方法名称：writeData
 * 功能描述：写入数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)writeData:(NSData *)byteData withCharacteristic:(NSString *)uuid writeWithResponse:(BOOL)response
{
    if (!self.isConnected)
    {
        [self.dataSource bleConnectError:@"Ble is disconnect" andDevice:self];
        return;
    }
    
    [self.managerController writeDataManage:byteData withCharacteristic:uuid writeWithResponse:response];
}


/********************************************************************************
 * 方法名称：readDevicePower
 * 功能描述：获取电量
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readDevicePower
{
    [self readCharacteristicApi:FBKALLDEVICEREPOWER];
}


/********************************************************************************
 * 方法名称：readFirmwareVersion
 * 功能描述：获取固件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readFirmwareVersion {
    [self readCharacteristicApi:FBKDEVICEREFIRMVERSION];
}


/********************************************************************************
 * 方法名称：readHardwareVersion
 * 功能描述：获取硬件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readHardwareVersion {
    [self readCharacteristicApi:FBKDEVICEREHARDVERSION];
}


/********************************************************************************
 * 方法名称：readSoftwareVersion
 * 功能描述：获取软件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readSoftwareVersion {
    [self readCharacteristicApi:FBKDEVICERESOFTVERSION];
}


#pragma mark - **************************** 蓝牙回调 *****************************
/********************************************************************************
 * 方法名称：蓝牙连接状态
 * 功能描述：bleConnectStatus
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status
{
    if (status == DeviceBleConnected || status == DeviceBleSynchronization || status == DeviceBleSyncOver || status == DeviceBleSyncFailed)
    {
        self.isConnected = YES;
    }
    else
    {
        self.isConnected = NO;
    }
    
    [self.dataSource bleConnectStatus:status andDevice:self];
}


/********************************************************************************
 * 方法名称：蓝牙连接错误信息
 * 功能描述：bleConnectError
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectError:(id)error
{
    [self.dataSource bleConnectError:error andDevice:self];
}


/********************************************************************************
 * 方法名称：蓝牙结果数据
 * 功能描述：analyticalData
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber
{
    
}


/********************************************************************************
 * 方法名称：获取电量
 * 功能描述：deviceManagerPower
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerPower:(NSString *)powerInfo {
    [self.dataSource devicePower:powerInfo andDevice:self];
}


/********************************************************************************
 * 方法名称：获取固件版本号
 * 功能描述：deviceManagerFirmwareVersion
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerFirmwareVersion:(NSString *)versionInfo {
    [self.dataSource deviceFirmware:versionInfo andDevice:self];
}


/********************************************************************************
 * 方法名称：获取硬件版本号
 * 功能描述：deviceManagerHardwareVersion
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerHardwareVersion:(NSString *)versionInfo {
    [self.dataSource deviceHardware:versionInfo andDevice:self];
}


/********************************************************************************
 * 方法名称：获取软件版本号
 * 功能描述：deviceManagerSoftwareVersion
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerSoftwareVersion:(NSString *)versionInfo {
    [self.dataSource deviceSoftware:versionInfo andDevice:self];
}


@end
