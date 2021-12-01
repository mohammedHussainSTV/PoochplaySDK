//
//  AllBluetooth.h
//  KuSi
//
//  Created by add on 15-3-23.
//  Copyright (c) 2015年 tlr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol AllBlueDelegate <NSObject>

@optional
-(void)AllBlueData:(id)equList andMark:(NSString *)mark;
-(void)centralManagerState:(CBCentralManager *)central;

@end

@interface AllBluetooth : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
@property(assign,nonatomic)id<AllBlueDelegate> delegate;

- (void)startSearchBluetooth;
- (void)cancelPeripheralConnectionBluetooth;

/***********************************************************************
 停止蓝牙搜索的方法
 ***********************************************************************/
- (void)stopScanBluetooth;

@end