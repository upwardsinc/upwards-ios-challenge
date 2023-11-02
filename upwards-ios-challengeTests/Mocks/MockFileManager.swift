//
//  MockFileManager.swift
//  upwards-ios-challengeTests
//
//  Created by Timothy Smith on 11/2/23.
//

import Foundation
@testable import upwards_ios_challenge

class MockFileManager: MyFileManagerProtocol {
    func readData(atPath path: String) -> Data? {
        return Data()
    }
}
