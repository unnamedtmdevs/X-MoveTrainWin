//
//  ActivityViewModel.swift
//  X-Move Train Win
//

import Foundation
import Combine

class ActivityViewModel: ObservableObject {
    @Published var isTracking = false
    @Published var currentActivity: ActivityType = .running
    @Published var elapsedTime: TimeInterval = 0
    @Published var distance: Double = 0
    @Published var currentSpeed: Double = 0
    @Published var calories: Double = 0
    
    private var timer: Timer?
    private var startTime: Date?
    
    func startTracking(activityType: ActivityType) {
        currentActivity = activityType
        isTracking = true
        startTime = Date()
        elapsedTime = 0
        distance = 0
        currentSpeed = 0
        calories = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMetrics()
        }
    }
    
    func stopTracking() {
        timer?.invalidate()
        timer = nil
        isTracking = false
        
        // Save the activity
        let activity = Activity(
            type: currentActivity,
            duration: elapsedTime,
            distance: distance,
            calories: calories,
            averageSpeed: distance > 0 ? (distance / (elapsedTime / 3600)) : 0,
            maxSpeed: currentSpeed
        )
        
        DataManager.shared.addActivity(activity)
        
        // Reset
        elapsedTime = 0
        distance = 0
        currentSpeed = 0
        calories = 0
    }
    
    func pauseTracking() {
        timer?.invalidate()
        timer = nil
        isTracking = false
    }
    
    func resumeTracking() {
        isTracking = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMetrics()
        }
    }
    
    private func updateMetrics() {
        elapsedTime += 1
        
        // Simulate GPS tracking
        let speedVariation = Double.random(in: 0.8...1.2)
        let baseSpeed: Double
        
        switch currentActivity {
        case .running:
            baseSpeed = 10.0 // km/h
        case .cycling:
            baseSpeed = 20.0
        case .swimming:
            baseSpeed = 3.0
        case .walking:
            baseSpeed = 5.0
        case .gym:
            baseSpeed = 0.0
        }
        
        currentSpeed = baseSpeed * speedVariation
        
        // Update distance (speed in km/h converted to km per second)
        if currentActivity != .gym {
            distance += (currentSpeed / 3600)
        }
        
        // Calculate calories (rough estimation)
        let caloriesPerSecond: Double
        switch currentActivity {
        case .running:
            caloriesPerSecond = 0.15
        case .cycling:
            caloriesPerSecond = 0.12
        case .swimming:
            caloriesPerSecond = 0.18
        case .walking:
            caloriesPerSecond = 0.07
        case .gym:
            caloriesPerSecond = 0.1
        }
        
        calories += caloriesPerSecond
    }
}

