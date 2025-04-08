import Foundation
import MediaPlayer
import MusicKit
import SwiftUI


let formatter = DateComponentsFormatter()

//https://medium.com/@jpmtech/add-swipe-to-dismiss-to-any-view-using-swiftui-262fb53f8bf5
struct SwipeToDismiss: ViewModifier {
  @Binding var isPresented: Bool
  @State var verticalDragAmount = 0.0
  @State var opacityAmount = 1.0

  func body(content: Content) -> some View {
    content
      .offset(y: verticalDragAmount)
      .opacity(opacityAmount)
      .gesture(
        DragGesture()
          .onChanged { drag in
            withAnimation {
              verticalDragAmount = drag.translation.height
              if drag.translation.height < 100 {
                // make it more transparent the farther down it goes
                opacityAmount = (100 - verticalDragAmount) / 100
              } else {
                opacityAmount = 0
              }
            }
          }
          .onEnded { drag in
            withAnimation {
              if drag.translation.height > 100 {
                isPresented = false
                opacityAmount = 0
              } else {
                verticalDragAmount = 0
                opacityAmount = 1
              }
            }
          }
      )
  }
}

extension View {
  func swipeToDismiss(_ isPresented: Binding<Bool>) -> some View {
    modifier(SwipeToDismiss(isPresented: isPresented))
  }
}

//https://medium.com/@jongary/binding-a-swiftui-slider-to-an-avplayers-time-a9660526170a
//https://medium.com/@tokusha.aa/mastering-swiftui-and-avplayer-integration-a-complete-guide-to-timecodes-and-advanced-playback-6ef9a88b3b8d
//https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/2-understanding-observableobject-observedobject
//https://m-mois.medium.com/formatting-time-intervals-and-durations-in-swift-6aace4347373
//https://stackoverflow.com/questions/77829110/how-define-a-size-for-image-with-asyncimage
struct PlayerView: View {
  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared
  @ObservedObject var globalScreenManager = GlobalScreenManager.shared
  @ObservedObject var libraryViewModel = LibraryViewModel.shared

  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      Spacer()

      if (audioPlayerViewModel.song?.artwork?.url != nil) {
        AsyncImage(
          url: audioPlayerViewModel.song?.artwork?.url(width: 200, height: 200)
        ) { result in
          result.image?
            .resizable()
            .scaledToFill()
        }
        .frame(width: 200, height: 200)
        .foregroundStyle(.secondary)
      } else {
        Rectangle()
          .fill(Color.secondary)
          .foregroundStyle(.secondary)
          .frame(width: 200, height: 200)
      }
   
      Spacer()

      Text(audioPlayerViewModel.song?.title ?? "")
        .font(.title)
        .fontWeight(.bold)
        .lineLimit(nil)
        .multilineTextAlignment(.center)

      Text(audioPlayerViewModel.song?.artistName ?? "")
        .font(.subheadline)

      HStack(spacing: 20) {
        AsyncButton(
          systemImageName: "backward.fill",
          action: audioPlayerViewModel.skipBackwards
        )
        .labelStyle(.iconOnly).imageScale(.large)

        AsyncButton(
          systemImageName: audioPlayerViewModel.isPlaying
            ? "pause.fill" : "play.fill",
          action: audioPlayerViewModel.playOrPause
        ).labelStyle(.iconOnly)
          .imageScale(.large)

        AsyncButton(
          systemImageName: "forward.fill",
          action: audioPlayerViewModel.skipForwards
        ).labelStyle(.iconOnly)
          .imageScale(.large)

        if audioPlayerViewModel.song != nil {
          if audioPlayerViewModel.fromLibrary {
            LikeButton(song: audioPlayerViewModel.song!).padding(.leading, 5)
          } else {
            AddSongToLibraryButton(song: audioPlayerViewModel.song!).padding(
              .leading,
              5
            ).environmentObject(libraryViewModel)
          }
        }
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

      }.padding()
      Spacer()
    }.swipeToDismiss($globalScreenManager.showFullscreenPlayer)
      .frame(height: UIScreen.main.bounds.height)
  }

}
