//
//  Browse.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/7/25.
//

import MusicKit
import MusadoraKit

func searchCatalog(searchTerm: String) async throws
  -> MusicCatalogSearchResponse
{
  do {
    let result = try await MCatalog.search(
      for: searchTerm,
      types: [.songs],
      limit: 20
    )
    return result
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}

func fetchTopGenres() async throws -> MusicItemCollection<Genre> {
  do {
    let result = try await MCatalog.topGenres()
    return result
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}


func fetchGenreCharts() async throws -> [GenreChart] {
  do {
    let topGenres = try await fetchTopGenres()
    var genreCharts: [GenreChart] = []
    for genre in topGenres {
      let genreChart = try await MCatalog.charts(
        genre: genre,
        kinds: .dailyGlobalTop,
        types: .songs,
        limit: 15
      )
      let genreChartObj = GenreChart(genre: genre, chart: genreChart, songs: genreChart.songCharts.flatMap(\.items))
      genreCharts.append(genreChartObj)
    }
    return genreCharts
  } catch {
    throw AppleMusicError.unknown(reason: error.localizedDescription)
  }
}
