//
//  TopAlbumViewController.swift
//  upwards-ios-challenge
//
//  Created by Timothy Smith on 10/31/23.
//

import UIKit
import Foundation

class TopAlbumsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate, FilterData {
    var topAlbumsVM: TopAlbumsViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Albums"
        loadData { success in
            if success {
                self.topAlbumsVM?.loadAlbumArtwork(completion: { result in
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topAlbumsVM!.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space = (flowLayout?.minimumInteritemSpacing ?? 0.0) + (flowLayout?.sectionInset.left ?? 0.0) + (flowLayout?.sectionInset.right ?? 0.0)
        let size = (collectionView.frame.size.width - space) / 2.0
        
        return CGSize(width: size, height: size + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! AlbumCardCollectionViewCell
        cell.albumTitle.text = topAlbumsVM?.albums[indexPath.row].name
        cell.albumArtist.text = topAlbumsVM?.albums[indexPath.row].artistName
        if topAlbumsVM?.albums[indexPath.row].artworkData != nil {
            cell.albumImageView.image = UIImage(data: topAlbumsVM!.albums[indexPath.row].artworkData!)
        }
        cell.layer.cornerRadius = 10
        cell.newBadge.isHidden = topAlbumsVM!.checkAlbumReleaseDateWithin30Days(albumDate: topAlbumsVM!.albums[indexPath.row].releaseDate) ? false : true
        
        return cell
    }
    
    private func loadData(completion: @escaping(Bool) ->()) {
        topAlbumsVM?.loadTopAlbums(completion: { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destination as! FilterAlbumsViewController
            popoverViewController.modalPresentationStyle = .popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.filterDelegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func filterType(filterType: FilterType) {
        topAlbumsVM?.albums.sort(by: { album1, album2 in
            if filterType == .Album {
                return album1.name.lowercased() < album2.name.lowercased()
            } else {
                return album1.artistName.lowercased() < album2.artistName.lowercased()
            }
        })
        collectionView.reloadData()
    }
    
}
