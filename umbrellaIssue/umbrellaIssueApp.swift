import SwiftUI
import UIKit
import BackgroundTasks
import SharedWeatherKit

@main
struct umbrellaIssueApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
