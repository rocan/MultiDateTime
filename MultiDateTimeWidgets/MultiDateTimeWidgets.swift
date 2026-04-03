import WidgetKit
import SwiftUI

@main
struct MultiDateTimeWidgetBundle: WidgetBundle {
    var body: some Widget {
        WorldClockWidget()
        MultiDateTimeLiveActivity()
    }
}
