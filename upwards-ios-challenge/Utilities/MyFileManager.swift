//
//  ReadData.swift
//  upwards-ios-challenge
//
//  Created by Timothy Smith on 11/2/23.
//

import Foundation
class MyFileManager: MyFileManagerProtocol {
    
    func readData(atPath path: String) -> Data? {
        let url = URL(string: path)
        guard let url = url else { return nil }
        
        return try? Data(contentsOf: url)
    }
}
