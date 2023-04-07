//
//  HeartRateValueFormatter.swift
//  Heart Rate Live
//
//  Created by Amy Delves on 23/3/2023.
//

import Foundation

public class HeartRateValueFormatter {

  public init() {}

  public func valueForData(_ data: Data) -> Int? {
    let byteArray = [UInt8](data)
    let firstBitValue = byteArray[0] & 0x01

    if firstBitValue == 0 {
      return Int(byteArray[1])
    }

    return (Int(byteArray[1]) << 8) + Int(byteArray[2])
  }

}
