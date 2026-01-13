//
//  ContentView.swift
//  X-Move Train Win
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
                .environmentObject(dataManager)
        } else {
            OnboardingView()
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let backgroundColor = Color(hex: "#213d62")
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ActivityTrackingView()
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("Track")
                }
                .tag(0)
            
            TrainingPlansView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Plans")
                }
                .tag(1)
            
            AnalyticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
                .tag(2)
            
            SocialView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Community")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(primaryColor)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "#1a2f4a"))
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
