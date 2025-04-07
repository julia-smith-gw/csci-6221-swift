//
//  Song.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import Foundation

struct RecommendedSong {
    let name: String
    let genre: String
    let artistName: String
    let imageName: String
    let audioFileName: String
}

let Song: [RecommendedSong] = [
    RecommendedSong(name: "Tequilla", genre: "Country", artistName: "Dan + Shay", imageName: "cover5", audioFileName: "Song5"),
    RecommendedSong(name: "Stargazing", genre: "Pop", artistName: "Myles Smith", imageName: "cover6", audioFileName: "Song6"),
    RecommendedSong(name: "Remind Me To Forget", genre: "Dance", artistName: "Miguel, Kygo", imageName: "cover7", audioFileName: "Song7"),
    RecommendedSong(name: "Happy!", genre: "Pop", artistName: "Pharell Williams", imageName: "cover9", audioFileName: "Song9"),
    RecommendedSong(name: "Go Your Own Way", genre: "Rock", artistName: "FleetWood Mac", imageName: "cover10", audioFileName: "Song10"),
    RecommendedSong(name: "Cruel Summer", genre: "Pop", artistName: "Taylor Swift", imageName: "cover11", audioFileName: "Song11"),
    RecommendedSong(name: "Lil Boo Thang", genre: "Pop", artistName: "Paul Russell", imageName: "cover8", audioFileName: "Song8"),
    RecommendedSong(name: "All I Ask", genre: "Pop", artistName: "Adele", imageName: "cover12", audioFileName: "Song12"),
    RecommendedSong(name: "We Can't Be Friends", genre: "Pop", artistName: "Ariana Grande", imageName: "cover13", audioFileName: "Song13"),
    RecommendedSong(name: "Meant To Be", genre: "Country", artistName: "Bebe Rexha", imageName: "cover15", audioFileName: "Song15"),
    RecommendedSong(name: "Chop Suey!", genre: "Metal", artistName: "System of a Down", imageName: "cover15", audioFileName: "Song15"),
    RecommendedSong(name: "...Another Chance", genre: "Jazz", artistName: "Philly Jones", imageName: "cover1", audioFileName: "Song1"),
    RecommendedSong(name: "Yellow", genre: "Alternative Rock", artistName: "Coldplay", imageName: "cover2", audioFileName: "Song2"),
    RecommendedSong(name: "Relax", genre: "Beats", artistName: "Epidemic", imageName: "cover3", audioFileName: "Relax")
]

