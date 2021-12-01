/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKApiCadence.h
 * 内容摘要：踏频速度API
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiCadenceDelegate <NSObject>

// 速度踏频数据
- (void)getCadenceData:(NSDictionary *)cadenceInfo andDevice:(id)bleDevice;

@end

@interface FBKApiCadence : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiCadenceDelegate> delegate;

@end
