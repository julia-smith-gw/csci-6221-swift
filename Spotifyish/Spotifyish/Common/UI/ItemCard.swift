//
//  ItemCard.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/7/25.
//

import SwiftUI
import MusicKit

struct ItemCard: View {
  var artwork: Artwork?
  var title: String
  
  var body: some View {
    VStack(alignment: .leading) {
      
      // NOTE - BY adding the alignment parameter here, you can change the placement of the text label
      ZStack(alignment: .bottomLeading) {

        if artwork
          != nil
        {
          AsyncImage(
            url: artwork?.url(width: 170, height: 170)
          ) { result in
            result.image?
              .resizable()
              .scaledToFill()
          }
          .frame(width: 170, height: 170)
          .foregroundStyle(.secondary)
        } else {
          Rectangle().fill(Color.gray)
            .frame(width: 170, height: 170)
            .foregroundStyle(.secondary)
            .overlay(content: {
              Text(title)
            })
          }
          
          // Label overlay
        Text(title)
                  .font(.headline)
                  .foregroundColor(.white)
                  
                  .padding(8)
                  .background(Color.gray.opacity(0.75))
                  .cornerRadius(10)
                  .padding([.leading, .bottom], 10)
          
      }.clipped().cornerRadius(20).shadow(radius:10).padding(20)
  
    }
  }
}
