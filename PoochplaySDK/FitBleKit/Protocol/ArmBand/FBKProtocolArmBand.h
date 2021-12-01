/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKProtocolArmBand.h
 * 内容摘要：臂带蓝牙协议
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import <FBKProtocolBase.h>
#import <FBKProNTrackerCmd.h>
#import <FBKProNTrackerAnalytical.h>

typedef enum{
    ArmBandCmdSetTime = 0,       // 手环时间
    ArmBandCmdOpenRealTImeSteps, // 开启实时数据
    ArmBandCmdSetMaxHR,          // 设置最大心率
    ArmBandCmdEnterHRVMode,      // 进入HRV模式
    ArmBandCmdSetHrColor,        // 设置臂带显示颜色
    ArmBandCmdGetDeviceSupport,  // 获取设备支持信息
    ArmBandCmdGetTotalRecord,    // 获取所有历史数据
    ArmBandCmdGetStepRecord,     // 获取运动历史数据
    ArmBandCmdGetHRRecord,       // 获取心率历史数据
    ArmBandCmdAckCmd,            // 回复命令
    ArmBandCmdSendCmdSuseed,     // 发送命令成功
    
    ArmBandCmdSetShock,          // 设置震动阈值
    ArmBandCmdGetShock,          // 获取震动阈值
    ArmBandCmdCloseShock,        // 关闭震动功能
    ArmBandCmdMaxInterval,       // 设置心率区间最大值
    ArmBandCmdLightSwitch,       // 设置呼吸灯的开关
}ArmBandCmdNumber;

@interface FBKProtocolArmBand : FBKProtocolBase<FBKProNTrackerCmdDelegate,FBKProNewBandAnalyticalDelegate>

@end
