//
//  MockNetwork.swift
//  upwards-ios-challengeTests
//
//  Created by Timothy Smith on 11/1/23.
//

import Foundation
@testable import upwards_ios_challenge

class MockNetwork: Networking {
    func requestObject<T>(_ request: upwards_ios_challenge.Request, completion: @escaping (Result<T, Error>) -> ()) where T : Decodable {
        
    }
    
    func requestData(_ request: upwards_ios_challenge.Request, completion: @escaping (Result<Data, Error>) -> ()) {

    }
    
    
}
