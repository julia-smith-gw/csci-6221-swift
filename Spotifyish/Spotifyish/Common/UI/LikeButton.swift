import MusicKit
//
//  LikeButton.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/6/25.
//
import SwiftUI

struct LikeButton: View {
  @ObservedObject var likedViewModel = LikedViewModel.shared
  @State var isSongLiked: Bool = false
  var song: Song

  private var buttonView: some View {
    AsyncButton(
      systemImageName: isSongLiked ? "heart.fill" : "heart",
      action: {
        if !isSongLiked {
          await likedViewModel.addSongToLiked(song: song)
          self.isSongLiked.toggle()
        } else {
          await likedViewModel.removeSongFromLiked(song: song)
          self.isSongLiked.toggle()
        }
      }
    ).labelStyle(.iconOnly)
      .imageScale(.large)
      .onAppear {
        self.isSongLiked = self.likedViewModel.getIsSongLiked(song: song)
      }
  }

  var body: some View {
    buttonView
  }
}
