//
//  upwards_ios_challengeTests.swift
//  upwards-ios-challengeTests
//
//  Created by Timothy Smith on 11/1/23.
//

import XCTest
import Foundation
@testable import upwards_ios_challenge

final class TopAlbumsViewModelTests: XCTestCase {
    var topAlbumsVM: TopAlbumsViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let mockNetwork = MockNetwork()
        let mockFileManager = MockFileManager()
        topAlbumsVM = TopAlbumsViewModel(iTunesAPI: ITunesAPI(network: mockNetwork), myFileManager: mockFileManager)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        topAlbumsVM = nil
    }
    
    func testLoadTopAlbumsSuccess() throws {
        class MockItunesAPI: ItunesAPIProtocol {
            func getTopAlbums(limit: Int, completion: @escaping (Result<upwards_ios_challenge.AlbumFeed, Error>) -> ()) {
                let albums = [Album(id: "1", name: "Test Album 1", artistName: "Test Aritst 1", releaseDate: Date()),
                              Album(id: "2", name: "Test Album 2", artistName: "Test Aritst 2", releaseDate: Date()),
                              Album(id: "3", name: "Test Album 3", artistName: "Test Aritst 3", releaseDate: Date())]
                let albumFeed = AlbumFeed(feed: AlbumFeed.Feed(results: albums))
                completion(Result { albumFeed })
            }
        }
        topAlbumsVM = TopAlbumsViewModel(iTunesAPI: MockItunesAPI(), myFileManager: MockFileManager())
        topAlbumsVM?.loadTopAlbums(completion: { res in
            switch res {
            case .success(let data):
                XCTAssertEqual(data.count, 3)
            case .failure(let err):
                XCTFail(err.localizedDescription)
            }
        })
    }
    
    func testLoadTopAlbumsFailure() throws {
        class MockItunesAPI: ItunesAPIProtocol {
            func getTopAlbums(limit: Int, completion: @escaping (Result<upwards_ios_challenge.AlbumFeed, Error>) -> ()) {
                completion(.failure(APIErrors.custom("Error")))
            }
        }
        topAlbumsVM = TopAlbumsViewModel(iTunesAPI: MockItunesAPI(), myFileManager: MockFileManager())
        topAlbumsVM?.loadTopAlbums(completion: { res in
            switch res {
            case .success(_):
                XCTFail("Unexpected success")
            case .failure(let err):
                XCTAssert(err is APIErrors)
            }
        })
    }
    
    func testLoadAlbumArtworkSuccess() throws {
        let albums = [Album(id: "1", name: "Test Album 1", artworkUrl100: "https://test.com", artistName: "Test Aritst 1", releaseDate: Date()),
                      Album(id: "2", name: "Test Album 2", artworkUrl100: "https://test.com", artistName: "Test Aritst 2", releaseDate: Date()),
                      Album(id: "3", name: "Test Album 3", artworkUrl100: "https://test.com", artistName: "Test Aritst 3", releaseDate: Date())]
        topAlbumsVM?.albums = albums
        topAlbumsVM?.loadAlbumArtwork(completion: { res in
            switch res {
            case .success(let data):
                XCTAssertEqual(data.count, 3)
                XCTAssertNotNil(data[0].artworkData)
                XCTAssertNotNil(data[1].artworkData)
                XCTAssertNotNil(data[2].artworkData)
            case .failure(let err):
                XCTFail(err.localizedDescription)
            }
        })
    }
    
    func testLoadAlbumArtworkNoArtworkURL() throws {
        let albums = [Album(id: "1", name: "Test Album 1", artistName: "Test Aritst 1", releaseDate: Date())]
        topAlbumsVM?.albums = albums
        topAlbumsVM?.loadAlbumArtwork(completion: { res in
            switch res {
            case .success(let data):
                XCTAssertEqual(data.count, 1)
                XCTAssertNil(data[0].artworkData)
            case .failure(let err):
                XCTFail(err.localizedDescription)
            }
        })
    }
    
    func testLoadAlbumArtworkNoDataReturned() throws {
        class MockFileManagerNoData: MockFileManager {
            override func readData(atPath path: String) -> Data? {
                return nil
            }
        }
        topAlbumsVM = TopAlbumsViewModel(iTunesAPI: ITunesAPI(network: MockNetwork()), myFileManager: MockFileManagerNoData())
        let albums = [Album(id: "1", name: "Test Album 1", artworkUrl100: "https://test.com", artistName: "Test Aritst 1", releaseDate: Date())]
        topAlbumsVM?.albums = albums
        topAlbumsVM?.loadAlbumArtwork(completion: { res in
            switch res {
            case .success(let data):
                XCTAssertEqual(data.count, 1)
                XCTAssertNil(data[0].artworkData)
            case .failure(let err):
                XCTFail(err.localizedDescription)
            }
        })
    }
    
    func testCheckAlbumReleaseDateWithin30DaysTrue() throws {
        let albumDate = Calendar.current.date(byAdding: .day, value: -15, to: Date.now)
        let result = topAlbumsVM?.checkAlbumReleaseDateWithin30Days(albumDate: albumDate)
        XCTAssertNotNil(result)
        XCTAssertTrue(result!)
    }
    
    func testCheckAlbumReleaseDateWithin30DaysFalse() throws {
        let albumDate = Calendar.current.date(byAdding: .day, value: -45, to: Date.now)
        let result = topAlbumsVM?.checkAlbumReleaseDateWithin30Days(albumDate: albumDate)
        XCTAssertNotNil(result)
        XCTAssertFalse(result!)
    }
    
    func testCheckAlbumReleaseDateWithin30DaysNilDate() throws {
        let result = topAlbumsVM?.checkAlbumReleaseDateWithin30Days(albumDate: nil)
        XCTAssertNotNil(result)
        XCTAssertFalse(result!)
    }
    
}
