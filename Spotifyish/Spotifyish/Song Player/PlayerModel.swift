//Source:https://www.kodeco.com/books/swiftui-cookbook/v1//.0/chapters/1-create-an-audio-player-in-swiftui//

//https://developer.apple.com/documentation/avfaudio/avaudioplayer

//https://developer.apple.com/documentation/swift/managing-a-shared-resource-using-a-singleton

//https://didlaak6000.medium.com/understanding-singleton-pattern-in-swiftui-66b1965ef99f

//https://stackoverflow.com/questions/67256358/uislider-stuttering-when-updating-value

import AVFoundation

class AudioPlayerViewModel: ObservableObject {
  static let shared = AudioPlayerViewModel()
  private var timer: Timer?
  private var audioPlayer: AVAudioPlayer?
  private var timeObserver: Any?
  var song: Song?
  var playlist: [Song] = []

  @Published var isPlaying = false
  @Published var volume : Float = 0.5
  @Published var duration: TimeInterval=0.0
  @Published var currentTime: TimeInterval=0.0
  @Published var isScrubbing: Bool=false

  init(){
    return;
  }
  
  func changeSong(song:Song){
    self.audioPlayer?.stop()
    self.song = song
    if let sound = Bundle.main.path(
      forResource: self.song?.audioFileName, ofType: "mp3")
    {
      do {
        self.audioPlayer = try AVAudioPlayer(
          contentsOf: URL(fileURLWithPath: sound))
        self.audioPlayer?.prepareToPlay()
        self.duration = self.audioPlayer?.duration ?? -1
        self.currentTime=0
        self.playOrPause()
      } catch {
        print("AVAudioPlayer could not be instantiated.")
      }
    } else {
      print("Audio file could not be found.")
    }
  }
  
  func clearSong() {
    self.audioPlayer?.stop()
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
        self.currentTime=self.audioPlayer!.currentTime
      }
    }
  }

  private func removePeriodicTimeObserver() {
    self.timer?.invalidate()
    self.timer=nil
  }

  func skipForwards() {
    guard let player = audioPlayer else { return }
    let newTime = player.currentTime + 10.0
    player.currentTime = newTime > player.duration ? player.duration : newTime
  }

  func skipBackwards() {
    guard let player = audioPlayer else { return }
    let newTime = player.currentTime - 10.0
    player.currentTime = newTime < 0 ? 0 : newTime
  }

  func scrubTo(newTime: Double) {
    guard let player = audioPlayer else { return }
    player.currentTime = newTime
  }

  func volumeTo(newVolume: Float) {
    guard let player = audioPlayer else { return }
    player.volume=newVolume
  }

  func playOrPause() {
    guard let player = audioPlayer else { return }

    if player.isPlaying {
      player.pause()
      isPlaying = false
      removePeriodicTimeObserver()
    } else {
      player.play()
      isPlaying = true
      addPeriodicTimeObserver()
    }
  }
}
