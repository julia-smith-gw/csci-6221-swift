//Source:https://www.kodeco.com/books/swiftui-cookbook/v1//.0/chapters/1-create-an-audio-player-in-swiftui//

//https://developer.apple.com/documentation/swift/managing-a-shared-resource-using-a-singleton

//https://didlaak6000.medium.com/understanding-singleton-pattern-in-swiftui-66b1965ef99f

//https://stackoverflow.com/questions/67256358/uislider-stuttering-when-updating-value

//https://stackoverflow.com/questions/15094948/avplayer-fast-backward-forward-stream

// https://developer.apple.com/forums/thread/687487

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

class ApplicationMusicPlayerObserver: ObservableObject {
  @Published var song: MusicKit.Song? = nil
  @Published var duration = 0.0
  @Published var currentTime: Double = ApplicationMusicPlayer.shared.playbackTime
  private var timer: Timer?
  @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state
  @Published var isPlaying: Bool = false
  @Published var songLoading : Bool = false
  let musicPlayer = ApplicationMusicPlayer.shared
  private var cancellables: Set<AnyCancellable> = []
  private var queueObserver: AnyCancellable?
  private var stateObserver: AnyCancellable?

  private func addPeriodicTimeObserver() {
    self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {
      timer in
        self.currentTime = self.musicPlayer.playbackTime
    }
  }

  private func removePeriodicTimeObserver() {
    self.timer?.invalidate()
    self.timer = nil
  }

  init() {

    if (stateObserver == nil) {
      stateObserver = ApplicationMusicPlayer.shared.state.objectWillChange
       .sink { [weak self] _ in
         guard let self = self else { return }
         
         let playbackStatus = ApplicationMusicPlayer.shared.state.playbackStatus
         DispatchQueue.main.asyncAfter(
           deadline: .now() + 0.25,
             execute: {
             self.isPlaying = playbackStatus == .playing
             if (self.isPlaying){
               self.addPeriodicTimeObserver()
             } else {
               self.removePeriodicTimeObserver()
             }
           })
       }
    }
   
    if (queueObserver == nil) {
      queueObserver = ApplicationMusicPlayer.shared.queue.objectWillChange
        .sink { [weak self] _ in
          guard let self = self else { return }
            self.songLoading=true
            DispatchQueue.main.asyncAfter(
              deadline: .now() + 0.25,
              execute: {
                if case let .song(song) = ApplicationMusicPlayer.shared.queue.currentEntry?.item {
                  self.songLoading=false
                  self.song = song
                  self.duration = song.duration ?? 0.0
                  self.currentTime = 0.0
                }
              }
            )
        }
    }
  }
}

@MainActor
class AudioPlayerViewModel: ObservableObject {
  static let shared = AudioPlayerViewModel()
  let audioPlayer = ApplicationMusicPlayer.shared
  @Published var song: MusicKit.Song?
  @Published var songLoading: Bool = false
  @Published var songError: Error?
  @Published var showSongError: Bool = false
  @Published var isScrubbing: Bool = false
  @Published var isPlaying = false

  init() {
    return
  }

  func loadNewQueue(playlist: [MusicKit.Song], songIndex: Int) {
    let newQueue: ApplicationMusicPlayer.Queue = ApplicationMusicPlayer.Queue(
      for: playlist,
      startingAt: playlist[songIndex]
    )
    self.audioPlayer.queue = newQueue
  }

  func skipToSong(songIndex: Int) {
    let songsAfterEntry = audioPlayer.queue.entries[songIndex...]
    guard !songsAfterEntry.isEmpty else { return }
    self.audioPlayer.queue = ApplicationMusicPlayer.Queue(songsAfterEntry)
  }

  func changeSong(
    song: MusicKit.Song,
    songIndex: Int?,
    playlist: [MusicKit.Song]
  ) async {
    loadNewQueue(playlist: playlist, songIndex: songIndex ?? 0)
    do {
//      self.showSongError = false
//      self.songLoading = true
//      let catalogSongData = try await fetchSongStreamingInfo(song: song)
//      self.audioPlayer.pause()
//      self.song = catalogSongData
      self.song=song
      if songIndex != nil {
        loadNewQueue(playlist: playlist, songIndex: songIndex ?? 0)
      } else {
        self.audioPlayer.queue = [song]
      }
      try await self.audioPlayer.prepareToPlay()
      await self.playOrPause()
    } catch {
      print("error")
      print(error)
      self.songLoading = false
      self.songError = error
      self.showSongError = true
    }
  }

  func clearSong() {
    self.audioPlayer.pause()
  }

  func skipForwards() async {
    do {
      try await self.audioPlayer.skipToNextEntry()

    } catch {

    }
  }

  func skipBackwards() async {
    if self.audioPlayer.queue.entries.count == 1 {
      return
    }
    do {
      try await audioPlayer.skipToPreviousEntry()
    } catch {

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
    } else {
      do {
        try await self.audioPlayer.play()
      } catch {
        print("error playing  \(error)")
      }
    }
  }
}
