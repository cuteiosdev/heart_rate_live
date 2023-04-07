//
//  MonitorViewModel.swift
//  Heart Rate Live
//
//  Created by Amy Delves on 23/3/2023.
//

import Combine
import CoreBluetooth
import Foundation
import ActivityKit
import WidgetAttributes

class MonitorViewModel: NSObject, ObservableObject {

  @Published var heartRate: Int?

  let peripheral: CBPeripheral
  var activity: Activity<WidgetsAttributes>?
  var peripheralName: String {
    peripheral.name ?? "unknown device"
  }
  let formatter = HeartRateValueFormatter()

  init(peripheral: CBPeripheral) {
    self.peripheral = peripheral

    super.init()

    peripheral.delegate = self

    // 5. Scan for services
    peripheral.discoverServices([CBUUID(string: "180D")])
  }

  func dismissActivity() {
    // 11.
    Task {
      await activity?.end(dismissalPolicy: .immediate)
    }
  }

}

extension MonitorViewModel: CBPeripheralDelegate {

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    // 6. Scan for characteristics
    peripheral.services?.forEach { service in
      peripheral.discoverCharacteristics(nil, for: service)
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    // 7. Fetch the values for characteristics
    guard service.uuid.uuidString == "180D" else {
      return
    }

    guard let measurementCharacteristic = service.characteristics?.first(where: { $0.uuid.uuidString == "2A37" }) else {
      return
    }

    peripheral.setNotifyValue(true, for: measurementCharacteristic)
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

    // 8. Limit to only measurement updates

    guard characteristic.uuid.uuidString == "2A37" else {
      return
    }

    guard let data = characteristic.value else {
      return
    }

    // 9. Extract measurement data

    heartRate = formatter.valueForData(data)

    print("Did calculate heart rate as \(heartRate ?? 0) bpm")

    // 10. Live activity data
    if ActivityAuthorizationInfo().areActivitiesEnabled {
       let content = ActivityContent(state: WidgetsAttributes.ContentState(heartRate: heartRate ?? 0), staleDate: nil)

       if activity == nil {
         do
         {
           let attributes = WidgetsAttributes()
           activity = try Activity.request(attributes: attributes, content: content)
         } catch {
           print("Error: \(error)")
         }
       } else {
         Task {
           await activity?.update(content)
         }
       }
     }
  }

}
