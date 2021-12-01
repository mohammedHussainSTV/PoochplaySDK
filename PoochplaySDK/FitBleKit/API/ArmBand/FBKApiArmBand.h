/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKApiArmBand.h
 * 内容摘要：臂带API
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiArmBandDelegate <NSObject>

// 实时心率
- (void)armBandRealTimeHeartRate:(NSDictionary *)HRInfo andDevice:(id)bleDevice;

// 硬件版本号
- (void)armBandVersion:(NSString *)version andDevice:(id)bleDevice;

// 实时步频
- (void)armBandStepFrequency:(NSDictionary *)frequencyDic andDevice:(id)bleDevice;

// 大数据
- (void)armBandDetailData:(NSDictionary *)dataDic andDevice:(id)bleDevice;

- (void)setShockStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)getShockStatus:(NSDictionary *)dataMap andDevice:(id)bleDevice;

- (void)closeShockStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)setMaxIntervalStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)setLightSwitchStatus:(BOOL)status andDevice:(id)bleDevice;

@end


@interface FBKApiArmBand : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiArmBandDelegate> delegate;

// 设置时间
- (void)setArmBandTime;

// 设置心率最大值
- (void)setHeartRateMax:(NSString *)maxRate;

// 设置心率区间颜色
- (void)setHeartRateColor:(FBKDeviceHRColor *)hrColor;

// 进入HRV模式
- (void)enterHRVMode:(BOOL)status;

// 获取所有历史数据
- (void)getArmBandTotalHistory;

// 设置震动阈值
- (void)setShock:(int)shockNumber;

// 获取震动阈值
- (void)getShock;

// 关闭震动功能
- (void)closeShock;

// 设置心率区间最大值
- (void)setMaxInterval:(int)maxNumber;

// 设置呼吸灯的开关
- (void)setLightSwitch:(BOOL)isOpen;

@end
