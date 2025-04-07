//
//  Mood.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import Foundation

struct Mood: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let image: String
    let category: String

    static var mock: Mood {
        Mood(id: 1, title: "Sleep", description: "Calm tracks for better sleep", image: Constants.randomImage, category: "Relaxation")
    }
}
