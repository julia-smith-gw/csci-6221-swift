//  Song.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/25/25.
//

// NOTE - Here, we are defining the fields of a Song object (You will get rid of this if we use the API)
struct Song: Hashable {
    let name: String
    let Genre: String
    let artistName: String
    let imageName: String
    let audioFileName: String
    var liked: Bool = false
    var id: String {
        self.name
    }
}

