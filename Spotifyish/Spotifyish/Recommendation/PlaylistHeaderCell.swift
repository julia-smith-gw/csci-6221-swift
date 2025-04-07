//
//  PlaylistHeaderCell.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import SwiftUI

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
                .frame(maxWidth: .infinity)
                .clipped()

            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: height)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .cornerRadius(12)
        .shadow(radius: 10)
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

