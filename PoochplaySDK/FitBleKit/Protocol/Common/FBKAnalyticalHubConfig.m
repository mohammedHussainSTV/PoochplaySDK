/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FBKAnalyticalHubConfig.h
 * 内容摘要：hub配置数据解析
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2018年06月27日
 ********************************************************************************/

#import "FBKAnalyticalHubConfig.h"

@implementation FBKAnalyticalHubConfig


/********************************************************************************
 * 方法名称：loginStatus
 * 功能描述：上传HUB登录状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)loginStatus:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int loginStatus = [[self noFlashString:hexArray withRow:offSet] intValue];
    [resultDic setObject:[NSString stringWithFormat:@"%i",loginStatus] forKey:@"hubLoginStatus"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：loginPassword
 * 功能描述：上传hub登录密码
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)loginPassword:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int isHavePw = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *password = [[NSMutableString alloc] init];
    if (isHavePw == 1)
    {
        for (int i = 0; i < hexArray.count-2; i++)
        {
            unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
            NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
            [password appendString:asciiCodeStr];
            offSet++;
        }
    }
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",isHavePw] forKey:@"hubIsHavePw"];
    [resultDic setObject:password forKey:@"hubPassword"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：wifiWorkMode
 * 功能描述：上传wifi工作模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)wifiWorkMode:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int workMode = [[self noFlashString:hexArray withRow:offSet] intValue];
    [resultDic setObject:[NSString stringWithFormat:@"%i",workMode] forKey:@"hubWorkMode"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：wifiSTAInfo
 * 功能描述：上传 WIFI STA 信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)wifiSTAInfo:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int ssidLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *ssidString = [[NSMutableString alloc] init];
    for (int i = 0; i < ssidLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [ssidString appendString:asciiCodeStr];
        offSet++;
    }
    
    int encryption = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int algorithm = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int passwordLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *password = [[NSMutableString alloc] init];
    for (int i = 0; i < passwordLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [password appendString:asciiCodeStr];
        offSet++;
    }
    
    [resultDic setObject:ssidString forKey:@"hubSsid"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",encryption] forKey:@"hubEncryption"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",algorithm] forKey:@"hubAlgorithm"];
    [resultDic setObject:password forKey:@"hubPassword"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：wifiSocketInfo
 * 功能描述：上传 wifi Socket 信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)wifiSocketInfo:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int hubSocketNo = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int hubSocketProtocol = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int hubSocketCs = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int ipLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *ipString = [[NSMutableString alloc] init];
    for (int i = 0; i < ipLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [ipString appendString:asciiCodeStr];
        offSet++;
    }
    
    int portLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *portString = [[NSMutableString alloc] init];
    for (int i = 0; i < portLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [portString appendString:asciiCodeStr];
        offSet++;
    }
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",hubSocketNo] forKey:@"hubSocketNo"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",hubSocketProtocol] forKey:@"hubSocketProtocol"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",hubSocketCs] forKey:@"hubSocketCs"];
    [resultDic setObject:ipString forKey:@"hubSocketIp"];
    [resultDic setObject:portString forKey:@"hubSocketPort"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：netWorkMode
 * 功能描述：上传HUB内外网模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)netWorkMode:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int netWorkMode = [[self noFlashString:hexArray withRow:offSet] intValue];
    [resultDic setObject:[NSString stringWithFormat:@"%i",netWorkMode] forKey:@"hubNetWorkMode"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：hubRemarkInfo
 * 功能描述：上传HUB备注信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)hubRemarkInfo:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    NSMutableString *remarkString = [[NSMutableString alloc] init];
    for (int i = 0; i < hexArray.count-1; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [remarkString appendString:asciiCodeStr];
        offSet++;
    }
    
    [resultDic setObject:remarkString forKey:@"hubRemark"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：hubIpKey
 * 功能描述：上传HUB IP
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)hubIpKey:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int ipLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *ipString = [[NSMutableString alloc] init];
    for (int i = 0; i < ipLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [ipString appendString:asciiCodeStr];
        offSet++;
    }
    
    int maskLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *maskString = [[NSMutableString alloc] init];
    for (int i = 0; i < maskLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [maskString appendString:asciiCodeStr];
        offSet++;
    }
    
    int gateWayLen = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *gateWayString = [[NSMutableString alloc] init];
    for (int i = 0; i < gateWayLen; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [gateWayString appendString:asciiCodeStr];
        offSet++;
    }
    
    NSString *maskResString;
    maskResString = [maskString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    maskResString = [maskResString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    [resultDic setObject:ipString forKey:@"hubIp"];
    [resultDic setObject:maskResString forKey:@"hubMask"];
    [resultDic setObject:gateWayString forKey:@"hubGateWay"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：hubWifiList
 * 功能描述：上传wifi列表
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)hubWifiList:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int totalNum = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int sortNum = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int wifiModel = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    NSMutableString *wifiString = [[NSMutableString alloc] init];
    for (int i = 0; i < hexArray.count-4; i++)
    {
        unichar asciiCode = [[self noFlashString:hexArray withRow:offSet] intValue];
        NSString *asciiCodeStr = [NSString stringWithFormat:@"%C",asciiCode];
        [wifiString appendString:asciiCodeStr];
        offSet++;
    }
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",totalNum] forKey:@"totalNum"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",sortNum] forKey:@"sortNum"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",wifiModel] forKey:@"wifiModel"];
    [resultDic setObject:wifiString forKey:@"wifiString"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：hubWifiStatus
 * 功能描述：上传wifi状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)hubWifiStatus:(NSArray *)hexArray
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    int offSet = 1;
    
    int cfgStatus = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    int connectStatus = [[self noFlashString:hexArray withRow:offSet] intValue];
    offSet++;
    
    [resultDic setObject:[NSString stringWithFormat:@"%i",cfgStatus] forKey:@"hubWifiCfgStatus"];
    [resultDic setObject:[NSString stringWithFormat:@"%i",connectStatus] forKey:@"hubWifiConnectStatus"];
    
    return resultDic;
}


/********************************************************************************
 * 方法名称：noFlashString
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSString *)noFlashString:(NSArray *)hexArray withRow:(int)myRow
{
    if (myRow < hexArray.count)
    {
        return [hexArray objectAtIndex:myRow];
    }
    else
    {
        return @"error";
    }
}


@end
