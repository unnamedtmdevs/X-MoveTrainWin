//
//  SocialView.swift
//  X-Move Train Win
//

import SwiftUI

struct SocialView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var showingShareSheet = false
    @State private var selectedActivity: Activity?
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    private let backgroundColor = Color(hex: "#213d62")
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Share Your Achievement Section
                        if !dataManager.activities.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Share Your Achievement")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(dataManager.activities.prefix(5)) { activity in
                                            ShareActivityCard(activity: activity) {
                                                shareActivity(activity)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Community Feed
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Community Feed")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            if dataManager.socialPosts.isEmpty {
                                emptyFeedView
                            } else {
                                ForEach(dataManager.socialPosts) { post in
                                    SocialPostCard(post: post) {
                                        dataManager.likePost(post)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var emptyFeedView: some View {
        VStack(spacing: 15) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(primaryColor.opacity(0.5))
            
            Text("No posts yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Share your first activity to get started!")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private func shareActivity(_ activity: Activity) {
        let message = "Just completed a \(activity.type.rawValue) workout! 🎉\n\n📊 Stats:\n• Distance: \(activity.formattedDistance)\n• Duration: \(activity.formattedDuration)\n• Calories: \(Int(activity.calories)) kcal\n\n#XMoveTrainWin #Fitness"
        
        let post = SocialPost(
            username: dataManager.userProfile.username.isEmpty ? "You" : dataManager.userProfile.username,
            activity: activity,
            message: message,
            likes: 0
        )
        
        dataManager.addSocialPost(post)
    }
}

struct ShareActivityCard: View {
    let activity: Activity
    let onShare: () -> Void
    
    private let primaryColor = Color(hex: "#4a8fdc")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: activity.type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(primaryColor)
                
                Text(activity.type.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(activity.formattedDistance)
                    Text("•")
                    Text(activity.formattedDuration)
                }
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
                
                Text(String(format: "%.0f kcal", activity.calories))
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Button(action: onShare) {
                Text("Share")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(primaryColor)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(width: 200)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SocialPostCard: View {
    let post: SocialPost
    let onLike: () -> Void
    
    private let primaryColor = Color(hex: "#4a8fdc")
    private let secondaryColor = Color(hex: "#86b028")
    
    @State private var hasLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // User Info
            HStack(spacing: 12) {
                Circle()
                    .fill(primaryColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(post.username.prefix(1)))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.username)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(timeAgoSince(post.timestamp))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
            }
            
            // Activity Info
            HStack(spacing: 12) {
                Image(systemName: post.activity.type.icon)
                    .font(.system(size: 24))
                    .foregroundColor(secondaryColor)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(post.activity.type.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 10) {
                        Label(post.activity.formattedDistance, systemImage: "arrow.right")
                        Label(post.activity.formattedDuration, systemImage: "clock")
                        Label(String(format: "%.0f kcal", post.activity.calories), systemImage: "flame")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
            
            // Message
            Text(post.message)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(nil)
            
            // Like Button
            HStack {
                Button(action: {
                    if !hasLiked {
                        onLike()
                        hasLiked = true
                    }
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: hasLiked ? "heart.fill" : "heart")
                            .foregroundColor(hasLiked ? .red : .white.opacity(0.7))
                        Text("\(post.likes + (hasLiked ? 1 : 0))")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private func timeAgoSince(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day)d ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)h ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m ago"
        } else {
            return "Just now"
        }
    }
}

