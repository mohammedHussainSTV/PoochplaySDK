/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKApiBsaeMethod.h
 * 内容摘要：API基础类
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月08日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import <FBKEnumList.h>
#import <FBKManagerController.h>

@protocol FBKApiBsaeDataSource <NSObject>

// 蓝牙连接状态
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice;

// 蓝牙连接错误信息
- (void)bleConnectError:(id)error andDevice:(id)bleDevice;

// 获取电量
- (void)devicePower:(NSString *)power andDevice:(id)bleDevice;

// 获取固件版本号
- (void)deviceFirmware:(NSString *)version andDevice:(id)bleDevice;

// 获取硬件版本号
- (void)deviceHardware:(NSString *)version andDevice:(id)bleDevice;

// 获取软件版本号
- (void)deviceSoftware:(NSString *)version andDevice:(id)bleDevice;

@end


@interface FBKApiBsaeMethod : NSObject<FBKManagerControllerDelegate>

// 协议
@property(assign,nonatomic)id <FBKApiBsaeDataSource> dataSource;

// 设备类型
@property (assign,nonatomic) BleDeviceType deviceType;

// 设备类型
@property (strong,nonatomic) NSString *deviceId;

// 调度类
@property (strong,nonatomic) FBKManagerController *managerController;

// 设备连接状态
@property (assign,nonatomic) BOOL isConnected;


// 开始连接蓝牙设备
- (void)startConnectBleApi:(NSString *)deviceId andIdType:(DeviceIdType)idType periferal:(CBPeripheral *) perfireral manager:(CBCentralManager *) manager;

// 断开蓝牙连接
- (void)disconnectBleApi;

// 操作通道状态
- (void)editCharacteristicNotifyApi:(BOOL)status withCharacteristic:(NSString *)uuid;

// 读操作
- (void)readCharacteristicApi:(NSString *)uuid;

// 写入数据
- (void)writeData:(NSData *)byteData withCharacteristic:(NSString *)uuid writeWithResponse:(BOOL)response;

// 获取电量
- (void)readDevicePower;

// 获取固件版本号
- (void)readFirmwareVersion;

// 获取硬件版本号
- (void)readHardwareVersion;

// 获取软件版本号
- (void)readSoftwareVersion;

@end

