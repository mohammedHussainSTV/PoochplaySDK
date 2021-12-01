/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKDeviceBaseInfo.h
 * 内容摘要：设备基础信息
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

#import "FBKDeviceBaseInfo.h"

@implementation FBKDeviceBaseInfo

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：viewDidLoad
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init
{
    self = [super init];
    
    self.deviceBleStatus = DeviceBleClosed;
    self.isBleConnect = NO;
    self.blePeripheral = nil;
    self.deviceId = [[NSString alloc] init];
    self.UUIDArray = nil;
    self.servicesArray = [[NSArray alloc] init];
    self.characteristicsArray = [[NSArray alloc] init];
    
    return self;
}


/********************************************************************************
 * 方法名称：getScanUuidArray
 * 功能描述：得到扫描的UUID
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSArray *)getScanUuidArray:(BleDeviceType)deviceType andEditType:(CharacteristicEditType)charType
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    switch (deviceType)
    {
        case BleDeviceBoxing:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKARMBANDNOTIFYFD19];
                [resultArray addObject:FBKHEARTRATENOTIFY2A37];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKARMBANDWRITEFD1A];
            }
            break;
        }
            
        case BleDeviceHubConfig:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKKETTLEBELLNOTIFYFD19];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKKETTLEBELLWRITEFD1A];
            }
            break;
        }
            
        case BleDeviceKettleBell:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKKETTLEBELLNOTIFYFD19];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKKETTLEBELLWRITEFD1A];
            }
            break;
        }
            
        case BleDeviceArmBand:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKARMBANDNOTIFYFD19];
                [resultArray addObject:FBKARMBANDNOTIFYFD09];
                [resultArray addObject:FBKHEARTRATENOTIFY2A37];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKARMBANDWRITEFD1A];
            }
            break;
        }
            
        case BleDeviceBikeComputer:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKBIKENOTIFYFD19];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKBIKEWRITEFD1A];
            }
            break;
        }
            
        case BleDeviceRosary:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKROSARYNOTIFYFD1B];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKROSARYWRITEFD1C];
            }
            break;
        }
            
        case BleDeviceSkipping:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKSKIPPINGNOTIFYFC25];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKSKIPPINGWRITEFC26];
            }
            break;
        }
            
        case BleDeviceCadence:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKCADENCENOTIFY2A5B];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKCADENCEWRITE2A55];
            }
            break;
        }
            
        case BleDeviceHeartRate:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKOLDBANDNOTIFYFC20];
                [resultArray addObject:FBKHEARTRATENOTIFY2A37];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKOLDBANDWRITEFC21];
            }
            break;
        }
            
        case BleDeviceNewScale:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKNEWSCALENOTIFYFD19];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKNEWSCALEWRITEFD1A];
            }
            break;
        }
            
        case BleDeviceOldScale:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKOLDSCALENOTIFYFC22];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKOLDSCALEWRITEFC23];
            }
            break;
        }
            
        case BleDeviceNewBand:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKNEWBANDNOTIFYFD19];
                [resultArray addObject:FBKHEARTRATENOTIFY2A37];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKNEWBANDWRITEFD1A];
            }
            break;
        }
            
        case BleDeviceOldBand:
        {
            if (charType == CharacteristicNotify)
            {
                [resultArray addObject:FBKOLDBANDNOTIFYFC20];
                [resultArray addObject:FBKOLDBANDNOTIFYFC22];
                [resultArray addObject:FBKOLDBANDNOTIFYFD17];
                [resultArray addObject:FBKHEARTRATENOTIFY2A37];
            }
            else if (charType == CharacteristicWrite)
            {
                [resultArray addObject:FBKOLDBANDWRITEFC21];
            }
            break;
        }
            
        default:
        {
            break;
        }
    }
    
    return resultArray;
}


@end

