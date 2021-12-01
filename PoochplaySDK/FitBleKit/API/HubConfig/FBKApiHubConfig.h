/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKApiHubConfig.h
 * 内容摘要：Hub Config API
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2018年07月04日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiHubConfigDelegate <NSObject>


@optional

// 硬件版本号
- (void)hubVersion:(NSString *)version andDevice:(id)bleDevice;

// hub登录状态
- (void)hubLoginStatus:(BOOL)status andDevice:(id)bleDevice;

// hub登录密码
- (void)hubLoginPassword:(NSDictionary *)passwordInfo andDevice:(id)bleDevice;

// hub wifi工作模式
- (void)hubWifiWorkMode:(NSString *)workMode andDevice:(id)bleDevice;

// hub wifi STA信息
- (void)hubWifiSTAInfo:(NSDictionary *)staInfo andDevice:(id)bleDevice;

// hub wifi Socket信息
- (void)hubWifiSocketInfo:(NSDictionary *)socketInfo andDevice:(id)bleDevice;

// hub内外网模式
- (void)hubNetWorkMode:(NSString *)netWorkMode andDevice:(id)bleDevice;

// hub备注信息
- (void)hubRemarkInfo:(NSString *)remark andDevice:(id)bleDevice;

// hub IP信息
- (void)hubIpKeyInfo:(NSDictionary *)ipKeyInfo andDevice:(id)bleDevice;

// hub wifi列表
- (void)hubWifiList:(NSArray *)wifiList andDevice:(id)bleDevice;

// hub wifi状态
- (void)hubWifiStatus:(NSDictionary *)statusInfo andDevice:(id)bleDevice;

@end


@interface FBKApiHubConfig : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiHubConfigDelegate> delegate;

// HUB登录
- (void)hubLogin:(NSString *)hubPassword;

// 获取登录密码
- (void)getHubPassword;

// 设置登录密码
- (void)setHubPassword:(NSDictionary *)hubPwDic;

// 获取WiFi工作模式
- (void)getHubWifiMode;

// 设置WiFi工作模式
- (void)setHubWifiMode:(int)wifiMode;

// 获取 WiFi STA
- (void)getHubWifiSTA;

// 设置 WiFi STA
- (void)setHubWifiSTA:(NSDictionary *)hubStaDic;

// 获取Socket信息
- (void)getHubSocketInfo:(NSDictionary *)hubSocketDic;

// 设置Socket信息
- (void)setHubSocketInfo:(NSDictionary *)hubSocketDic;

// 获取HUB内外网模式
- (void)getHubNetWorkMode;

// 设置HUB内外网模式
- (void)setHubNetWorkMode:(int)networkMode;

// 获取HUB备注
- (void)getHubRemark;

// 设置HUB备注
- (void)setHubRemark:(NSString *)markString;

// 获取HUB IP key
- (void)getHubIpKey;

// HUB扫描WiFi
- (void)scanHubWifi;

// HUB复位重启
- (void)restartHub;

// HUB恢复出厂设置
- (void)resetHub;

// 获取WiFi状态
- (void)getHubWifiStatus;

@end
