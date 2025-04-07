//
//  Untitled.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import Foundation

struct DatabaseHelper {
    
    func getMoods() async throws -> [Mood] {
        guard let url = URL(string: "https://your-api.com/moods") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let moods = try JSONDecoder().decode(MoodArray.self, from: data)
        return moods.moods
    }
    
    func getUsers() async throws -> [User] {
        guard let url = URL(string: "https://dummyjson.com/users") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let users = try JSONDecoder().decode(UserArray.self, from: data)
        return users.users
    }
}

struct MoodArray: Codable {
    let moods: [Mood]
    let total, skip, limit: Int
}

struct AppMood: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let image: String
    let category: String
    
    static var mock: AppMood {
        AppMood(
            id: 1,
            title: "Sleep",
            description: "Sedate, ambient and atmospheric tracks for bedtime",
            image: Constants.randomImage,
            category: "Relaxation"
        )
    }
}

struct UserArray: Codable {
    let users: [User]
    let total, skip, limit: Int
}

struct User: Codable, Identifiable {
    let id: Int
    let firstName, lastName: String
    let age: Int
    let email, phone, username, password: String
    let image: String
    let height: Double
    let weight: Double
}
