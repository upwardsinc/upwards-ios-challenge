//
//  TopAlbumsViewModel.swift
//  upwards-ios-challenge
//
//  Created by Timothy Smith on 10/31/23.
//

import Foundation

class TopAlbumsViewModel {
    private let iTunesAPI: ItunesAPIProtocol
    private let myFileManager: MyFileManagerProtocol
    var albums = [Album]()
    
    init(iTunesAPI: ItunesAPIProtocol, myFileManager: MyFileManagerProtocol) {
        self.iTunesAPI = iTunesAPI
        self.myFileManager = myFileManager
    }
    
    func loadTopAlbums(completion: @escaping (Result<[Album], Error>) -> ()) {
        iTunesAPI.getTopAlbums(limit: 10) { [weak self] res in
            switch res {
            case .success(let data):
                self?.albums = data.feed.results
                completion(.success(data.feed.results))
            case .failure(let err):
                debugPrint(err)
                completion(.failure(err))
            }
        }
    }
    
    func loadAlbumArtwork(completion: @escaping(Result<[Album], Error>) -> ()) {
        for (index, album) in albums.enumerated() {
            if album.artworkUrl100 == nil { continue }
            let albumData = myFileManager.readData(atPath: album.artworkUrl100!)
            guard let albumData = albumData else { continue }
            albums[index].artworkData = albumData
        }
        completion(.success(self.albums))
    }
    
    func checkAlbumReleaseDateWithin30Days(albumDate: Date?) -> Bool {
        guard let albumDate = albumDate else {
            return false
        }
        let currentDate = Date()
        let past30DaysDate = Calendar.current.date(byAdding: .day, value: -30, to: currentDate)
        guard let past30DaysDate = past30DaysDate else { return false }
        let dateRange = past30DaysDate...currentDate
        let albumReleasedPast30Days = dateRange.contains(albumDate) ? true : false
        
        return albumReleasedPast30Days
    }
}
