//https://www.kodeco.com/books/swiftui-cookbook/v1//.0/chapters/1-create-an-audio-player-in-swiftui//

//https://developer.apple.com/documentation/swift/managing-a-shared-resource-using-a-singleton

//https://didlaak6000.medium.com/understanding-singleton-pattern-in-swiftui-66b1965ef99f

//https://stackoverflow.com/questions/67256358/uislider-stuttering-when-updating-value

//https://stackoverflow.com/questions/15094948/avplayer-fast-backward-forward-stream

//https://developer.apple.com/forums/thread/687487

//https://developer.apple.com/documentation/foundation/timer

//https://stackoverflow.com/questions/76890094/call-function-and-pass-parameter-when-timer-is-done-in-swift

//https://developer.apple.com/documentation/musickit/applicationmusicplayer

//https://developer.apple.com/documentation/musickit/musicplayer

//https://www.avanderlee.com/swift/enumerations/

//https://www.reddit.com/r/SwiftUI/comments/1hgre5h/swiftui_combine_and_observation/

//https://developer.apple.com/forums/thread/683995

//https://www.hackingwithswift.com/forums/swiftui/publishing-changes-from-background-threads-is-not-allowed-make-sure-to-publish-values-from-the-main-thread-via-operators-like-receive-on-on-model-updates/12830

//https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/2-understanding-observableobject-observedobject

import AVFoundation
import Combine
import MusicKit
import SwiftUI

class AudioPlayerViewModel: ObservableObject {
  static let shared = AudioPlayerViewModel()
  @Published var fromLibrary: Bool = false
  @Published var song: MusicKit.Song?
  @Published var isScrubbing: Bool = false
  @Published var isPlaying = false
  @Published var duration = 0.0
  @Published var currentTime: Double = ApplicationMusicPlayer.shared.playbackTime
  @Published var pendingSong: MusicKit.Song?
  @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state
  private var timer: Timer?
  private var queueObserver: AnyCancellable?
  private var stateObserver: AnyCancellable?
  private var globalScreenManager = GlobalScreenManager.shared
  let audioPlayer = ApplicationMusicPlayer.shared
  
  private func addPeriodicTimeObserver() {
    self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
      timer in
      if (!self.isScrubbing) {
        self.currentTime=self.audioPlayer.playbackTime
      }
    }
  }

  private func removePeriodicTimeObserver() {
    self.timer?.invalidate()
    self.timer = nil
  }

  init() {
    
    // extra observer to make sure pending song is cleared when it starts playing
    if (stateObserver == nil){
      stateObserver = ApplicationMusicPlayer.shared.state.objectWillChange.sink { [weak self] _ in
        guard let self = self else { return }
        if (self.audioPlayer.state.playbackStatus == .playing && (self.pendingSong != nil && (self.pendingSong?.title == song?.title) && song?.artistName != self.pendingSong?.artistName)){
          self.pendingSong = nil
        }
      }
    }
   
    if (queueObserver == nil) {
      queueObserver = ApplicationMusicPlayer.shared.queue.objectWillChange
        .sink { [weak self] _ in
          guard let self = self else { return }
            DispatchQueue.main.asyncAfter(
              deadline: .now() + 0.5,
              execute: {
                if case let .song(song) = ApplicationMusicPlayer.shared.queue.currentEntry?.item {
                  
                  // add this check to prevent first item in queue from briefly showing before selected item loads in
                  if (self.pendingSong != nil && (self.pendingSong?.title != song.title) && song.artistName != self.pendingSong?.artistName) {
                    return
                  }
                  self.song = song
                  self.duration = song.duration ?? 0.0
                  self.currentTime = 0.0
                  self.pendingSong = nil
                }
              }
            )
        }
    }
  }

  func loadNewQueue(playlist: [MusicKit.Song], songIndex: Int) {
    let newQueue: ApplicationMusicPlayer.Queue = ApplicationMusicPlayer.Queue(
      for: playlist,
      startingAt: playlist[songIndex]
    )
    self.audioPlayer.queue = newQueue
  }

  func changeSong(
    song: MusicKit.Song,
    songIndex: Int,
    fromLibrary: Bool = false,
    playlist: [MusicKit.Song]
  ) async {
    self.pendingSong=song
    self.song = nil
    loadNewQueue(playlist: playlist, songIndex: songIndex)
    do {
      self.fromLibrary = fromLibrary
      self.pendingSong = song
      try await self.audioPlayer.prepareToPlay()
      await self.playOrPause()
    } catch {
      self.pendingSong=nil
      globalScreenManager.showErrorAlert = true
      globalScreenManager.errorMsg = error.localizedDescription
    }
  }

  func clearSong() {
    self.audioPlayer.stop()
    self.song = nil
    self.currentTime = 0.0
    self.duration = 0.0
    removePeriodicTimeObserver()
  }

  func skipForwards() async {
    if self.audioPlayer.queue.entries.count == 1 {
      audioPlayer.restartCurrentEntry()
    }
    do {
      try await self.audioPlayer.skipToNextEntry()
    } catch {
      globalScreenManager.showErrorAlert = true
      globalScreenManager.errorMsg = error.localizedDescription
    }
  }

  func skipBackwards() async {
    if self.audioPlayer.queue.entries.count == 1 {
      audioPlayer.restartCurrentEntry()
    }
    do {
      try await audioPlayer.skipToPreviousEntry()
    } catch {
      globalScreenManager.showErrorAlert = true
      globalScreenManager.errorMsg = error.localizedDescription
    }
  }

  func scrubTo(newTime: TimeInterval) {
    if song == nil {
      return
    }
    audioPlayer.playbackTime = newTime
  }
  
  func playOrPause() async {
    if self.audioPlayer.state.playbackStatus == .playing {
      self.audioPlayer.pause()
      self.isPlaying = false
      removePeriodicTimeObserver()
    } else {
      do {
        try await self.audioPlayer.play()
        self.isPlaying = true
        addPeriodicTimeObserver()
      } catch {
        globalScreenManager.showErrorAlert = true
        globalScreenManager.errorMsg = error.localizedDescription
      }
    }
  }
}
