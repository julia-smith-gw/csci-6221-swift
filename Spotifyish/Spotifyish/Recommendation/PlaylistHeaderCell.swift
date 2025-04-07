//
//  PlaylistHeaderCell.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import SwiftUI

struct PlaylistHeaderCell: View {
    let height: CGFloat
    let title: String
    let subtitle: String
    let imageName: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: height)
                .clipped()

            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: height)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .shadow(radius: 4)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .frame(height: height)
    }
}



#Preview {
    let mood = Mood.mock
    
    return PlaylistHeaderCell(
        height: 250,
        title: mood.title,
        subtitle: mood.description,
        imageName: mood.image
    )
}

