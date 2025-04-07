//
//  RecommendationScreen.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//


import SwiftUI

struct RecommendationScreen: View {
    @State private var moods: [Mood] = []
    
    var shadowColor: Color = .white.opacity(0.8)

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 12, pinnedViews: [.sectionHeaders]) {
                        Section {
                            VStack(spacing: 16) {
                                ForEach(moods) { mood in
                                    NavigationLink(destination: PlaylistView(mood: mood)) {
                                        Moods(imageName: mood.image, title: mood.title)
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
            // Fallback sample data using Mood
            moods = [
                Mood(id: 1, title: "Country", description: "Heartfelt stories with acoustic charm.", image: "Country", category: "Country"),
                Mood(id: 2, title: "Dance", description: "Energetic, rhythmic, upbeat, vibrant, fun.", image: "Dance", category: "Party"),
                Mood(id: 3, title: "Rock", description: "Gritty, bold, energetic, rebellious, electric.", image: "Rock", category: "Mood"),
                Mood(id: 4, title: "Pop", description: "Fresh pop hits", image: "Pop", category: "Popular"),
                Mood(id: 5, title: "Jazz", description: "Handpicked jazz gems", image: "Jazz", category: "Alternative")
            ]
        }
    }

    private var header: some View {
        ZStack {
            Color.white.ignoresSafeArea()
                .background(.white)
            Text("Recommendations For You")
                .font(.title2.bold())
                .foregroundColor(.spotifyBlack)
                .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    RecommendationScreen()
}
