import Foundation
import MusicKit
import SwiftUI

//Sources
//https://medium.com/@jongary/binding-a-swiftui-slider-to-an-avplayers-time-a9660526170a
//https://medium.com/@tokusha.aa/mastering-swiftui-and-avplayer-integration-a-complete-guide-to-timecodes-and-advanced-playback-6ef9a88b3b8d

let formatter = DateComponentsFormatter()

struct PlayerView: View {
  var song: MusicKit.Song
  var startNew: Bool = false
  @EnvironmentObject var globalScreenManager: GlobalScreenManager
  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared

  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      Spacer()
      AsyncImage(
        url: audioPlayerViewModel.song?.artwork?.url(width: 200, height: 200)
      )
      .frame(width: 200, height: 200)
      .foregroundStyle(.secondary)
      .padding(.leading, 20)
      .padding(.trailing, 10)

      Spacer()

      Text(audioPlayerViewModel.song?.title ?? "")
        .font(.title)
        .fontWeight(.bold)
        .lineLimit(nil)
        .multilineTextAlignment(.center)

      Text(audioPlayerViewModel.song?.artistName ?? "")
        .font(.subheadline)

      HStack(spacing: 20) {
        Button(
          "Play last",
          systemImage: "backward.fill",
          action: audioPlayerViewModel.skipBackwards
        )
        .labelStyle(.iconOnly).imageScale(.large)

        AsyncButton(
          systemImageName: audioPlayerViewModel.isPlaying
            ? "pause.fill" : "play.fill",
          action: audioPlayerViewModel.playOrPause
        ).labelStyle(.iconOnly)
          .imageScale(.large)

        //        Button("Play or pause", systemImage: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill", action: audioPlayerViewModel.playOrPause
        //        ).labelStyle(.iconOnly)
        //          .imageScale(.large)
        Button(
          "Play next",
          systemImage: "forward.fill",
          action: audioPlayerViewModel.skipForwards
        ).labelStyle(.iconOnly)
          .imageScale(.large)
      }.padding(10)

      VStack {
        HStack {
          Slider(
            value: $audioPlayerViewModel.currentTime,
            in: (0...audioPlayerViewModel.duration),
            onEditingChanged: { editing in
              if !editing {
                audioPlayerViewModel.isScrubbing = false
                audioPlayerViewModel.scrubTo(
                  newTime: audioPlayerViewModel.currentTime
                )
              } else {
                audioPlayerViewModel.isScrubbing = true
              }
            }
          )
          Text(
            String(
              format: "%02d:%02d",
              ((Int)((audioPlayerViewModel.currentTime))) / 60,
              ((Int)((audioPlayerViewModel.currentTime))) % 60
            )
          ).font(.caption)
          Text("/")
          Text(
            String(
              format: "%02d:%02d",
              ((Int)((audioPlayerViewModel.duration))) / 60,
              ((Int)((audioPlayerViewModel.duration))) % 60
            )
          ).font(.caption)

        }.padding()

        HStack {
          Slider(
            value: $audioPlayerViewModel.volume,
            in: (0...1.0),
            step: 0.05,
            onEditingChanged: {
              editing in
              if !editing {
                audioPlayerViewModel.volumeTo(
                  newVolume: audioPlayerViewModel.volume
                )
              }
            }
          )
          Image(systemName: "speaker.wave.3.fill")
        }.padding()
      }.padding()
        .onAppear {
          if startNew {
            Task {
              await audioPlayerViewModel.changeSong(song: song)
            }
          }
        }
      Spacer()
    } .frame(height: UIScreen.main.bounds.height)
  }
}
