//
//  CBPeripheral+Identifiable.swift
//  Heart Rate Live
//
//  Created by Amy Delves on 23/3/2023.
//

import CoreBluetooth
import Foundation

extension CBPeripheral: Identifiable {

  public var id: UUID {
    identifier
  }

}
