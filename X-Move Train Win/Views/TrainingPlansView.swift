//
//  TrainingPlansView.swift
//  X-Move Train Win
//

import SwiftUI

struct TrainingPlansView: View {
    @ObservedObject var dataManager = DataManager.shared
    @StateObject private var viewModel = TrainingPlanViewModel()
    @State private var showingCreatePlan = false
    @State private var selectedPlanItem: TrainingPlan?
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    private let backgroundColor = Color(hex: "#213d62")
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        if dataManager.trainingPlans.isEmpty {
                            emptyStateView
                        } else {
                            ForEach(dataManager.trainingPlans) { plan in
                                TrainingPlanCard(plan: plan) {
                                    selectedPlanItem = plan
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Training Plans")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreatePlan = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(primaryColor)
                    }
                }
            }
            .sheet(isPresented: $showingCreatePlan) {
                CreateTrainingPlanView(viewModel: viewModel)
            }
            .sheet(item: $selectedPlanItem) { plan in
                TrainingPlanDetailView(plan: plan, viewModel: viewModel)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 80))
                .foregroundColor(primaryColor.opacity(0.5))
            
            Text("No Training Plans")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Create a personalized training plan to achieve your fitness goals")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: { showingCreatePlan = true }) {
                Text("Create Plan")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(secondaryColor)
                    .cornerRadius(12)
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}

struct TrainingPlanCard: View {
    let plan: TrainingPlan
    let action: () -> Void
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(plan.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 15) {
                            Label(plan.goal.rawValue, systemImage: "target")
                            Label(plan.difficulty.rawValue, systemImage: "chart.bar")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.5))
                }
                
                // Progress Bar
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Progress")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("\(Int(plan.completionPercentage))%")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(secondaryColor)
                                .frame(width: geometry.size.width * (plan.completionPercentage / 100), height: 8)
                                .cornerRadius(4)
                        }
                    }
                    .frame(height: 8)
                }
                
                HStack {
                    Label("\(plan.workoutDays.count) Workouts", systemImage: "figure.run")
                    Spacer()
                    Label("\(plan.daysRemaining) Days Left", systemImage: "clock")
                }
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(primaryColor.opacity(0.2))
            .cornerRadius(15)
        }
    }
}

struct CreateTrainingPlanView: View {
    @ObservedObject var viewModel: TrainingPlanViewModel
    @ObservedObject var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedGoal: FitnessGoal = .generalFitness
    @State private var selectedDifficulty: DifficultyLevel = .beginner
    @State private var durationWeeks: Int = 4
    
    private let backgroundColor = Color(hex: "#213d62")
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Goal Selection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Fitness Goal")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            
                            ForEach(FitnessGoal.allCases, id: \.self) { goal in
                                Button(action: { selectedGoal = goal }) {
                                    HStack {
                                        Text(goal.rawValue)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        if selectedGoal == goal {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(secondaryColor)
                                        }
                                    }
                                    .padding()
                                    .background(selectedGoal == goal ? primaryColor.opacity(0.3) : Color.white.opacity(0.1))
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Difficulty Selection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Difficulty Level")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            
                            ForEach(DifficultyLevel.allCases, id: \.self) { level in
                                Button(action: { selectedDifficulty = level }) {
                                    HStack {
                                        Text(level.rawValue)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        if selectedDifficulty == level {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(secondaryColor)
                                        }
                                    }
                                    .padding()
                                    .background(selectedDifficulty == level ? primaryColor.opacity(0.3) : Color.white.opacity(0.1))
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Duration Selection
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Duration")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 15) {
                                ForEach([2, 4, 6, 8], id: \.self) { weeks in
                                    Button(action: { durationWeeks = weeks }) {
                                        VStack(spacing: 5) {
                                            Text("\(weeks)")
                                                .font(.system(size: 24, weight: .bold))
                                            Text("weeks")
                                                .font(.system(size: 12))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(durationWeeks == weeks ? primaryColor.opacity(0.5) : Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Create Button
                        Button(action: createPlan) {
                            Text("Create Plan")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(secondaryColor)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Create Training Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(primaryColor)
                }
            }
        }
    }
    
    private func createPlan() {
        let plan = viewModel.createPersonalizedPlan(
            goal: selectedGoal,
            difficulty: selectedDifficulty,
            durationWeeks: durationWeeks
        )
        dataManager.addTrainingPlan(plan)
        presentationMode.wrappedValue.dismiss()
    }
}

struct TrainingPlanDetailView: View {
    let plan: TrainingPlan
    @ObservedObject var viewModel: TrainingPlanViewModel
    @ObservedObject var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    private let backgroundColor = Color(hex: "#213d62")
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // Plan Info
                        VStack(alignment: .leading, spacing: 15) {
                            Text(plan.name)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 20) {
                                Label(plan.goal.rawValue, systemImage: "target")
                                Label(plan.difficulty.rawValue, systemImage: "chart.bar")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            
                            // Progress
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Overall Progress")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    Spacer()
                                    
                                    Text("\(Int(plan.completionPercentage))%")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(Color.white.opacity(0.2))
                                            .frame(height: 10)
                                            .cornerRadius(5)
                                        
                                        Rectangle()
                                            .fill(secondaryColor)
                                            .frame(width: geometry.size.width * (plan.completionPercentage / 100), height: 10)
                                            .cornerRadius(5)
                                    }
                                }
                                .frame(height: 10)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Workout Schedule
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Weekly Schedule")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(plan.workoutDays) { workout in
                                WorkoutDayRow(workout: workout) {
                                    viewModel.completeWorkout(plan: plan, workoutId: workout.id)
                                }
                            }
                        }
                        
                        // Delete Plan
                        Button(action: deletePlan) {
                            Text("Delete Plan")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.red.opacity(0.7))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Plan Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(primaryColor)
                }
            }
        }
    }
    
    private func deletePlan() {
        dataManager.deleteTrainingPlan(plan)
        presentationMode.wrappedValue.dismiss()
    }
}

struct WorkoutDayRow: View {
    let workout: WorkoutDay
    let onComplete: () -> Void
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: workout.activityType.icon)
                .font(.system(size: 24))
                .foregroundColor(workout.completed ? secondaryColor : primaryColor)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.dayName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 10) {
                    Text(workout.activityType.rawValue)
                    Text("•")
                    Text(workout.formattedDuration)
                    if workout.targetDistance > 0 {
                        Text("•")
                        Text(String(format: "%.1f km", workout.targetDistance))
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            if workout.completed {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(secondaryColor)
            } else {
                Button(action: onComplete) {
                    Text("Complete")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(primaryColor)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(workout.completed ? secondaryColor.opacity(0.1) : Color.white.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

