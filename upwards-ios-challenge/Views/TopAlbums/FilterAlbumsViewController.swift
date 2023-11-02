//
//  FilterAlbumsViewController.swift
//  upwards-ios-challenge
//
//  Created by Timothy Smith on 11/1/23.
//

import UIKit

class FilterAlbumsViewController: UIViewController {
    
    weak var filterDelegate: FilterData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sortByAlbum(_ sender: Any) {
        filterDelegate?.filterType(filterType: .Album)
        dismiss(animated: true)
    }
    
    @IBAction func sortByArtist(_ sender: Any) {
        filterDelegate?.filterType(filterType: .Artist)
        dismiss(animated: true)
    }
}

enum FilterType {
    case Album
    case Artist
}

protocol FilterData: AnyObject {
    func filterType(filterType: FilterType)
}
