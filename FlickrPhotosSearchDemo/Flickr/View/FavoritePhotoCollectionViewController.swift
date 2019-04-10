//
//  FavoritePhotoCollectionViewController.swift
//  FlickrPhotosSearchDemo
//
//  Created by 張哲豪 on 2019/4/10.
//  Copyright © 2019 張哲豪. All rights reserved.
//

import UIKit

class FavoritePhotoCollectionViewController: FlickrSearchCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "我的最愛"
    }
    override func setViewModel() {
        
        viewModel.favoritePhotos.asObservable()
            .subscribe { (event) in
                if let nextValue = event.element {
                    self.photos = nextValue
                }
            }.disposed(by: disposeBag)
    }
}
