//
//  MonitorsList.swift
//  Heart Rate Live
//
//  Created by Amy Delves on 23/3/2023.
//

import CoreBluetooth
import SwiftUI

struct MonitorsList: View {
  @StateObject var viewModel = MonitorsListViewModel()

  var body: some View {
    List(viewModel.devices) { device in
      Text(device.name ?? "unknown device")
        .contentShape(Rectangle())
        .onTapGesture {
          viewModel.showDetails(peripheral: device)
        }
    }
    .onDisappear {
      viewModel.stopScanning()
    }
    .sheet(item: $viewModel.details) { device in
      MonitorView(viewModel: MonitorViewModel(peripheral: device))
    }
  }
}
