//
//  PlayerManager.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 07/04/25.
//

import SwiftUI
import AVFoundation

class PlayerManager: ObservableObject {
    @Published var currentSongID: UUID? = nil
    private var audioPlayer: AVAudioPlayer?

    func play(song: Songs) {
        stop() // Stop any currently playing song

        if let url = Bundle.main.url(forResource: song.audioFileName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
                currentSongID = song.id // ✅ Fixed from `songs.id` to `song.id`
            } catch {
                print("Error playing \(song.name): \(error)")
            }
        }
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentSongID = nil
    }

    func isPlaying(song: Songs) -> Bool {
        return currentSongID == song.id // ✅ Fixed method signature and usage
    }
}

