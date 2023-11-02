//
//  IntunesAPIProtocol.swift
//  upwards-ios-challenge
//
//  Created by Timothy Smith on 11/2/23.
//

import Foundation

protocol ItunesAPIProtocol {
    func getTopAlbums(limit: Int, completion: @escaping (Result<AlbumFeed, Error>) -> ())
}
