//
//  TrainingPlanViewModel.swift
//  X-Move Train Win
//

import Foundation
import Combine

class TrainingPlanViewModel: ObservableObject {
    
    func createPersonalizedPlan(goal: FitnessGoal, difficulty: DifficultyLevel, durationWeeks: Int = 4) -> TrainingPlan {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .day, value: durationWeeks * 7, to: Date()) ?? Date()
        
        var workoutDays: [WorkoutDay] = []
        
        // Generate workout schedule based on difficulty
        let workoutsPerWeek: Int
        switch difficulty {
        case .beginner:
            workoutsPerWeek = 3
        case .intermediate:
            workoutsPerWeek = 5
        case .advanced:
            workoutsPerWeek = 6
        }
        
        // Create workout days
        let daysToWorkout = Array(1...7).shuffled().prefix(workoutsPerWeek)
        
        for day in daysToWorkout {
            let (activityType, duration, distance) = getWorkoutParameters(goal: goal, difficulty: difficulty)
            
            let workout = WorkoutDay(
                dayOfWeek: day,
                activityType: activityType,
                targetDuration: duration,
                targetDistance: distance
            )
            workoutDays.append(workout)
        }
        
        workoutDays.sort { $0.dayOfWeek < $1.dayOfWeek }
        
        let planName = "\(durationWeeks)-Week \(goal.rawValue) Plan"
        
        return TrainingPlan(
            name: planName,
            goal: goal,
            difficulty: difficulty,
            endDate: endDate,
            workoutDays: workoutDays
        )
    }
    
    private func getWorkoutParameters(goal: FitnessGoal, difficulty: DifficultyLevel) -> (ActivityType, TimeInterval, Double) {
        var activityType: ActivityType
        var duration: TimeInterval
        var distance: Double
        
        // Determine activity type based on goal
        switch goal {
        case .loseWeight:
            activityType = [.running, .cycling, .walking].randomElement() ?? .running
        case .buildMuscle:
            activityType = .gym
        case .improveEndurance:
            activityType = [.running, .cycling, .swimming].randomElement() ?? .running
        case .generalFitness:
            activityType = ActivityType.allCases.randomElement() ?? .running
        case .competitionPrep:
            activityType = [.running, .cycling].randomElement() ?? .running
        }
        
        // Determine duration and distance based on difficulty
        switch difficulty {
        case .beginner:
            duration = TimeInterval.random(in: 1200...1800) // 20-30 min
            distance = Double.random(in: 2...4)
        case .intermediate:
            duration = TimeInterval.random(in: 1800...3600) // 30-60 min
            distance = Double.random(in: 4...8)
        case .advanced:
            duration = TimeInterval.random(in: 3600...5400) // 60-90 min
            distance = Double.random(in: 8...15)
        }
        
        if activityType == .gym {
            distance = 0
        }
        
        return (activityType, duration, distance)
    }
    
    func completeWorkout(plan: TrainingPlan, workoutId: UUID) {
        var updatedPlan = plan
        if let index = updatedPlan.workoutDays.firstIndex(where: { $0.id == workoutId }) {
            updatedPlan.workoutDays[index] = WorkoutDay(
                id: updatedPlan.workoutDays[index].id,
                dayOfWeek: updatedPlan.workoutDays[index].dayOfWeek,
                activityType: updatedPlan.workoutDays[index].activityType,
                targetDuration: updatedPlan.workoutDays[index].targetDuration,
                targetDistance: updatedPlan.workoutDays[index].targetDistance,
                completed: true,
                completedDate: Date()
            )
            DataManager.shared.updateTrainingPlan(updatedPlan)
        }
    }
}

