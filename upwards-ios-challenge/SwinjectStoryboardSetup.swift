//
//  SwinjectStoryboardSetup.swift
//  upwards-ios-challenge
//
//  Created by Timothy Smith on 10/31/23.
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        //REGISTER UTILITIES
        defaultContainer.register(MyFileManagerProtocol.self) { r in
            MyFileManager()
        }
        
        // REGISTER SERVICES
        defaultContainer.register(Networking.self) { r in
            Network(sessionConfig: .default)
        }
        defaultContainer.register(ITunesAPI.self) { r in
            ITunesAPI(network: r.resolve(Networking.self)!)
        }
        
        // REGISTER VIEW MODELS
        defaultContainer.register(TopAlbumsViewModel.self) { r in
            TopAlbumsViewModel(iTunesAPI: r.resolve(ITunesAPI.self)!, myFileManager: r.resolve(MyFileManagerProtocol.self)!)
        }
        
        // REGISTER VIEW CONTROLLERS
        defaultContainer.storyboardInitCompleted(TopAlbumsViewController.self) { r, c in
            c.topAlbumsVM = r.resolve(TopAlbumsViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(FilterAlbumsViewController.self) { r, c in }
        defaultContainer.storyboardInitCompleted(NavigationViewController.self) { r, c in }
    }
}
