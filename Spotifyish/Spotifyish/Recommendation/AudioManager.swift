//
//  AudioManager.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 07/04/25.
//

import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func play(audioFileName: String) {
        stop() // Stop any currently playing audio

        guard let url = Bundle.main.url(forResource: audioFileName, withExtension: "mp3") else {
            print("❌ Audio file not found: \(audioFileName)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("❌ Failed to play audio: \(error.localizedDescription)")
        }
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }

    func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
}
