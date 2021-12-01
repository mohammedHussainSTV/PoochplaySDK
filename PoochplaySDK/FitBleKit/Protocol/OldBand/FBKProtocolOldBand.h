/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKProtocolOldBand.h
 * 内容摘要：老手环蓝牙协议
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import <FBKProtocolBase.h>
#import <FBKProOldBandCmd.h>
#import <FBKProOldBandAnalytical.h>

typedef enum{
    OTrackerCmdSetTime = 0,   // 手环时间
    OTrackerCmdSetUserInfo,   // 个人基本信息
    OTrackerCmdSetSleepInfo,  // 人睡眠信息
    OTrackerCmdSetBikeInfo,   // 单车参数
    OTrackerCmdAckCmd,        // 回复命令
}OTrackerCmdNumber;

@interface FBKProtocolOldBand : FBKProtocolBase<FBKProOldBandCmdDelegate,FBKProOldBandAnalyticalDelegate>

@end
