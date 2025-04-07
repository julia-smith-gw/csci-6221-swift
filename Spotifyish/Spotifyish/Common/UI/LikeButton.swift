import MusicKit
//
//  LikeButton.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/6/25.
//
import SwiftUI

//https://stackoverflow.com/questions/56550713/how-can-i-run-an-action-when-a-state-changes

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
        } else {
          await likedViewModel.removeSongFromLiked(song: song)
        }
      }
    ).labelStyle(.iconOnly)
      .imageScale(.large)
      .onAppear {
        self.isSongLiked = self.likedViewModel.getIsSongLiked(song: song)
      }.onChange(
        of: likedViewModel.songsMetadata,
      { self.isSongLiked = self.likedViewModel.getIsSongLiked(song: song) }
      )
  }

  var body: some View {
    buttonView
  }
}
