//
//  RecommendationScreen.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//


import SwiftUI

struct RecommendationScreen: View {
    @State private var moods: [Mood] = []

    var body: some View {
        NavigationStack {
            ZStack {
                Color.spotifyBlack.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 12, pinnedViews: [.sectionHeaders]) {
                        Section {
                            VStack(spacing: 16) {
                                ForEach(moods) { mood in
                                    NavigationLink(destination: PlaylistView(mood: mood)) {
                                        Moods(imageName: mood.image, title: mood.title)
                                            .frame(height: 200)
                                            .cornerRadius(12)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        } header: {
                            header
                        }
                    }
                    .padding(.top, 8)
                }
                .scrollIndicators(.hidden)
                .clipped()
            }
            .task {
                await fetchMoods()
            }
        }
    }

    private func fetchMoods() async {
        do {
            moods = try await DatabaseHelper().getMoods()
        } catch {
            // Fallback sample data using Mood (not AppMood!)
            moods = [
                Mood(id: 1, title: "Sleep", description: "Calm tracks for better sleep", image: "Sleep", category: "Relaxation"),
                Mood(id: 2, title: "Study", description: "Focus-enhancing instrumental", image: "Study", category: "Concentration"),
                Mood(id: 3, title: "Relax", description: "Chill and lo-fi vibes", image: "Relax", category: "Mood"),
                Mood(id: 4, title: "Pop", description: "Fresh pop hits", image: "Pop", category: "Genre"),
                Mood(id: 5, title: "Indie", description: "Handpicked indie gems", image: "Indie", category: "Alternative")
            ]
        }
    }

    private var header: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()
                .background(.spotifyBlack)
            Text("Recommendations For You")
                .font(.title2.bold())
                .foregroundColor(.spotifyWhite)
                .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}



#Preview {
    RecommendationScreen()
}
