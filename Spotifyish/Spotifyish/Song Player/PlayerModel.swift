//Source:https://www.kodeco.com/books/swiftui-cookbook/v1//.0/chapters/1-create-an-audio-player-in-swiftui//

//https://developer.apple.com/documentation/avfaudio/avaudioplayer

import AVFoundation

class AudioPlayerViewModel: ObservableObject {
  let song: Song
  var audioPlayer: AVAudioPlayer?

  @Published var isPlaying = false

  init(song: Song) {
    self.song = song
    if let sound = Bundle.main.path(forResource: self.song.audioFileName, ofType: "mp3") {
      do {
        self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
        self.audioPlayer?.prepareToPlay()
      } catch {
        print("AVAudioPlayer could not be instantiated.")
      }
    } else {
      print("Audio file could not be found.")
    }
  }
  
  func skipForwards(){
    guard let player = audioPlayer else { return }
    let newTime = player.currentTime + 10.0
    player.currentTime = newTime > player.duration ?
    player.duration :newTime
  }
  
  func skipBackwards(){
    guard let player = audioPlayer else { return }
    let newTime = player.currentTime - 10.0
    player.currentTime = newTime < 0 ?
    0 : newTime
  }

  func playOrPause() {
    guard let player = audioPlayer else { return }

    if player.isPlaying {
      player.pause()
      isPlaying = false
    } else {
      player.play()
      isPlaying = true
    }
  }
}

