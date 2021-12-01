/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKProNewBandAnalytical.h
 * 内容摘要：新手环解析数据
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import <FBKProNTrackerBigData.h>
#import <FBKEnumList.h>

typedef enum{
    FBKAnalyticalSendSuseed = 0, // 发送命令成功
    FBKAnalyticalAck,            // 回复命令
    FBKAnalyticalFindPhone,      // 查找手机
    FBKAnalyticalTakePhoto,      // 照相
    FBKAnalyticalMusicStatus,    // 音乐控制
    FBKAnalyticalLastSyncTime,   // 最后同步时间
    FBKAnalyticalDeviceVersion,  // 硬件版本号
    FBKAnalyticalRealTimeHR,     // 实时心率
    FBKAnalyticalRealTimeSteps,  // 实时步数
    FBKAnalyticalRTStepFrequency,// 实时步频
    FBKAnalyticalRTFistInfo,     // 实时拳击数据
    FBKAnalyticalRTWeight,       // 实时秤数据
    FBKAnalyticalBigData,        // 大数据
    FBKAnalyticalFitList,        // fit文件列表
    FBKAnalyticalFitData,        // fit文件数据
    FBKAnalyticalSyncing,        // 同步大数据中...
    FBKAnalyticalHubLoginStatus, // hub 登录状态
    FBKAnalyticalHubLoginPw,     // hub 登录密码
    FBKAnalyticalHubWifiWorkMode,// hub wifi工作模式
    FBKAnalyticalHubWifiSTA,     // hub wifi STA 信息
    FBKAnalyticalHubWifiSocket,  // hub wifi Socket 信息
    FBKAnalyticalHubNetWorkMode, // hub 内外网模式
    FBKAnalyticalHubRemark,      // hub 备注信息
    FBKAnalyticalHubIpKey,       // hub IP Key
    FBKAnalyticalHubWifiList,    // hub wifi 列表
    FBKAnalyticalHubWifiStatus,  // hub wifi 状态
    
    FBKArmBandResultSetShock,          // 设置震动阈值
    FBKArmBandResultGetShock,          // 获取震动阈值
    FBKArmBandResultCloseShock,        // 关闭震动功能
    FBKArmBandResultMaxInterval,       // 设置心率区间最大值
    FBKArmBandResultLightSwitch,       // 设置呼吸灯的开关
}FBKAnalyticalNumber;

@protocol FBKProNewBandAnalyticalDelegate <NSObject>

// 解析数据返回
- (void)analyticalSucceed:(id)resultData withResultNumber:(FBKAnalyticalNumber)resultNumber;

@end


@interface FBKProNTrackerAnalytical : NSObject<FBKProNTrackerBigDataDelegate>

// 回调协议
@property(assign,nonatomic)id <FBKProNewBandAnalyticalDelegate> delegate;

// 设备类型
@property(assign,nonatomic) BleDeviceType analyticalDeviceType;

// 获取到蓝牙回复的数据
- (void)receiveBlueData:(NSString *)hexString;

// 获取到蓝牙回复的数据中断
- (void)receiveBlueDataError;

@end
