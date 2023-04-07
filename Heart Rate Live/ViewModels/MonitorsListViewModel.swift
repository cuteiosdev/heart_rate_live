//
//  MonitorsListViewModel.swift
//  Heart Rate Live
//
//  Created by Amy Delves on 23/3/2023.
//

import Combine
import CoreBluetooth
import Foundation

public class MonitorsListViewModel: NSObject, ObservableObject {

  @Published var devices: [CBPeripheral] = []
  @Published var details: CBPeripheral?

  let manager: CBCentralManager

  public override init() {
    manager = CBCentralManager()

    super.init()

    manager.delegate = self
  }

  public func startScanningForDevices() {
    guard manager.state == .poweredOn else {
      return
    }

    // 1. limit devices to only heart rate monitors
    manager.scanForPeripherals(withServices: [CBUUID(string: "180D")])
  }

  public func stopScanning() {
    manager.stopScan()
  }

  public func showDetails(peripheral: CBPeripheral) {
    manager.connect(peripheral)
  }

}

extension MonitorsListViewModel: CBCentralManagerDelegate {

  public func centralManagerDidUpdateState(_ central: CBCentralManager) {
    // 2. Bluetooth state
    switch central.state {
    case .poweredOn:
      startScanningForDevices()
    default: break
    }

  }

  public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    // 4. Connect to peripheral
    details = peripheral
  }

  public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    // 3. Discover peripherals
    guard devices.contains(where: { $0.id == peripheral.identifier }) == false else {
      return
    }

    devices.append(peripheral)
  }

}
