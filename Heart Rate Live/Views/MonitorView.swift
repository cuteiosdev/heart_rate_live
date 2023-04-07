//
//  MonitorView.swift
//  Heart Rate Live
//
//  Created by Amy Delves on 23/3/2023.
//

import SwiftUI

struct MonitorView: View {
  @ObservedObject var viewModel: MonitorViewModel

  var body: some View {
    VStack {
      Text(viewModel.peripheralName)
      if let heartRate = viewModel.heartRate {
        Text("\(heartRate) bpm")
          .font(.title)
      }
    }
    .scenePadding()
    .onDisappear {
      viewModel.dismissActivity()
    }
  }
}
