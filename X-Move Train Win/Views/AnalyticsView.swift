//
//  AnalyticsView.swift
//  X-Move Train Win
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var selectedTimeRange: TimeRange = .week
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    private let backgroundColor = Color(hex: "#213d62")
    private let accentColor = Color(hex: "#82AF31")
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Time Range Selector
                        Picker("Time Range", selection: $selectedTimeRange) {
                            ForEach(TimeRange.allCases, id: \.self) { range in
                                Text(range.rawValue).tag(range)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        // Statistics Cards
                        VStack(spacing: 15) {
                            Text("Your Stats")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                StatCard(
                                    title: "Total Distance",
                                    value: String(format: "%.1f", totalDistance),
                                    unit: "km",
                                    icon: "arrow.right",
                                    color: primaryColor
                                )
                                
                                StatCard(
                                    title: "Total Time",
                                    value: formatTotalTime(totalDuration),
                                    unit: "",
                                    icon: "clock",
                                    color: secondaryColor
                                )
                                
                                StatCard(
                                    title: "Calories Burned",
                                    value: String(format: "%.0f", totalCalories),
                                    unit: "kcal",
                                    icon: "flame",
                                    color: accentColor
                                )
                                
                                StatCard(
                                    title: "Workouts",
                                    value: "\(filteredActivities.count)",
                                    unit: "",
                                    icon: "figure.run",
                                    color: Color(hex: "#FFFFFF")
                                )
                            }
                            .padding(.horizontal)
                        }
                        
                        // Activity Distribution
                        if !filteredActivities.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Activity Distribution")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                ActivityDistributionChart(activities: filteredActivities)
                                    .frame(height: 200)
                                    .padding(.horizontal)
                            }
                        }
                        
                        // Weekly Progress Chart
                        if selectedTimeRange == .week && !filteredActivities.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Weekly Progress")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                WeeklyProgressChart(activities: filteredActivities)
                                    .frame(height: 200)
                                    .padding(.horizontal)
                            }
                        }
                        
                        // Personal Records
                        if !dataManager.activities.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Personal Records")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                PersonalRecordsView(activities: dataManager.activities)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var filteredActivities: [Activity] {
        let calendar = Calendar.current
        let now = Date()
        
        return dataManager.activities.filter { activity in
            switch selectedTimeRange {
            case .week:
                return calendar.isDate(activity.date, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                return calendar.isDate(activity.date, equalTo: now, toGranularity: .month)
            case .year:
                return calendar.isDate(activity.date, equalTo: now, toGranularity: .year)
            }
        }
    }
    
    private var totalDistance: Double {
        filteredActivities.reduce(0) { $0 + $1.distance }
    }
    
    private var totalDuration: TimeInterval {
        filteredActivities.reduce(0) { $0 + $1.duration }
    }
    
    private var totalCalories: Double {
        filteredActivities.reduce(0) { $0 + $1.calories }
    }
    
    private func formatTotalTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        if hours > 0 {
            return "\(hours)h"
        } else {
            let minutes = Int(time) / 60
            return "\(minutes)m"
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                + Text(unit.isEmpty ? "" : " \(unit)")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.2))
        .cornerRadius(12)
    }
}

struct ActivityDistributionChart: View {
    let activities: [Activity]
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    private let accentColor = Color(hex: "#82AF31")
    
    var activityCounts: [(ActivityType, Int)] {
        let grouped = Dictionary(grouping: activities) { $0.type }
        return grouped.map { ($0.key, $0.value.count) }.sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(activityCounts, id: \.0) { type, count in
                HStack(spacing: 12) {
                    Image(systemName: type.icon)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 30)
                    
                    Text(type.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .frame(width: 80, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 20)
                                .cornerRadius(10)
                            
                            Rectangle()
                                .fill(getColorForActivity(type))
                                .frame(width: geometry.size.width * (Double(count) / Double(activities.count)), height: 20)
                                .cornerRadius(10)
                        }
                    }
                    .frame(height: 20)
                    
                    Text("\(count)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 30, alignment: .trailing)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func getColorForActivity(_ type: ActivityType) -> Color {
        switch type {
        case .running: return primaryColor
        case .cycling: return secondaryColor
        case .swimming: return accentColor
        case .walking: return Color(hex: "#FFFFFF").opacity(0.7)
        case .gym: return Color.orange
        }
    }
}

struct WeeklyProgressChart: View {
    let activities: [Activity]
    
    private let secondaryColor = Color(hex: "#86b028")
    
    var dailyData: [(String, Double)] {
        let calendar = Calendar.current
        let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        var data: [(String, Double)] = []
        
        for (index, day) in weekdays.enumerated() {
            let dayActivities = activities.filter {
                let weekday = calendar.component(.weekday, from: $0.date)
                // Convert Sunday (1) to 7, Monday (2) to 1, etc.
                let adjustedWeekday = weekday == 1 ? 7 : weekday - 1
                return adjustedWeekday == index + 1
            }
            let totalDistance = dayActivities.reduce(0.0) { $0 + $1.distance }
            data.append((day, totalDistance))
        }
        
        return data
    }
    
    var maxDistance: Double {
        dailyData.map { $0.1 }.max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(dailyData, id: \.0) { day, distance in
                    VStack(spacing: 5) {
                        Text(distance > 0 ? String(format: "%.1f", distance) : "")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Rectangle()
                            .fill(distance > 0 ? secondaryColor : Color.white.opacity(0.2))
                            .frame(height: max(10, 150 * (distance / maxDistance)))
                            .cornerRadius(4)
                        
                        Text(day)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 180)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct PersonalRecordsView: View {
    let activities: [Activity]
    
    private let primaryColor = Color(hex: "#4a8fdc")
    
    var longestDistance: Activity? {
        activities.max(by: { $0.distance < $1.distance })
    }
    
    var longestDuration: Activity? {
        activities.max(by: { $0.duration < $1.duration })
    }
    
    var mostCalories: Activity? {
        activities.max(by: { $0.calories < $1.calories })
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if let activity = longestDistance {
                RecordRow(
                    title: "Longest Distance",
                    value: String(format: "%.2f km", activity.distance),
                    activityType: activity.type.rawValue,
                    icon: "arrow.right"
                )
            }
            
            if let activity = longestDuration {
                RecordRow(
                    title: "Longest Duration",
                    value: activity.formattedDuration,
                    activityType: activity.type.rawValue,
                    icon: "clock"
                )
            }
            
            if let activity = mostCalories {
                RecordRow(
                    title: "Most Calories",
                    value: String(format: "%.0f kcal", activity.calories),
                    activityType: activity.type.rawValue,
                    icon: "flame"
                )
            }
        }
        .padding(.horizontal)
    }
}

struct RecordRow: View {
    let title: String
    let value: String
    let activityType: String
    let icon: String
    
    private let accentColor = Color(hex: "#82AF31")
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(accentColor)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(activityType)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

