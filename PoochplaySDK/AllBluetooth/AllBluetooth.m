//
//  AllBluetooth.m
//  KuSi
//
//  Created by add on 15-3-23.
//  Copyright (c) 2015年 tlr. All rights reserved.
//

#import "AllBluetooth.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation AllBluetooth
{
    NSMutableArray *devicesArray;
    NSMutableArray *servicesArray;
    NSMutableArray *characteristicsArray;
    NSMutableArray *rssiArray;
    
    CBCentralManager *myManager;
    CBPeripheral *mainPeripheral;
    CBCharacteristic *writeCharacteristic;
    
    NSString *dataTrueMark;
    NSTimer *connectTimer;
}

@synthesize delegate;

- (id)init
{
    myManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    devicesArray = [[NSMutableArray alloc] init];
    servicesArray = [[NSMutableArray alloc] init];
    characteristicsArray = [[NSMutableArray alloc] init];
    rssiArray = [[NSMutableArray alloc] init];
    dataTrueMark = [[NSString alloc] init];
    connectTimer = nil;
    return self;
}

//开始查找蓝牙设备
- (void)startSearchBluetooth
{
    devicesArray = [[NSMutableArray alloc] init];
    servicesArray = [[NSMutableArray alloc] init];
    characteristicsArray = [[NSMutableArray alloc] init];
    rssiArray = [[NSMutableArray alloc] init];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [myManager scanForPeripheralsWithServices:nil options:options];
}

- (void)cancelPeripheralConnectionBluetooth
{
    if (mainPeripheral.name != nil)
    {
       // NSLog(@"绑定手动断开蓝牙连接106");
        [myManager cancelPeripheralConnection:mainPeripheral];
    }
}

- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic;
{
    NSLog(@"Data print");
}

//开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(centralManagerState:)]){
        [self.delegate centralManagerState:central];
    }
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
        {
           // NSLog(@"Bluetooth is on, please scan peripherals") ;
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
           // NSLog(@"Bluetooth is off, please scan peripherals") ;
            break;

        }
        default:
        {
            break;
        }
    }
}

- (void)stopScanBluetooth
{
    [myManager stopScan];
}

- (NSString *)getMacAddress
{
  int                 mgmtInfoBase[6];
  char                *msgBuffer = NULL;
  size_t              length;
  unsigned char       macAddress[6];
  struct if_msghdr    *interfaceMsgStruct;
  struct sockaddr_dl  *socketStruct;
  NSString            *errorFlag = NULL;

  // Setup the management Information Base (mib)
  mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
  mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
  mgmtInfoBase[2] = 0;
  mgmtInfoBase[3] = AF_LINK;        // Request link layer information
  mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces

  // With all configured interfaces requested, get handle index
  if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
    errorFlag = @"if_nametoindex failure";
  else
  {
    // Get the size of the data available (store in len)
    if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
      errorFlag = @"sysctl mgmtInfoBase failure";
    else
    {
      // Alloc memory based on above call
      if ((msgBuffer = malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
      else
      {
        // Get system information, store in buffer
        if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
          errorFlag = @"sysctl msgBuffer failure";
      }
    }
  }

  // Befor going any further...
  if (errorFlag != NULL)
  {
    NSLog(@"Error: %@", errorFlag);
    return errorFlag;
  }

  // Map msgbuffer to interface message structure
  interfaceMsgStruct = (struct if_msghdr *) msgBuffer;

  // Map to link-level socket structure
  socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);

  // Copy link layer address data in socket structure to an array
  memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);

  // Read from char array into a string object, into traditional Mac address format
  NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                macAddress[0], macAddress[1], macAddress[2],
                                macAddress[3], macAddress[4], macAddress[5]];
  NSLog(@"Mac Address: %@", macAddressString);

  // Release the buffer memory
  free(msgBuffer);

  return macAddressString;
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
  
   // [peripheral discoverCharacteristics:nil forService:peripheral.services.firstObject];
    
    
        for (CBService *service in peripheral.services)
        {
    #ifdef FBKLOGDATAINFO
            NSLog(@"peripheral.services %@",service.UUID);
    #endif
            
           // [m_servicesArray addObject:service];
            [peripheral discoverCharacteristics:nil forService:service];
        }

    
    NSLog(peripheral.services);
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(descriptor.characteristic.UUID.UUIDString);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(characteristic.UUID.UUIDString);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(characteristic.value);

}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(peripheral);
    
        for (CBCharacteristic *charac in service.characteristics)
        {
            
            
//            if (charac.value){
//                NSLog(@"Hex New String %@",[charac.value hexEncodedString]);
//            }
//            
    #ifdef FBKLOGDATAINFO
            NSLog(@"peripheral.Characteristics %@",charac.UUID);
            
    #endif
       //     [m_characteristicsArray addObject:charac];
        }

}

// 查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
 //   NSLog(@"%@",[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@  广播名:%@ advertisementData: %@ ", peripheral.identifier.UUIDString, RSSI, peripheral.identifier.UUIDString, peripheral.name, advertisementData]);
    
    
 //   [peripheral readValueForCharacteristic:"]]
    if (abs([RSSI intValue]) > 70)
    {
        return;
    }

    int yiRow = -1;
    
    
    NSString *equName = @"unknowName";
    if (peripheral.name != nil)
    {
        equName = peripheral.name;
    }
    
    for (int i = 0; i < devicesArray.count; i++)
    {
        CBPeripheral *peripheralArr = [[devicesArray objectAtIndex:i] objectForKey:@"per"];
        
        if (peripheral == peripheralArr)
        {
            yiRow = i;
        }
    }
    
   //  NSLog(@"akash device",peripheral.state);
    if (yiRow == -1)
    {
        NSMutableDictionary *perDic = [[NSMutableDictionary alloc] init];
        [perDic setObject:peripheral forKey:@"per"];
        [perDic setObject:[NSString stringWithFormat:@"%@",RSSI] forKey:@"rssi"];
        
        NSArray *serviceData = [advertisementData valueForKey:@"kCBAdvDataServiceData"];
        NSString *devInfo = [self serviceDataValue:@"Device Information" withData:serviceData];

        
        
        NSArray *serviceUIs = [advertisementData valueForKey:@"kCBAdvDataServiceUUIDs"];
        NSString *devUis = [self serviceDataValue:@"Device Information" withData:serviceUIs];
        
       // [peripheral rea
        [perDic setObject:peripheral.identifier.UUIDString forKey:@"uuid"];
        [perDic setObject:equName forKey:@"name"];
        [devicesArray addObject:perDic];
        [peripheral setDelegate:self];
        [peripheral discoverServices:nil];
  //       [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:peripheral.identifier.UUIDString]] forService:service];

        [self.delegate AllBlueData:devicesArray andMark:@"0"];
    } //kCBAdvDataIsConnectable = 1;
    
}

- (NSString *)serviceDataValue:(NSString *)key withData:(NSString *)data
{
    if (!data) return NULL;

    data = [NSString stringWithFormat:@"%@", data];

    NSError *error = NULL;
    NSString *pattern = [NSString stringWithFormat:@"\"%@\" = <(.*)>", key];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (!error)
        
    {
        NSTextCheckingResult *match =
        [regex firstMatchInString:data options:0 range:NSMakeRange(0, data.length)];

        if (match.numberOfRanges > 1)
        {
            return [data substringWithRange:[match rangeAtIndex:1]];
        }

    }

    return NULL;
}



@end

