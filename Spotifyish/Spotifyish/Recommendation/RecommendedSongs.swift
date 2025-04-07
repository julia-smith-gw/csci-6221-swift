//
//  RecommendedSongs.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 07/04/25.
//

import Foundation

struct Songs: Identifiable {
    let id = UUID()
    let name: String
    let genre: String
    let artistName: String
    let imageName: String
    let audioFileName: String
}
