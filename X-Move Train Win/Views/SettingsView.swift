//
//  SettingsView.swift
//  X-Move Train Win
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var dataManager = DataManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("username") private var username = ""
    
    @State private var showingDeleteConfirmation = false
    @State private var showingProfileEdit = false
    @State private var tempUsername = ""
    @State private var tempEmail = ""
    @State private var tempAge = ""
    @State private var tempWeight = ""
    @State private var tempHeight = ""
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    private let backgroundColor = Color(hex: "#213d62")
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Profile Section
                        VStack(spacing: 20) {
                            Circle()
                                .fill(primaryColor)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text(String((dataManager.userProfile.username.isEmpty ? "U" : dataManager.userProfile.username).prefix(1)))
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            
                            VStack(spacing: 5) {
                                Text(dataManager.userProfile.username.isEmpty ? "User" : dataManager.userProfile.username)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(dataManager.userProfile.email.isEmpty ? "No email set" : dataManager.userProfile.email)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Button(action: { showingProfileEdit = true }) {
                                Text("Edit Profile")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 40)
                                    .background(primaryColor)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Profile Stats
                        VStack(spacing: 15) {
                            HStack(spacing: 15) {
                                ProfileStatCard(
                                    title: "Age",
                                    value: "\(dataManager.userProfile.age)",
                                    icon: "person.fill"
                                )
                                
                                ProfileStatCard(
                                    title: "Weight",
                                    value: String(format: "%.0f kg", dataManager.userProfile.weight),
                                    icon: "scalemass.fill"
                                )
                            }
                            
                            HStack(spacing: 15) {
                                ProfileStatCard(
                                    title: "Height",
                                    value: String(format: "%.0f cm", dataManager.userProfile.height),
                                    icon: "ruler.fill"
                                )
                                
                                ProfileStatCard(
                                    title: "Activities",
                                    value: "\(dataManager.activities.count)",
                                    icon: "figure.run"
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Fitness Goals
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Fitness Goal")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            HStack {
                                Image(systemName: "target")
                                    .foregroundColor(secondaryColor)
                                Text(dataManager.userProfile.fitnessGoal.rawValue)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            Text("Difficulty Level")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(secondaryColor)
                                Text(dataManager.userProfile.difficultyLevel.rawValue)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        // App Settings
                        VStack(alignment: .leading, spacing: 15) {
                            Text("App Settings")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "arrow.clockwise",
                                    title: "Reset Onboarding",
                                    color: primaryColor
                                ) {
                                    resetOnboarding()
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                    .padding(.leading, 60)
                                
                                SettingsRow(
                                    icon: "trash.fill",
                                    title: "Delete Account",
                                    color: .red
                                ) {
                                    showingDeleteConfirmation = true
                                }
                            }
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        // App Info
                        VStack(spacing: 8) {
                            Text("X-Move Train Win")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("Version 1.0.0")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert(isPresented: $showingDeleteConfirmation) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete all your data? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteAccount()
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $showingProfileEdit) {
                EditProfileView()
            }
        }
    }
    
    private func resetOnboarding() {
        hasCompletedOnboarding = false
    }
    
    private func deleteAccount() {
        dataManager.deleteAllData()
        hasCompletedOnboarding = false
        username = ""
    }
}

struct ProfileStatCard: View {
    let title: String
    let value: String
    let icon: String
    
    private let primaryColor = Color(hex: "#4a8fdc")
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(primaryColor)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding()
        }
    }
}

struct EditProfileView: View {
    @ObservedObject var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var selectedGoal: FitnessGoal = .generalFitness
    @State private var selectedDifficulty: DifficultyLevel = .beginner
    
    private let backgroundColor = Color(hex: "#213d62")
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Basic Info
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Basic Information")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            CustomTextField(title: "Username", text: $username)
                            CustomTextField(title: "Email", text: $email)
                            CustomTextField(title: "Age", text: $age)
                                .keyboardType(.numberPad)
                            CustomTextField(title: "Weight (kg)", text: $weight)
                                .keyboardType(.decimalPad)
                            CustomTextField(title: "Height (cm)", text: $height)
                                .keyboardType(.decimalPad)
                        }
                        .padding(.horizontal)
                        
                        // Fitness Goal
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Fitness Goal")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            ForEach(FitnessGoal.allCases, id: \.self) { goal in
                                Button(action: { selectedGoal = goal }) {
                                    HStack {
                                        Text(goal.rawValue)
                                            .foregroundColor(.white)
                                        Spacer()
                                        if selectedGoal == goal {
                                            Image(systemName: "checkmark")
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
                        
                        // Difficulty Level
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Difficulty Level")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            ForEach(DifficultyLevel.allCases, id: \.self) { level in
                                Button(action: { selectedDifficulty = level }) {
                                    HStack {
                                        Text(level.rawValue)
                                            .foregroundColor(.white)
                                        Spacer()
                                        if selectedDifficulty == level {
                                            Image(systemName: "checkmark")
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
                        
                        // Save Button
                        Button(action: saveProfile) {
                            Text("Save Changes")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(secondaryColor)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(primaryColor)
                }
            }
            .onAppear {
                loadCurrentProfile()
            }
        }
    }
    
    private func loadCurrentProfile() {
        let profile = dataManager.userProfile
        username = profile.username
        email = profile.email
        age = "\(profile.age)"
        weight = String(format: "%.1f", profile.weight)
        height = String(format: "%.1f", profile.height)
        selectedGoal = profile.fitnessGoal
        selectedDifficulty = profile.difficultyLevel
    }
    
    private func saveProfile() {
        var profile = dataManager.userProfile
        profile.username = username
        profile.email = email
        profile.age = Int(age) ?? profile.age
        profile.weight = Double(weight) ?? profile.weight
        profile.height = Double(height) ?? profile.height
        profile.fitnessGoal = selectedGoal
        profile.difficultyLevel = selectedDifficulty
        
        dataManager.userProfile = profile
        dataManager.saveUserProfile()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            
            TextField(title, text: $text)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
        }
    }
}

extension CustomTextField {
    func keyboardType(_ type: UIKeyboardType) -> some View {
        return self
    }
}

