//
//  SongCardList.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/25/25.
//
import SwiftUI

struct SongList: View {
  let songs: [Song]

  var body: some View {
    NavigationStack {
      List(songs, id: \.name) { song in
        SongCard(song: song)
      }
    }
  }
}
