//
//  LibraryController.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/25/25.
//
import SwiftUI

struct LibraryController: View {
  // NOTE - In this section, I will create 3 functions related to the table2
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return songs.count // OR you can do songs.count
      
  }

  var body: some View {
    SongList(songs: songs)
  }

}


