
//  SongCard.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/25/25.
//
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-load-a-remote-image-from-a-url
// Source: https://www.youtube.com/watch?v=NvE3SaGGurQ

import SwiftUI
import MusicKit

struct SongCard: View {
  let song: MusicKit.Song
  var body: some View {
      HStack {
        
        AsyncImage(url: song.artwork?.url(width: 90, height: 90)) { result in
            result.image?
                .resizable()
                .scaledToFill()
            }
            .frame(width: 90, height: 90)
            .foregroundStyle(.secondary)

        Spacer()
        VStack( alignment: .trailing, spacing: 1) {
          Text(self.song.title)
            .font(.headline.bold())
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.trailing)
            .lineLimit(nil)

          Text(self.song.artistName)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.trailing)
            .lineLimit(nil)
  
        }.frame(maxWidth: UIScreen.main.bounds.size.width - 120,  alignment: .trailing)
          .padding(.leading, 35)
      }.frame(maxWidth: .infinity, minHeight:90, maxHeight: 300)
  }
}
