import SwiftUI
import EzerlistShared

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: Text("Account Settings")) {
                        Label("Account", systemImage: "person.circle.fill")
                    }
                    
                    NavigationLink(destination: Text("Notifications")) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    
                    NavigationLink(destination: Text("Appearance")) {
                        Label("Appearance", systemImage: "paintbrush.fill")
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("Help & Support")) {
                        Label("Help & Support", systemImage: "questionmark.circle.fill")
                    }
                    
                    NavigationLink(destination: Text("About")) {
                        Label("About", systemImage: "info.circle.fill")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .listStyle(.insetGrouped)
        }
    }
}
