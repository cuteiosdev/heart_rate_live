//
//  WidgetAttributes.swift
//  
//
//  Created by Amy Delves on 23/3/2023.
//

import ActivityKit

public struct WidgetsAttributes: ActivityAttributes {
  public typealias Content = ContentState

  public struct ContentState: Codable, Hashable {
    // Dynamic stateful properties about your activity go here!
    public var heartRate: Int

    public init(heartRate: Int) {
      self.heartRate = heartRate
    }
  }

  public init() {}
}

