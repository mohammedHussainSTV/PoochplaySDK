/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKProtocolBoxing.h
 * 内容摘要：拳击器蓝牙协议
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import <FBKProtocolBase.h>
#import <FBKProNTrackerCmd.h>
#import <FBKProNTrackerAnalytical.h>

typedef enum{
    BoxingCmdSetTime = 0,       // 时间
    BoxingCmdGetTotalRecord,    // 获取所有历史数据
    BoxingCmdAckCmd,            // 回复命令
    BoxingCmdSendCmdSuseed,     // 发送命令成功
}BoxingCmdNumber;

@interface FBKProtocolBoxing : FBKProtocolBase<FBKProNTrackerCmdDelegate,FBKProNewBandAnalyticalDelegate>

@end


