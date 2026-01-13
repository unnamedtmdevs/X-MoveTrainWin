//
//  ActivityTrackingView.swift
//  X-Move Train Win
//

import SwiftUI

struct ActivityTrackingView: View {
    @StateObject private var viewModel = ActivityViewModel()
    @ObservedObject var dataManager = DataManager.shared
    @State private var showingActivityHistory = false
    @State private var selectedActivityType: ActivityType = .running
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    private let backgroundColor = Color(hex: "#213d62")
    private let accentColor = Color(hex: "#82AF31")
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Activity Type Selector
                        if !viewModel.isTracking {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Select Activity")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(ActivityType.allCases, id: \.self) { type in
                                            ActivityTypeButton(
                                                type: type,
                                                isSelected: selectedActivityType == type,
                                                action: { selectedActivityType = type }
                                            )
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        
                        // Tracking Display
                        VStack(spacing: 20) {
                            // Time
                            VStack(spacing: 8) {
                                Text("Time")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(formatTime(viewModel.elapsedTime))
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            // Metrics Grid
                            HStack(spacing: 15) {
                                MetricCard(title: "Distance", value: String(format: "%.2f", viewModel.distance), unit: "km", color: primaryColor)
                                MetricCard(title: "Speed", value: String(format: "%.1f", viewModel.currentSpeed), unit: "km/h", color: secondaryColor)
                                MetricCard(title: "Calories", value: String(format: "%.0f", viewModel.calories), unit: "kcal", color: accentColor)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 30)
                        
                        // Control Buttons
                        VStack(spacing: 15) {
                            if !viewModel.isTracking {
                                Button(action: {
                                    viewModel.startTracking(activityType: selectedActivityType)
                                }) {
                                    HStack {
                                        Image(systemName: "play.fill")
                                        Text("Start Workout")
                                            .font(.system(size: 20, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .background(secondaryColor)
                                    .cornerRadius(15)
                                }
                            } else {
                                Button(action: {
                                    viewModel.stopTracking()
                                }) {
                                    HStack {
                                        Image(systemName: "stop.fill")
                                        Text("Finish Workout")
                                            .font(.system(size: 20, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .background(Color.red)
                                    .cornerRadius(15)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Recent Activities
                        if !dataManager.activities.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Recent Activities")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: { showingActivityHistory = true }) {
                                        Text("View All")
                                            .font(.system(size: 14))
                                            .foregroundColor(primaryColor)
                                    }
                                }
                                .padding(.horizontal)
                                
                                ForEach(dataManager.activities.prefix(3)) { activity in
                                    ActivityRowView(activity: activity)
                                }
                            }
                            .padding(.top, 20)
                        }
                        
                        Spacer(minLength: 30)
                    }
                }
            }
            .navigationTitle("Track Activity")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingActivityHistory) {
                ActivityHistoryView()
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct ActivityTypeButton: View {
    let type: ActivityType
    let isSelected: Bool
    let action: () -> Void
    
    private let primaryColor = Color(hex: "#4a8fdc")
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.system(size: 30))
                Text(type.rawValue)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .frame(width: 100, height: 100)
            .background(isSelected ? primaryColor : Color.white.opacity(0.1))
            .cornerRadius(15)
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(unit)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.3))
        .cornerRadius(12)
    }
}

struct ActivityRowView: View {
    let activity: Activity
    
    private let primaryColor = Color(hex: "#4a8fdc")
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: activity.type.icon)
                .font(.system(size: 24))
                .foregroundColor(primaryColor)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.type.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(activity.formattedDate)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(activity.formattedDistance)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Text(activity.formattedDuration)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ActivityHistoryView: View {
    @ObservedObject var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    private let backgroundColor = Color(hex: "#213d62")
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(dataManager.activities) { activity in
                            ActivityRowView(activity: activity)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Activity History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color(hex: "#4a8fdc"))
                }
            }
        }
    }
}

