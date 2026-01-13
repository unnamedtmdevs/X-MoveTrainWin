//
//  TrainingPlan.swift
//  X-Move Train Win
//

import Foundation

enum FitnessGoal: String, Codable, CaseIterable {
    case loseWeight = "Lose Weight"
    case buildMuscle = "Build Muscle"
    case improveEndurance = "Improve Endurance"
    case generalFitness = "General Fitness"
    case competitionPrep = "Competition Prep"
}

enum DifficultyLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

struct WorkoutDay: Identifiable, Codable, Equatable {
    let id: UUID
    let dayOfWeek: Int // 1-7 (Monday-Sunday)
    let activityType: ActivityType
    let targetDuration: TimeInterval // in seconds
    let targetDistance: Double // in km
    let completed: Bool
    let completedDate: Date?
    
    init(id: UUID = UUID(), dayOfWeek: Int, activityType: ActivityType, targetDuration: TimeInterval, targetDistance: Double, completed: Bool = false, completedDate: Date? = nil) {
        self.id = id
        self.dayOfWeek = dayOfWeek
        self.activityType = activityType
        self.targetDuration = targetDuration
        self.targetDistance = targetDistance
        self.completed = completed
        self.completedDate = completedDate
    }
    
    var dayName: String {
        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        return days[dayOfWeek - 1]
    }
    
    var formattedDuration: String {
        let minutes = Int(targetDuration) / 60
        return "\(minutes) min"
    }
}

struct TrainingPlan: Identifiable, Codable {
    let id: UUID
    let name: String
    let goal: FitnessGoal
    let difficulty: DifficultyLevel
    let startDate: Date
    let endDate: Date
    var workoutDays: [WorkoutDay]
    
    init(id: UUID = UUID(), name: String, goal: FitnessGoal, difficulty: DifficultyLevel, startDate: Date = Date(), endDate: Date, workoutDays: [WorkoutDay] = []) {
        self.id = id
        self.name = name
        self.goal = goal
        self.difficulty = difficulty
        self.startDate = startDate
        self.endDate = endDate
        self.workoutDays = workoutDays
    }
    
    var completionPercentage: Double {
        guard !workoutDays.isEmpty else { return 0 }
        let completed = workoutDays.filter { $0.completed }.count
        return Double(completed) / Double(workoutDays.count) * 100
    }
    
    var daysRemaining: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: endDate).day ?? 0
        return max(0, days)
    }
}

