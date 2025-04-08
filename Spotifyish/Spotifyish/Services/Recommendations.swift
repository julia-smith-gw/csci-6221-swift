//
//  Recommendations.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/7/25.
//

import MusadoraKit
import MusicKit
import SwiftUI

//https://hyunleemia.medium.com/utilising-musickit-for-ios-development-0dbb74f6b6b0

func fetchRecommendations() async throws -> MusicPersonalRecommendationsResponse
{
  let request = MusicPersonalRecommendationsRequest()
  do {
    let response = try await request.response()
    var musicPersonalRecommendations = MusicPersonalRecommendationsRequest()
    musicPersonalRecommendations.limit = 5
    return response
  } catch {
    throw error
  }
}

func fetchRecommendationPlaylistSongs(id: MusicItemID) async throws -> [Song] {

  guard
    let url = URL(
      string:
        "https://api.music.apple.com/v1/catalog/US/playlists/\(id)/tracks"
    )
  else {
    throw
      AppleMusicError.unknown(reason: "Invalid URL")
  }

  do {
    let fullPlaylistReq = MusicDataRequest(
      urlRequest: URLRequest(
        url: url
      )
    )
    let fullPlaylistResponse = try await fullPlaylistReq.response()
    let decodedSongs = try JSONDecoder().decode(
      MusicItemCollection<Song>.self,
      from: fullPlaylistResponse.data
    )
    return Array(decodedSongs)
  } catch {
    throw error
  }

}
