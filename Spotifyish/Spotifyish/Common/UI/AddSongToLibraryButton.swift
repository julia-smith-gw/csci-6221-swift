//
//  AddSongToLibraryButton.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/6/25.
//

import SwiftUI
import MusicKit

struct AddSongToLibraryButton: View {
  var song: Song?
  @State var isSongInLibrary = false
  @ObservedObject var libraryViewModel = LibraryViewModel.shared

  private var buttonView: some View {
    AsyncButton(
      systemImageName: !isSongInLibrary ? "bookmark": "bookmark.fill",
      action: {
        if !isSongInLibrary && self.song != nil {
          await libraryViewModel.addSongToLibrary(song: song!)
          self.isSongInLibrary.toggle()
        }
      }
    ).labelStyle(.iconOnly)
      .imageScale(.large)
      .disabled(isSongInLibrary)
      .onAppear {
        if (song == nil) { return }
        self.isSongInLibrary = self.libraryViewModel.getSongIsInLibrary(song: song!)
      }
  }

  var body: some View {
    buttonView
  }
}
