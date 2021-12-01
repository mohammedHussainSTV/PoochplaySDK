/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKProtocolHubConfig.h
 * 内容摘要：HUB蓝牙协议
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2018年07月04日
 ********************************************************************************/

#import <FBKProtocolBase.h>
#import <FBKProNTrackerCmd.h>
#import <FBKProNTrackerAnalytical.h>

typedef enum{
    HubConfigCmdLogin = 0,      // HUB登录
    HubConfigCmdGetPassword,    // 获取登录密码
    HubConfigCmdSetPassword,    // 设置登录密码
    HubConfigCmdGetWifiMode,    // 获取WiFi工作模式
    HubConfigCmdSetWifiMode,    // 设置WiFi工作模式
    HubConfigCmdGetWifiSTA,     // 获取 WiFi STA
    HubConfigCmdSetWifiSTA,     // 设置 WiFi STA
    HubConfigCmdGetWifiSocket,  // 获取 Socket 信息
    HubConfigCmdSetWifiSocket,  // 设置 Socket 信息
    HubConfigCmdGetNetWorkMode, // 获取 Hub 内外网模式
    HubConfigCmdSetNetWorkMode, // 设置 Hub 内外网模式
    HubConfigCmdGetRemark,      // 获取 Hub 备注
    HubConfigCmdSetRemark,      // 设置 Hub 备注
    HubConfigCmdGetIpKey,       // 获取 Hub IP key
    HubConfigCmdScanWifi,       // Hub 扫描WiFi
    HubConfigCmdRestart,        // Hub 复位重启
    HubConfigCmdReset,          // Hub 恢复出厂设置
    HubConfigCmdGetWifiStatus,  // 获取WiFi状态
}HubConfigCmdNumber;

@interface FBKProtocolHubConfig : FBKProtocolBase<FBKProNTrackerCmdDelegate,FBKProNewBandAnalyticalDelegate>

@end
