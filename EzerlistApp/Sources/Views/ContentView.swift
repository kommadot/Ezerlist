import SwiftUI
import EzerlistShared

struct ContentView: View {
    @State private var selection: Int = 1
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView(selection: $selection) {
            CompletedTasksView()
                .tabItem {
                    Label("Completed", systemImage: "checkmark.circle.fill")
                }
                .tag(0)
            
            MainTasksView()
                .tabItem {
                    Label("Tasks", systemImage: "list.bullet.circle.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        .tint(.indigo)
    }
}
