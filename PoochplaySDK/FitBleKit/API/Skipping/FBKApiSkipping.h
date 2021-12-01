/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKApiSkipping.h
 * 内容摘要：跳绳API
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiSkippingDelegate <NSObject>

// 跳绳数据
- (void)getSkipData:(NSDictionary *)skipInfo andDevice:(id)bleDevice;

@end


@interface FBKApiSkipping : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiSkippingDelegate> delegate;

@end
