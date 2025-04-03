//Source:https://www.kodeco.com/books/swiftui-cookbook/v1//.0/chapters/1-create-an-audio-player-in-swiftui//


//https://developer.apple.com/documentation/swift/managing-a-shared-resource-using-a-singleton

//https://didlaak6000.medium.com/understanding-singleton-pattern-in-swiftui-66b1965ef99f

//https://stackoverflow.com/questions/67256358/uislider-stuttering-when-updating-value

//https://stackoverflow.com/questions/15094948/avplayer-fast-backward-forward-stream

//https://stackoverflow.com/questions/44434586/achieve-smooth-video-scrubbing-with-avplayer
import AVFoundation
import MusicKit
import SwiftUI

class AudioPlayerViewModel: ObservableObject {
  static let shared = AudioPlayerViewModel()
  private var timer: Timer?
  private var audioPlayer: AVPlayer = AVPlayer()
  private var timeObserver: Any?
  var song: MusicKit.Song?
  var playlist: [Song] = []
  var songFile: AVPlayerItem?

  @Published var isPlaying = false
  @Published var volume : Float = 0.5
  @Published var duration: Double = 0.0
  @Published var currentTime: Double = 0.0
  @Published var isScrubbing: Bool=false

  init(){
    return;
  }
  
  func changeSong(song:MusicKit.Song){
    self.audioPlayer.pause()
    self.song = song
    print ("SONG")
    print(song)
      do {
        if let url = song.url {
          self.songFile = AVPlayerItem(
            url: url
          )
        }
        self.audioPlayer.replaceCurrentItem(with: self.songFile)
        self.duration = self.audioPlayer.currentItem?.duration.seconds ?? CMTime().seconds
        self.currentTime=self.audioPlayer.currentTime().seconds
        self.playOrPause()
      }
    }
  
  func clearSong() {
    self.audioPlayer.pause()
    isPlaying = false
    removePeriodicTimeObserver()
    self.duration=0.0
    self.currentTime=0.0
  }
  
  func changePlaylist(playlist:[Song]){
    self.playlist = playlist
  }

  private func addPeriodicTimeObserver() {
    self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
      if (!self.isScrubbing) {
        self.currentTime=self.audioPlayer.currentTime().seconds
      }
    }
  }

  private func removePeriodicTimeObserver() {
    self.timer?.invalidate()
    self.timer=nil
  }

  func skipForwards() {
    guard let duration  = audioPlayer.currentItem?.duration else{
          return
      }
      let playerCurrentTime = CMTimeGetSeconds(audioPlayer.currentTime())
      let newTime = playerCurrentTime + 10

      if newTime < CMTimeGetSeconds(duration) {

        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale:1000)
          audioPlayer.seek(to: time2)
      }
  }

  func skipBackwards() {
    let playerCurrentTime = CMTimeGetSeconds(audioPlayer.currentTime())
      var newTime = playerCurrentTime - 10

      if newTime < 0 {
          newTime = 0
      }
    let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale:1000)
      audioPlayer.seek(to: time2)
  }

  func scrubTo(newTime: CMTime) {
//    var timeToSeek = player.currentItem?.asset.duration.seconds
//    timeToSeek = timeToSeek * Double(slider.value)
//    audioPlayer.seek(to: newTime, 1)
  }

  func volumeTo(newVolume: Float) {
//    guard let player = audioPlayer else { return }
//    player.volume=newVolume
  }

  func playOrPause() {

    if ((audioPlayer.rate != 0) && (audioPlayer.error == nil)) {
      audioPlayer.pause()
      print("Pause...")
      print(audioPlayer.currentItem?.asset)
      print(audioPlayer.currentItem?.status)
      isPlaying = false
      removePeriodicTimeObserver()
    } else {
      print("Playing...")
      print(audioPlayer.currentItem?.asset)
      print(audioPlayer.currentItem?.status)
      audioPlayer.play()
      isPlaying = true
      addPeriodicTimeObserver()
    }
  }
}
