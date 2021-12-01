/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKBleController.m
 * 内容摘要：蓝牙通讯
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

#import "FBKBleController.h"
#import "FBKSpliceBle.h"
//#import "CommonClass.h"
//#import "PoochPlay-Swift.h"

@implementation FBKBleController
{
    CBCentralManager *m_manager;              // 控制器
    CBPeripheral     *m_peripheral;           // 连接的蓝牙
    NSMutableArray   *m_devicesArray;         // 设备列表
    NSMutableArray   *m_servicesArray;        // 服务列表
    NSMutableArray   *m_characteristicsArray; // 通道列表
    int              m_checkServiceNum;       // 连接service的个数
    NSString         *m_deviceId;             // 设备类ID
    BleDeviceType    m_deviceType;            // 设备类型
    DeviceIdType     m_idType;                // ID类型
    NSString         *m_macId;
    NSNumber         *m_batteryLevel;
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
    
 //   NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES],
 //                            CBCentralManagerOptionShowPowerAlertKey,
 //                            nil];
    m_manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    m_devicesArray  = [[NSMutableArray alloc] init];
    m_servicesArray = [[
                        NSMutableArray alloc] init];
    m_characteristicsArray = [[NSMutableArray alloc] init];
    m_checkServiceNum  = 0;
    m_deviceId = [[NSString alloc] init];
    m_macId = @"";
    m_batteryLevel = [[NSNumber alloc] init];;
    
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：startConnectBleDevice
 * 功能描述：开始连接蓝牙设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)startConnectBleDevice:(NSArray *)UUIDArray withDeviceId:(NSString *)deviceId andDeviceType:(BleDeviceType)type compareWithIdType:(DeviceIdType)idType periferal:(CBPeripheral *) perfireral manager:(CBCentralManager *) manager
{
    m_manager = manager;
    [m_manager setDelegate:self];
    m_manager.delegate = self;
    m_deviceId = deviceId;
    m_deviceType = type;
    m_idType = idType;
    [m_devicesArray removeAllObjects];
    
    if (![self getSettingNewConnectedBlue:perfireral])
    {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],
                                 CBCentralManagerOptionShowPowerAlertKey,
                                 [NSNumber numberWithBool:YES],
                                 CBCentralManagerScanOptionAllowDuplicatesKey, nil];
        
        [m_manager scanForPeripheralsWithServices:UUIDArray options:options];
    }
}


/********************************************************************************
 * 方法名称：disconnectBleDevice
 * 功能描述：断开蓝牙连接
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)disconnectBleDevice
{
    [m_manager stopScan];
    
    if (m_peripheral.name != nil)
    {
        [m_manager cancelPeripheralConnection:m_peripheral];
        m_deviceId = @"";
        m_peripheral = nil;
    }
}


/********************************************************************************
 * 方法名称：editCharacteristicNotify
 * 功能描述：操作通道状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)editCharacteristicNotify:(NSString *)charUuid withStatus:(BOOL)status
{
    for (CBCharacteristic *charac in m_characteristicsArray)
    {
        if ([charac.UUID isEqual:[CBUUID UUIDWithString:charUuid]])
        {
            NSLog(@"editCharacteristicNotify is %@---%i",charUuid,status);
            if (m_peripheral != nil) {
                [m_peripheral setNotifyValue:status forCharacteristic:charac];
            }
        }
    }
}


/********************************************************************************
 * 方法名称：readCharacteristic
 * 功能描述：读操作
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readCharacteristic:(NSString *)charUuid
{
    for (CBCharacteristic *charac in m_characteristicsArray)
    {
        if ([charac.UUID isEqual:[CBUUID UUIDWithString:charUuid]])
        {
            NSLog(@"readCharacteristicNotify is %@---",charUuid);
            if (m_peripheral != nil) {
                [m_peripheral readValueForCharacteristic:charac];
            }
        }
    }
}


/********************************************************************************
 * 方法名称：writeByte
 * 功能描述：向蓝牙通道写入数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)writeByte:(NSData *)byteData sendCharacteristic:(NSString *)charUuid writeWithResponse:(BOOL)isResponse
{
    for (CBCharacteristic *charac in m_characteristicsArray)
    {
        if ([charac.UUID isEqual:[CBUUID UUIDWithString:charUuid]])
        {
            if (isResponse)
            {
#ifdef FBKLOGDATAINFO
                NSLog(@"%@ write withResponse data is %@",charUuid,byteData);
#endif
                
                if (m_peripheral != nil) {
                    [m_peripheral writeValue:byteData forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
                }
            }
            else
            {
#ifdef FBKLOGDATAINFO
                NSLog(@"%@ write withoutResponse data is %@",charUuid,byteData);
//                  NSString *str = [byteData hexEncodedString];
//                // [characteristic.value hex]
//
//                //  NSLog(@"mac == %@",macString);
//                  NSLog(@"Hex str == %@ write without",str);

#endif
                
                if (m_peripheral != nil) {
                    [m_peripheral writeValue:byteData forCharacteristic:charac type:CBCharacteristicWriteWithoutResponse];
                }
            }
        }
    }
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:charUuid forKey:@"uuid"];
    [infoDic setObject:byteData forKey:@"value"];
    [[NSNotificationCenter defaultCenter] postNotificationName:FBKWRITENOTIFICATION object:infoDic];
}


#pragma mark - **************************** 扫描回调 *****************************
/********************************************************************************
 * 方法名称：getSettingConnectedBlue
 * 功能描述：搜索并连接系统已配对的蓝牙
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (BOOL)getSettingConnectedBlue:(NSString *)UUIDString
{
    if (m_idType != DeviceIdUUID)
    {
        return NO;
    }
    
    if (UUIDString == nil)
    {
        return NO;
    }
    
    NSArray *UUIDArray = [[NSArray alloc] initWithObjects:[[NSUUID UUID] initWithUUIDString:UUIDString], nil];
    NSArray *settingBlueArray = [m_manager retrievePeripheralsWithIdentifiers:UUIDArray];
    
    if ([settingBlueArray isKindOfClass:[NSArray class]])
    {
        if (settingBlueArray.count > 0)
        {
            for (int i = 0; i < settingBlueArray.count; i++)
            {
                CBPeripheral *nowPeripheral = [settingBlueArray objectAtIndex:i];
                
                if ([m_deviceId isEqualToString:nowPeripheral.identifier.UUIDString])
                {
                    [m_manager stopScan];
                    m_peripheral = nowPeripheral;
                    [m_devicesArray addObject:m_peripheral];
                    [m_manager connectPeripheral:m_peripheral options:nil];
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (BOOL)getSettingNewConnectedBlue:(CBPeripheral *)periferal
{
    m_peripheral = periferal;
    m_manager.delegate = self;
    m_peripheral.delegate = self;
    [m_devicesArray addObject:m_peripheral];
    [m_manager stopScan];
//    [m_manager cancelPeripheralConnection:m_peripheral];
    [m_manager connectPeripheral:m_peripheral options:nil];
    [m_manager connectPeripheral:m_peripheral options:nil];
    [m_manager connectPeripheral:m_peripheral options:nil];
    [m_manager connectPeripheral:m_peripheral options:nil];

    NSLog(@"State %@",m_peripheral);
    return YES;
}

#pragma mark - **************************** 蓝牙回调 *****************************
/********************************************************************************
 * 方法名称：centralManagerDidUpdateState
 * 功能描述：蓝牙状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case (CBManagerStatePoweredOn):
        {
            [self.delegate bleConnectStatus:DeviceBleIsOpen andDeviceType:m_deviceType];
            break;
        }
        default:
        {
            [self.delegate bleConnectStatus:DeviceBleClosed andDeviceType:m_deviceType];
            [self.delegate bleConnectError:@"Phone bluetooth is closed !" andDeviceType:m_deviceType];
            break;
        }
    }
}


/********************************************************************************
 * 方法名称：didDiscoverPeripheral
 * 功能描述：查到外设，停止扫描，连接设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *name = peripheral.name;
    if (peripheral.name == nil)
    {
        name = @"UnknowName";
    }
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:peripheral.identifier.UUIDString forKey:@"UUIDString"];
    [infoDic setObject:name forKey:@"peripheralName"];
    [infoDic setObject:advertisementData forKey:@"advertisementData"];
    
    if ([self compareId:m_deviceId andDeviceInfo:infoDic])
    {
        [m_manager stopScan];
        m_peripheral = peripheral;
        [m_devicesArray addObject:m_peripheral];
        [m_manager connectPeripheral:m_peripheral options:nil];
    }
    
    [self getSettingConnectedBlue:m_deviceId];
}


//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
//{
//
//    [peripheral discoverCharacteristics:nil forService:peripheral.services.firstObject];
//
//    NSLog(peripheral.services);
//
//}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
  //  NSLog(descriptor.characteristic.UUID.UUIDString);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
 //   NSLog(characteristic.UUID.UUIDString);
}

//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    NSLog(characteristic.value);
//
//}

//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
//    NSLog(peripheral);
//}
//


/********************************************************************************
 * 方法名称：didConnectPeripheral
 * 功能描述：开始连接外设
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.delegate bleConnectStatus:DeviceBleConnecting andDeviceType:m_deviceType];
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    
#ifdef FBKLOGDATAINFO
    NSLog(@"didConnectPeripheral Is Succeed");
#endif
}


/********************************************************************************
 * 方法名称：didFailToConnectPeripheral
 * 功能描述：连接外设失败
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
#ifdef FBKLOGDATAINFO
    NSLog(@"didFailToConnectPeripheral Is Error %@",error);
#endif
    
    [self.delegate bleConnectError:error andDeviceType:m_deviceType];
}


/********************************************************************************
 * 方法名称：didDiscoverServices
 * 功能描述：连接外设成功
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        [self.delegate bleConnectError:error andDeviceType:m_deviceType];
        
#ifdef FBKLOGDATAINFO
        NSLog(@"didDiscoverServices Is Error %@",error);
#endif
        
        return;
    }
    
    m_checkServiceNum = 0;
    [m_servicesArray removeAllObjects];
    [m_characteristicsArray removeAllObjects];
    
    for (CBService *service in peripheral.services)
    {
#ifdef FBKLOGDATAINFO
        NSLog(@"peripheral.services %@",service.UUID);
#endif
        
        [m_servicesArray addObject:service];
        [peripheral discoverCharacteristics:nil forService:service];
    }
}


/********************************************************************************
 * 方法名称：didDiscoverCharacteristicsForService
 * 功能描述：连接服务成功，获取数据通道
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
#ifdef FBKLOGDATAINFO
        NSLog(@"didDiscoverCharacteristicsForService Is Error %@",error);
#endif
        
        [self.delegate bleConnectError:error andDeviceType:m_deviceType];
        return;
    }
    
    m_checkServiceNum++;
    
    for (CBCharacteristic *charac in service.characteristics)
    {
#ifdef FBKLOGDATAINFO
        NSLog(@"peripheral.Characteristics %@",charac.UUID);
        NSLog(@"peripheral.Characteristics String %@",charac.UUID.UUIDString);
        NSLog(@"peripheral.Data %@",charac.value);

        
     //   if ([charac.UUID.UUIDString  isEqual:  @"2A19"]){
            [peripheral setNotifyValue:YES forCharacteristic:charac];

//
//                    Byte *batteryBytes=(Byte*)charac.value.bytes;
//                    int i = *((char *)batteryBytes);
//
//                //    int battery = bytesToInt(batteryBytes, 0)&0xff;
//                    NSLog(@"%@", [NSString stringWithFormat:@"battery left:%d",i]);
    //    }

//        UInt8 batteryLevel = ((UInt8*)characteristic.value.bytes)[0];
//
//        NSLog(@"",[characteristic.value getBytes:& batteryLevel length:0]);
//        NSLog(@"Battery level: %hhu",batteryLevel);
#endif
        [m_characteristicsArray addObject:charac];
    }
    
    if (m_checkServiceNum == m_servicesArray.count)
    {
        [self.delegate bleConnectStatus:DeviceBleConnected andDeviceType:m_deviceType];
    }
}


/********************************************************************************
 * 方法名称：didUpdateValueForCharacteristic
 * 功能描述：获取手环外设发来的数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/



- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
#ifdef FBKLOGDATAINFO
        NSLog(@"didUpdateNotificationStateForCharacteristic Is Error %@",error);
#endif
        
        [self.delegate bleConnectError:error andDeviceType:m_deviceType];
        return;
    }
    
#ifdef FBKLOGDATAINFO
    NSLog(@"deviceId: %@  uuid: %@   value: %@",m_deviceId, characteristic.UUID, characteristic.value);
    NSLog(@"deviceUUIDString: %@  uuid: %@ ",characteristic.UUID.UUIDString, characteristic.UUID);

    
    if ([characteristic.UUID.UUIDString  isEqual:  @"2A19"]){
                Byte *batteryBytes=(Byte*)characteristic.value.bytes;
                int i = *((char *)batteryBytes);
        
            //    int battery = bytesToInt(batteryBytes, 0)&0xff;
      //          NSLog(@"%@", [NSString stringWithFormat:@"battery left:%d %",i]);
        
        self->m_batteryLevel = [NSNumber numberWithInt:i];
  //      [NSUserDefaults.standardUserDefaults setValue:(int)self->m_batteryLevel forKey:@"battery_level"];
        
        [NSUserDefaults.standardUserDefaults setObject:self->m_batteryLevel forKey:@"battery_level"];

    }
    
    if ([characteristic.UUID.UUIDString  isEqual:  @"FC20"]){
     //     NSString *str = [characteristic.value hexEncodedString];
  //        NSLog(@"Hex str == %@ with CUUid == %@ with UUID == %@",[str uppercaseString],characteristic.UUID,peripheral.identifier);
 //       [CommonClass setSelectedBluetoothDeviceId:dictDevice forPet:[CommonClass getSelectPet]];

        

//        NSMutableDictionary *dictDevices = [CommonClass getSelectedBluetoothDevicesForPet:[CommonClass getSelectPet]];
//
//        NSString* macId = [dictDevices valueForKey:@"macid"];
//        if ([macId  isEqual: @""] || macId == nil){
            
            
//            if (![str  isEqual: @""]){
                
      //      NSArray<NSString *> * codeArray = [[str uppercaseString] componentsSeparatedByString: @":"];
            
//            NSMutableArray * mutableStr = [[NSMutableArray alloc] initWithArray:codeArray];
//
//
//            [mutableStr removeLastObject];
//
//            NSMutableArray *lastFourObj = [[mutableStr subarrayWithRange:NSMakeRange(([mutableStr count]-4), 4)] mutableCopy];

//            lastFourObj.forEach { (data) in
//                actualAddress.append(String(data))
//            }
//            }

            
         //   [CommonClass updateSelectedBluetoothDeviceId:[lastFourObj componentsJoinedByString:@":"] forPet:[CommonClass getSelectPet]];
//        }
//        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [peripheral readValueForCharacteristic:characteristic];


#endif
    
    [self.delegate bleConnectByteData:characteristic andDeviceType:m_deviceType];
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:[NSString stringWithFormat:@"%@",characteristic.UUID] forKey:@"uuid"];
    [infoDic setObject:characteristic.value forKey:@"value"];
    [[NSNotificationCenter defaultCenter] postNotificationName:FBKDATANOTIFICATION object:infoDic];
}


/********************************************************************************
 * 方法名称：didUpdateNotificationStateForCharacteristic
 * 功能描述：特征的状态更新通知
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        [self.delegate bleConnectError:error andDeviceType:m_deviceType];
        
#ifdef FBKLOGDATAINFO
        NSLog(@"didUpdateNotificationStateForCharacteristic Is Error %@",error);
#endif
    }
}


/********************************************************************************
 * 方法名称：didWriteValueForCharacteristic
 * 功能描述：检测向外设写数据是否成功
 * 输入参数：
 * 返回数据：
 ********************************************************************************/




- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        [self.delegate bleConnectError:error andDeviceType:m_deviceType];
        [self.delegate bleConnectWriteStatus:NO andDeviceType:m_deviceType];
        
#ifdef FBKLOGDATAINFO
        NSLog(@"didWriteValueForCharacteristic Is Error %@",error);
#endif
    }
    else
    {
        
     //     NSString *str = [characteristic.value hexEncodedString];
        // [characteristic.value hex]
          
      //    NSLog(@"Hex str == %@",[str uppercaseString]);

        [self.delegate bleConnectWriteStatus:YES andDeviceType:m_deviceType];
        
#ifdef FBKLOGDATAINFO
        NSLog(@"writeValue Is Succeed");
#endif
    }
}


/********************************************************************************
 * 方法名称：didDisconnectPeripheral
 * 功能描述：失去连接后重新连接
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
#ifdef FBKLOGDATAINFO
    NSLog(@"************** connect again **************");
#endif
    
    if (m_deviceId.length != 0 && m_peripheral != nil)
    {
        [self.delegate bleConnectStatus:DeviceBleReconnect andDeviceType:m_deviceType];
        [m_manager connectPeripheral:m_peripheral options:nil];
    }
}


#pragma mark - **************************** ID值匹配 *****************************
/********************************************************************************
 * 方法名称：compareId
 * 功能描述：ID值匹配
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (BOOL)compareId:(NSString *)idString andDeviceInfo:(NSDictionary *)info
{
    BOOL isIdEqual = NO;
    
    if (idString.length == 0)
    {
        return isIdEqual;
    }
    
    if (m_idType == DeviceIdUUID)
    {
        NSString *UUIDString = [info objectForKey:@"UUIDString"];
        if ([idString isEqualToString:UUIDString])
        {
            isIdEqual = YES;
        }
    }
    else if (m_idType == DeviceIdMacAdress)
    {
        NSData *byteData = [[info objectForKey:@"advertisementData"] objectForKey:@"kCBAdvDataManufacturerData"];
        NSString *macString = [FBKSpliceBle bleDataToString:byteData];
        NSString *MACAddress = [FBKSpliceBle getMacAddress:macString];
        if ([idString isEqualToString:MACAddress])
        {
            isIdEqual = YES;
        }
    }
    else if (m_idType == DeviceIdName)
    {
        NSString *peripheralName = [info objectForKey:@"peripheralName"];
        if ([idString isEqualToString:peripheralName])
        {
            isIdEqual = YES;
        }
    }
    else
    {
        NSData *byteData = [[info objectForKey:@"advertisementData"] objectForKey:@"kCBAdvDataManufacturerData"];
        NSString *myIdString = [FBKSpliceBle analyticalDeviceId:byteData];
        if ([idString isEqualToString:myIdString])
        {
            isIdEqual = YES;
        }
    }
    
    return isIdEqual;
}


@end
