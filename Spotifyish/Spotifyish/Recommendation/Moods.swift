//
//  Moods.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import SwiftUI

struct Moods: View {
    var imageName: String = Constants.randomImage
    var title: String = "Sleep"
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ImageLoaderView(urlString: imageName)
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(Color.spotifyGray.opacity(0.3))
                .clipped()
            
            // Gradient overlay
            LinearGradient(
                colors: [Color.black.opacity(0.6), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 80)
            .frame(maxWidth: .infinity, alignment: .bottom)
            .clipped()

            // Title text
            Text(title)
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
        .frame(height: 200)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}



#Preview {
    ZStack {
        Color.spotifyBlack.ignoresSafeArea()
        Moods(imageName: Constants.randomImage, title: "Sleep")
    }
}

