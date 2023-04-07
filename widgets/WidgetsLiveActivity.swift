//
//  WidgetsLiveActivity.swift
//  widgets
//
//  Created by Amy Delves on 23/3/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI
import WidgetAttributes

struct WidgetsLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: WidgetsAttributes.self) { context in
      // Lock screen/banner UI goes here
      VStack {
        Text("Current Heart Rate \(context.state.heartRate)bpm")
      }
      .activityBackgroundTint(Color.cyan)
      .activitySystemActionForegroundColor(Color.black)

    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded UI goes here.  Compose the expanded UI through
        // various regions, like leading/trailing/center/bottom
        DynamicIslandExpandedRegion(.center) {
          Text("\(context.state.heartRate)bpm")
            .font(.title)
          // more content
        }
      } compactLeading: {
        Image(systemName: "heart.circle")
      } compactTrailing: {
        Text("\(context.state.heartRate)bpm")
      } minimal: {
        Text("\(context.state.heartRate)")
      }
      .keylineTint(Color.red)
    }
  }
}

struct WidgetsLiveActivity_Previews: PreviewProvider {
  static let attributes = WidgetsAttributes()
  static let contentState = WidgetsAttributes.ContentState(heartRate: 72)

  static var previews: some View {
    attributes
      .previewContext(contentState, viewKind: .dynamicIsland(.compact))
      .previewDisplayName("Island Compact")
    attributes
      .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
      .previewDisplayName("Island Expanded")
    attributes
      .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
      .previewDisplayName("Minimal")
    attributes
      .previewContext(contentState, viewKind: .content)
      .previewDisplayName("Notification")
  }
}
