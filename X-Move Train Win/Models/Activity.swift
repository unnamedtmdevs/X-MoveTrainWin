//
//  Activity.swift
//  X-Move Train Win
//

import Foundation
import CoreLocation

enum ActivityType: String, Codable, CaseIterable {
    case running = "Running"
    case cycling = "Cycling"
    case swimming = "Swimming"
    case walking = "Walking"
    case gym = "Gym"
    
    var icon: String {
        switch self {
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .swimming: return "figure.pool.swim"
        case .walking: return "figure.walk"
        case .gym: return "dumbbell.fill"
        }
    }
}

struct Activity: Identifiable, Codable, Equatable {
    let id: UUID
    let type: ActivityType
    let date: Date
    let duration: TimeInterval // in seconds
    let distance: Double // in kilometers
    let calories: Double
    let averageSpeed: Double // km/h
    let maxSpeed: Double // km/h
    var notes: String
    
    init(id: UUID = UUID(), type: ActivityType, date: Date = Date(), duration: TimeInterval, distance: Double, calories: Double, averageSpeed: Double, maxSpeed: Double, notes: String = "") {
        self.id = id
        self.type = type
        self.date = date
        self.duration = duration
        self.distance = distance
        self.calories = calories
        self.averageSpeed = averageSpeed
        self.maxSpeed = maxSpeed
        self.notes = notes
    }
    
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    var formattedDistance: String {
        return String(format: "%.2f km", distance)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

