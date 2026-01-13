//
//  User.swift
//  X-Move Train Win
//

import Foundation

struct UserProfile: Codable {
    var username: String
    var email: String
    var age: Int
    var weight: Double // in kg
    var height: Double // in cm
    var preferredActivities: [ActivityType]
    var fitnessGoal: FitnessGoal
    var difficultyLevel: DifficultyLevel
    var profileImage: String? // Base64 encoded or asset name
    
    init(username: String = "", email: String = "", age: Int = 25, weight: Double = 70, height: Double = 170, preferredActivities: [ActivityType] = [], fitnessGoal: FitnessGoal = .generalFitness, difficultyLevel: DifficultyLevel = .beginner, profileImage: String? = nil) {
        self.username = username
        self.email = email
        self.age = age
        self.weight = weight
        self.height = height
        self.preferredActivities = preferredActivities
        self.fitnessGoal = fitnessGoal
        self.difficultyLevel = difficultyLevel
        self.profileImage = profileImage
    }
}

struct SocialPost: Identifiable, Codable {
    let id: UUID
    let username: String
    let activity: Activity
    let message: String
    let timestamp: Date
    var likes: Int
    
    init(id: UUID = UUID(), username: String, activity: Activity, message: String, timestamp: Date = Date(), likes: Int = 0) {
        self.id = id
        self.username = username
        self.activity = activity
        self.message = message
        self.timestamp = timestamp
        self.likes = likes
    }
}

