//
//  Poochplay.swift
//  PoochplaySDK
//
//  Created by Manish on 12/11/21.
//

import Foundation
import CoreBluetooth

public protocol PoochplayDelegate: NSObject,CBCentralManagerDelegate {
    
    func getRealTimeStepsData(_ stepsDic: [AnyHashable : Any]!, andDevice bleDevice: Any!, macId idString: String!, batterlyLevel btLevel: Int32)
    
    func getRealTimeHeartRate(_ HRInfo: [AnyHashable : Any]!, andDevice bleDevice: Any!)
    
    func findPhone(_ status: Bool, andDevice bleDevice: Any!)
    
    func getBigData(_ bigDataDic: [AnyHashable : Any]!, andDevice bleDevice: Any!)
    
    func allDeviceList(periferal : CBPeripheral)
}

public class Poochplay : NSObject{
    
    public var poochplayDelegate : PoochplayDelegate?
    var oldBandApi = FBKApiOldBand()
    var centralManager : CBCentralManager!
    var peripheral: CBPeripheral!
    var periferalId = ""
   // public static let shared = Poochplay()
    
    public override init(){
        super.init()
        debugPrint("Updated Library")
        //  self.poochplayDelegate?.didConnectedWithPoochplay()
    }
    
    public func scanBle(){
        
        debugPrint("Starting Scan")
      //  self.startManager()
        //   allBlue?.startSearch()
    }
    
    
    public func connectWithBle(uuid:String,periferal:CBPeripheral,manager:CBCentralManager){
        self.oldBandApi.delegate = self
        self.oldBandApi.dataSource = self
        self.oldBandApi.startConnectBleApi(periferal.identifier.uuidString, andIdType: DeviceIdUUID,periferal: periferal, manager: manager)
    }
    
    
    public func disconnectBle() {
        self.oldBandApi.disconnectBleApi()
    }
    
    public func startManager(manager : CBCentralManager){
        centralManager = manager
        centralManager.delegate = self
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state)
        {
        case .poweredOn:
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
            
        default:
            debugPrint("BLE Not on")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        debugPrint(peripheral.name ?? "")
        debugPrint(peripheral.identifier.uuidString)
        if (peripheral.name != nil && peripheral.name! == "PoochPlay"){
            self.poochplayDelegate?.allDeviceList(periferal: peripheral)
            //              self.peripheral = peripheral
            //                if self.periferalId.isEmpty{
            //                    periferalId = self.peripheral.identifier.uuidString
            //                    self.connectNow(id: periferalId,periferal:peripheral)
            //                    self.centralManager.stopScan()
            //                }
            // self.centralManager.connect(self.peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey : true])
        }
    }
    
}


//MARK:- FBKApiBsaeDataSource,FBKApiOldBandDelegate

extension Poochplay:FBKApiOldBandDelegate,FBKApiBsaeDataSource,CBCentralManagerDelegate {
    
    public func deviceFirmware(_ version: String!, andDevice bleDevice: Any!) {
        debugPrint("Delegate deviceFirmware")
    }
    
    public  func getBigData(_ bigDataDic: [AnyHashable : Any]!, andDevice bleDevice: Any!) {
        debugPrint("Delegate bigDataDic")
        
        self.poochplayDelegate?.getBigData(bigDataDic, andDevice: bleDevice)
    }
    
    public func bleConnect(_ status: DeviceBleStatus, andDevice bleDevice: Any!) {
        debugPrint("Delegate bleConnect")
        
        
    }
    
    public func bleConnectError(_ error: Any!, andDevice bleDevice: Any!) {
        
        debugPrint("Ble Connection bleConnectError")
    }
    
    public func devicePower(_ power: String!, andDevice bleDevice: Any!) {
        debugPrint("Delegate devicePower")
        
    }
    
    
    public func deviceHardware(_ version: String!, andDevice bleDevice: Any!) {
        debugPrint("Delegate deviceHardware")
        
    }
    
    public func deviceSoftware(_ version: String!, andDevice bleDevice: Any!) {
        debugPrint("Delegate deviceSoftware")
        
    }
    
    
    public func getRealTimeStepsData(_ stepsDic: [AnyHashable : Any]!, andDevice bleDevice: Any!, macId idString: String!, batterlyLevel btLevel: Int32) {
        debugPrint("Delegate getRealTimeStepsData")
        
        self.poochplayDelegate?.getRealTimeStepsData(stepsDic, andDevice: bleDevice, macId: idString, batterlyLevel: btLevel)
    }
    
    public func getRealTimeHeartRate(_ HRInfo: [AnyHashable : Any]!, andDevice bleDevice: Any!) {
        debugPrint("Delegate getRealTimeHeartRate")
        self.poochplayDelegate?.getRealTimeHeartRate(HRInfo, andDevice: bleDevice)
    }
    
    public func findPhone(_ status: Bool, andDevice bleDevice: Any!) {
        debugPrint("Delegate findPhone")
        self.poochplayDelegate?.findPhone(status, andDevice: bleDevice)
    }
}

