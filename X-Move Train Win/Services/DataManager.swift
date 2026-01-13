//
//  DataManager.swift
//  X-Move Train Win
//

import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var activities: [Activity] = []
    @Published var trainingPlans: [TrainingPlan] = []
    @Published var userProfile: UserProfile = UserProfile()
    @Published var socialPosts: [SocialPost] = []
    
    private let activitiesKey = "savedActivities"
    private let trainingPlansKey = "savedTrainingPlans"
    private let userProfileKey = "userProfile"
    private let socialPostsKey = "socialPosts"
    
    init() {
        loadData()
    }
    
    // MARK: - Load Data
    func loadData() {
        loadActivities()
        loadTrainingPlans()
        loadUserProfile()
        loadSocialPosts()
    }
    
    // MARK: - Activities
    func loadActivities() {
        if let data = UserDefaults.standard.data(forKey: activitiesKey),
           let decoded = try? JSONDecoder().decode([Activity].self, from: data) {
            activities = decoded
        } else {
            // Load sample data
            activities = generateSampleActivities()
        }
    }
    
    func saveActivities() {
        if let encoded = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(encoded, forKey: activitiesKey)
        }
    }
    
    func addActivity(_ activity: Activity) {
        activities.insert(activity, at: 0)
        saveActivities()
    }
    
    func deleteActivity(_ activity: Activity) {
        activities.removeAll { $0.id == activity.id }
        saveActivities()
    }
    
    // MARK: - Training Plans
    func loadTrainingPlans() {
        if let data = UserDefaults.standard.data(forKey: trainingPlansKey),
           let decoded = try? JSONDecoder().decode([TrainingPlan].self, from: data) {
            trainingPlans = decoded
        } else {
            // Load sample data
            trainingPlans = generateSampleTrainingPlans()
        }
    }
    
    func saveTrainingPlans() {
        if let encoded = try? JSONEncoder().encode(trainingPlans) {
            UserDefaults.standard.set(encoded, forKey: trainingPlansKey)
        }
    }
    
    func addTrainingPlan(_ plan: TrainingPlan) {
        trainingPlans.insert(plan, at: 0)
        saveTrainingPlans()
    }
    
    func updateTrainingPlan(_ plan: TrainingPlan) {
        if let index = trainingPlans.firstIndex(where: { $0.id == plan.id }) {
            trainingPlans[index] = plan
            saveTrainingPlans()
        }
    }
    
    func deleteTrainingPlan(_ plan: TrainingPlan) {
        trainingPlans.removeAll { $0.id == plan.id }
        saveTrainingPlans()
    }
    
    // MARK: - User Profile
    func loadUserProfile() {
        if let data = UserDefaults.standard.data(forKey: userProfileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = decoded
        }
    }
    
    func saveUserProfile() {
        if let encoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: userProfileKey)
        }
    }
    
    // MARK: - Social Posts
    func loadSocialPosts() {
        if let data = UserDefaults.standard.data(forKey: socialPostsKey),
           let decoded = try? JSONDecoder().decode([SocialPost].self, from: data) {
            socialPosts = decoded
        } else {
            // Generate sample posts
            socialPosts = generateSamplePosts()
        }
    }
    
    func saveSocialPosts() {
        if let encoded = try? JSONEncoder().encode(socialPosts) {
            UserDefaults.standard.set(encoded, forKey: socialPostsKey)
        }
    }
    
    func addSocialPost(_ post: SocialPost) {
        socialPosts.insert(post, at: 0)
        saveSocialPosts()
    }
    
    func likePost(_ post: SocialPost) {
        if let index = socialPosts.firstIndex(where: { $0.id == post.id }) {
            socialPosts[index].likes += 1
            saveSocialPosts()
        }
    }
    
    // MARK: - Delete All Data
    func deleteAllData() {
        activities = []
        trainingPlans = []
        userProfile = UserProfile()
        socialPosts = []
        
        UserDefaults.standard.removeObject(forKey: activitiesKey)
        UserDefaults.standard.removeObject(forKey: trainingPlansKey)
        UserDefaults.standard.removeObject(forKey: userProfileKey)
        UserDefaults.standard.removeObject(forKey: socialPostsKey)
    }
    
    // MARK: - Sample Data Generators
    private func generateSampleActivities() -> [Activity] {
        var activities: [Activity] = []
        let calendar = Calendar.current
        
        for i in 0..<10 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            let types: [ActivityType] = [.running, .cycling, .swimming, .walking, .gym]
            let type = types.randomElement() ?? .running
            
            let activity = Activity(
                type: type,
                date: date,
                duration: Double.random(in: 1800...5400),
                distance: Double.random(in: 3...15),
                calories: Double.random(in: 200...800),
                averageSpeed: Double.random(in: 8...20),
                maxSpeed: Double.random(in: 15...30),
                notes: ""
            )
            activities.append(activity)
        }
        
        return activities
    }
    
    private func generateSampleTrainingPlans() -> [TrainingPlan] {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .day, value: 28, to: Date()) ?? Date()
        
        var workoutDays: [WorkoutDay] = []
        for day in 1...7 {
            let workout = WorkoutDay(
                dayOfWeek: day,
                activityType: day % 2 == 0 ? .running : .cycling,
                targetDuration: 2400,
                targetDistance: 5.0
            )
            workoutDays.append(workout)
        }
        
        let plan = TrainingPlan(
            name: "4-Week Endurance Builder",
            goal: .improveEndurance,
            difficulty: .intermediate,
            endDate: endDate,
            workoutDays: workoutDays
        )
        
        return [plan]
    }
    
    private func generateSamplePosts() -> [SocialPost] {
        var posts: [SocialPost] = []
        let usernames = ["Alex Runner", "Sarah Cyclist", "Mike Swimmer", "Emma Athlete", "John Trainer"]
        
        for i in 0..<5 {
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .hour, value: -i * 3, to: Date()) ?? Date()
            
            let activity = Activity(
                type: [.running, .cycling, .swimming].randomElement() ?? .running,
                date: date,
                duration: Double.random(in: 1800...3600),
                distance: Double.random(in: 5...15),
                calories: Double.random(in: 300...700),
                averageSpeed: Double.random(in: 10...20),
                maxSpeed: Double.random(in: 15...25)
            )
            
            let messages = [
                "Great workout today! 🎉",
                "New personal best!",
                "Feeling strong 💪",
                "Another day, another achievement!",
                "Making progress every day!"
            ]
            
            let post = SocialPost(
                username: usernames[i],
                activity: activity,
                message: messages[i],
                timestamp: date,
                likes: Int.random(in: 5...50)
            )
            posts.append(post)
        }
        
        return posts
    }
}

