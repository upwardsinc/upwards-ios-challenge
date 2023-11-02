//
//  MyFileManagerProtocol.swift
//  upwards-ios-challenge
//
//  Created by Timothy Smith on 11/2/23.
//

import Foundation

protocol MyFileManagerProtocol {
    func readData(atPath path: String) -> Data?
}
