//
//  OnboardingView.swift
//  X-Move Train Win
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("username") private var username = ""
    
    @State private var currentPage = 0
    @State private var tempUsername = ""
    @State private var selectedActivities: Set<ActivityType> = []
    @State private var selectedGoal: FitnessGoal = .generalFitness
    @State private var selectedDifficulty: DifficultyLevel = .beginner
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    private let backgroundColor = Color(hex: "#213d62")
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                // Page 1: Welcome
                welcomePage
                    .tag(0)
                
                // Page 2: Set Username
                usernamePage
                    .tag(1)
                
                // Page 3: Select Activities
                activitiesPage
                    .tag(2)
                
                // Page 4: Set Goal
                goalPage
                    .tag(3)
                
                // Page 5: Set Difficulty
                difficultyPage
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(currentPage == index ? primaryColor : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20)
                
                if currentPage == 4 {
                    Button(action: completeOnboarding) {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(secondaryColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                } else {
                    Button(action: { withAnimation { currentPage += 1 } }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(primaryColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                    .disabled(currentPage == 1 && tempUsername.isEmpty)
                    .opacity(currentPage == 1 && tempUsername.isEmpty ? 0.5 : 1)
                }
            }
        }
    }
    
    private var welcomePage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "flame.fill")
                .font(.system(size: 100))
                .foregroundColor(secondaryColor)
            
            Text("X-Move Train Win")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
            
            Text("Your Ultimate Sports Tracking Companion")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
    
    private var usernamePage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(primaryColor)
            
            Text("What's your name?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            TextField("Enter your name", text: $tempUsername)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
    
    private var activitiesPage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("Select Your Preferred Activities")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            VStack(spacing: 15) {
                ForEach(ActivityType.allCases, id: \.self) { activity in
                    Button(action: {
                        if selectedActivities.contains(activity) {
                            selectedActivities.remove(activity)
                        } else {
                            selectedActivities.insert(activity)
                        }
                    }) {
                        HStack {
                            Image(systemName: activity.icon)
                                .font(.system(size: 24))
                                .frame(width: 30)
                            
                            Text(activity.rawValue)
                                .font(.system(size: 18, weight: .medium))
                            
                            Spacer()
                            
                            if selectedActivities.contains(activity) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(secondaryColor)
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(selectedActivities.contains(activity) ? primaryColor.opacity(0.3) : Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
    
    private var goalPage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("What's Your Fitness Goal?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            VStack(spacing: 15) {
                ForEach(FitnessGoal.allCases, id: \.self) { goal in
                    Button(action: { selectedGoal = goal }) {
                        HStack {
                            Text(goal.rawValue)
                                .font(.system(size: 18, weight: .medium))
                            
                            Spacer()
                            
                            if selectedGoal == goal {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(secondaryColor)
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(selectedGoal == goal ? primaryColor.opacity(0.3) : Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
    
    private var difficultyPage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("Select Your Difficulty Level")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            VStack(spacing: 15) {
                ForEach(DifficultyLevel.allCases, id: \.self) { level in
                    Button(action: { selectedDifficulty = level }) {
                        HStack {
                            Text(level.rawValue)
                                .font(.system(size: 18, weight: .medium))
                            
                            Spacer()
                            
                            if selectedDifficulty == level {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(secondaryColor)
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(selectedDifficulty == level ? primaryColor.opacity(0.3) : Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            Text("You're all set! Let's start your fitness journey.")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 20)
            
            Spacer()
            Spacer()
        }
    }
    
    private func completeOnboarding() {
        username = tempUsername
        
        // Save user profile
        var profile = DataManager.shared.userProfile
        profile.username = tempUsername
        profile.preferredActivities = Array(selectedActivities)
        profile.fitnessGoal = selectedGoal
        profile.difficultyLevel = selectedDifficulty
        DataManager.shared.userProfile = profile
        DataManager.shared.saveUserProfile()
        
        hasCompletedOnboarding = true
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

