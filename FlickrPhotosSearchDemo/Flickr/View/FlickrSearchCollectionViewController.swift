//
//  FlickrSearchCollectionViewController.swift
//  FlickrPhotosSearchDemo
//
//  Created by 張哲豪 on 2019/4/10.
//  Copyright © 2019 張哲豪. All rights reserved.
//

import UIKit

import UIKit
import Kingfisher
import RxSwift

private let reuseIdentifier = "Cell"



class FlickrSearchCollectionViewController: UICollectionViewController {
    
    var disposeBag = DisposeBag()
    var searchText = ""
    var searchPage = 100
    var viewModel: FlickrViewModel = FlickrViewModel.sharedInstance
    var photos = [Photo]() {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = (view.bounds.width - 10) / 2
        layout?.itemSize = CGSize(width: width, height: width + 80)
        
        self.setViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "搜尋結果 \(searchText)"
    }
    func setViewModel() {
        viewModel.setupSearchInfo(searchText: searchText, searchPage: searchPage)
        viewModel.searchPhotos.asObservable()
            .subscribe { (event) in
                if let nextValue = event.element {
                    self.photos = nextValue
                }
            }.disposed(by: disposeBag)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        // Configure the cell
        let photo = photos[indexPath.item]
        cell.titleLabel.text = photo.title
        cell.photoImageView.image = nil
        cell.photoImageView.kf.setImage(with: photo.imageUrl)
        cell.starButton.isSelected = viewModel.isFavorite(photo: photo)
        cell.starButton.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        self.viewModel.favoriteTap(photo: photo)
    }
    
    @objc func btnAction(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.collectionView as UIView)
        let indexPath: IndexPath! = self.collectionView.indexPathForItem(at: point)
        print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        
        let photo = photos[indexPath.item]
        self.viewModel.favoriteTap(photo: photo)
    }
}
