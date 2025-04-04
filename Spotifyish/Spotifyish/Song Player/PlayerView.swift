import SwiftUI
import Foundation
//Sources
//https://medium.com/@jongary/binding-a-swiftui-slider-to-an-avplayers-time-a9660526170a
//https://cocoacasts.com/cocoa-fundamentals-formatting-a-time-interval-in-swift
//https://stackoverflow.com/questions/67256358/uislider-stuttering-when-updating-value

let formatter = DateComponentsFormatter()

struct PlayerView: View {
    @EnvironmentObject var globalScreenManager: GlobalScreenManager
    @ObservedObject var viewModel = SongsViewModel.shared
    @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared
    @Binding var song: Song
    var startNew: Bool = false

    var body: some View {
        VStack (alignment:.center, spacing: 10) {
            Image(audioPlayerViewModel.song?.imageName ?? "")
                .resizable()
                .frame(width: 200, height: 200)
                .shadow(radius: 10)
        
        Text(audioPlayerViewModel.song?.name ?? "")
            .font(.title)
            .fontWeight(.bold)
        
        Text(audioPlayerViewModel.song?.artistName ?? "")
            .font(.subheadline)
        
        HStack (spacing: 20) {
            Button("Play last", systemImage: "backward.fill", action: audioPlayerViewModel.skipBackwards)
                .labelStyle(.iconOnly).imageScale(.large)
            
            Button("Play or pause", systemImage: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill", action:audioPlayerViewModel.playOrPause
            ).labelStyle(.iconOnly)
                .imageScale(.large)
            Button("Play next", systemImage: "forward.fill", action: audioPlayerViewModel.skipForwards).labelStyle(.iconOnly)
                .imageScale(.large)
            Button(action: {
                song.liked.toggle()
                print("Current \(song.name) liked status: \(song.liked)")
            }) {
                ZStack {
                    // Create the heart with a green border and transparent background
                    Image(systemName: song.liked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 20, height: 20)  // Set the size of the heart
                        .foregroundColor(song.liked ? .green : .clear)  // Green if liked, transparent if not
                    
                    Image(systemName: "heart")      // TODO: fix this transparent heart
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.clear)
                        .overlay(
                            Image(systemName: "heart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.clear)
                                .border(Color.green, width: 0.5)  // Add green border to the heart
                        )
                }
            }
        }.padding(10)
        
        VStack{
            HStack{
                Slider(value: $audioPlayerViewModel.currentTime, in: (0...audioPlayerViewModel.duration), onEditingChanged: { editing in
                    if !editing {
                        audioPlayerViewModel.isScrubbing=false
                        audioPlayerViewModel.scrubTo(newTime: audioPlayerViewModel.currentTime)
                    } else {
                        audioPlayerViewModel.isScrubbing=true
                    }
                })
                Text(String(format: "%02d:%02d", ((Int)((audioPlayerViewModel.currentTime))) / 60, ((Int)((audioPlayerViewModel.currentTime))) % 60)).font(.caption)
                Text("/")
                Text(String(format: "%02d:%02d", ((Int)((audioPlayerViewModel.duration))) / 60, 
                    ((Int)((audioPlayerViewModel.duration))) % 60)).font(.caption)
                
            }.padding()
            
            HStack{
                Slider(value: $audioPlayerViewModel.volume, in: (0...1.0), step:0.05, onEditingChanged:
                        {
                    editing in if !editing {
                        audioPlayerViewModel.volumeTo(newVolume: audioPlayerViewModel.volume)
                    }
                })
                Image(systemName:"speaker.wave.3.fill")
            }.padding()
        }.padding()
            .onAppear {
                if (startNew) {
                    audioPlayerViewModel.changeSong(song: song)
                }
            }
    }
  }
}
