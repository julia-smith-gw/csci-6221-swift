//
//  Moods.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import SwiftUI

struct Moods: View {
    let imageName: String
    let title: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()

            // Gradient for readability
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .clipped()

            // Title Text
            Text(title)
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding([.leading, .bottom], 16)
                .shadow(radius: 3)
        }
        .frame(height: 200)
        .cornerRadius(12)
        .clipped()
    }
}




#Preview {
    ZStack {
        Color.spotifyBlack.ignoresSafeArea()
        Moods(imageName: Constants.randomImage, title: "Sleep")
    }
}

