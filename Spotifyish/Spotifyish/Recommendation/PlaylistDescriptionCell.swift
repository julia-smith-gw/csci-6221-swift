//
//  PlaylistDescriptionCell.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import SwiftUI

struct PlaylistDescriptionCell: View {
    
    var descriptionText: String
    var userName: String
    var subheadline: String
    var onAddToPlaylistPressed: (() -> Void)?
    var onDownloadPressed: (() -> Void)?
    var onSharedPressed: (() -> Void)?
    var onEllipsisPressed: (() -> Void)?
    var onShufflePressed: (() -> Void)?
    var onPlayPressed: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(descriptionText)
                .foregroundStyle(.spotifyGray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            madeForYouSection
            
            Text(subheadline)
                .foregroundColor(.spotifyGray)
            
            buttonsRow
        }
        .font(.callout)
        .fontWeight(.medium)
    }
    
    private var madeForYouSection: some View {
        HStack(spacing: 8) {
            Image(systemName: "music.note")
                .font(.title3)
                .foregroundStyle(.spotifyGreen)
            
            
            Text("Made for " + userName)
                .bold()
                .foregroundStyle(.spotifyDarkGray)
                
        }
        
    }
    
    private var buttonsRow: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "plus.circle")
                    .padding(8)
                    .background(Color.spotifyDarkGray.opacity(0.001))
                    .onTapGesture {
                        onAddToPlaylistPressed?()
                    }
                Image(systemName: "arrow.down.circle")
                    .padding(8)
                    .background(Color.spotifyDarkGray.opacity(0.001))
                    .onTapGesture {
                        onDownloadPressed?()
                    }

                Image(systemName: "square.and.arrow.up")
                    .padding(8)
                    .background(Color.spotifyDarkGray.opacity(0.001))
                    .onTapGesture {
                        onSharedPressed?()
                    }
                Image(systemName: "ellipsis")
                    .padding(8)
                    .background(Color.spotifyDarkGray.opacity(0.001))
                    .onTapGesture {
                        onEllipsisPressed?()
                    }
            }
            .offset(x: -8)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 8) {
                Image(systemName: "shuffle")
                    .font(.system(size: 24))
                    .background(Color.spotifyDarkGray.opacity(0.001))
                    .onTapGesture {
                        onShufflePressed?()
                    }
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 46))
                    .background(Color.spotifyDarkGray.opacity(0.001))
                    .onTapGesture {
                        onPlayPressed?()
                    }
            }
            .foregroundStyle(.spotifyGreen)
        }
        .font(.title2)
        
    }
}


#Preview {
    PlaylistDescriptionCell(
        descriptionText: "A curated playlist for focus and deep work.",
        userName: "Alex",
        subheadline: "Concentration • 50 songs",
        onAddToPlaylistPressed: {
            print("Add to playlist tapped")
        },
        onDownloadPressed: {
            print("Download tapped")
        },
        onSharedPressed: {
            print("Share tapped")
        },
        onEllipsisPressed: {
            print("Ellipsis tapped")
        },
        onShufflePressed: {
            print("Shuffle tapped")
        },
        onPlayPressed: {
            print("Play tapped")
        }
    )
}
