//
//  FlickrManager.swift
//  FlickrPhotosSearchDemo
//
//  Created by 張哲豪 on 2019/4/10.
//  Copyright © 2019 張哲豪. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FlickrViewModel: NSObject {
    
    private var disposeBag = DisposeBag()
    
    //Input
    public let searchTextSubject = PublishSubject<String>()
    public let searchPageSubject = PublishSubject<Int>()
    
    //Output
    public let searchPhotos = BehaviorRelay<[Photo]>(value: [])
    public let favoritePhotos = BehaviorRelay<[Photo]>(value: [])

    var favoritePhotosDict = [String: Data]() {
        didSet{
            let favoriteData = Array(favoritePhotosDict.values)
            let photos = favoriteData.map { (data) -> Photo in
                let photo = try? JSONDecoder().decode(Photo.self, from: data)
                return photo!
            }
            self.favoritePhotos.accept(photos)
        }
    }
    
    static let sharedInstance = FlickrViewModel()
    private override init() {
        super.init()
        self.subscribeInput()
        self.readFavoritePhotos()
    }
    
    func subscribeInput()  {
        let searchInfo = Observable.combineLatest(searchTextSubject.asObserver(), searchPageSubject.asObserver())
        searchInfo
            .debounce(0.1, scheduler: MainScheduler.instance) //防抖 時間內沒更新才觸發
            .subscribe { (event) in
                if let nextValue = event.element {
                    print(nextValue)
                    self.fetchSearchData(searchText: nextValue.0, searchPage: nextValue.1)
                }
            }.disposed(by: disposeBag)
    }
    
    func setupSearchInfo(searchText: String, searchPage: Int )  {
        searchTextSubject.onNext(searchText)
        searchPageSubject.onNext(searchPage)
    }
    
    func fetchSearchData(searchText: String, searchPage: Int) {
        let sendData = ["text": searchText, "per_page": "\(searchPage)"]
        APIManager.sendRequest(method: .get, api: .flickrPhotosSearch, sendData: sendData) { (Result) in
            switch Result {
            case .success(let data):
                if let searchData = SearchData.init(data: data) {
                    self.searchPhotos.accept(searchData.photos.photo)
                }
                break
            case .failure(let err):
                print("failure...", err)
                break
            }
            
        }
    }
}


//我的最愛相關
extension FlickrViewModel {
    
    func isFavorite(photo: Photo) -> Bool {
        return self.favoritePhotosDict[photo.id] != nil
    }
    
    func favoriteTap(photo: Photo) {
        if let _ = self.favoritePhotosDict[photo.id] {
            self.favoritePhotosDict.removeValue(forKey: photo.id)
        }else{
            if let data = try? JSONEncoder().encode(photo) {
                self.favoritePhotosDict[photo.id] = data
            }
        }
        UserDefaults.standard.set(favoritePhotosDict, forKey: "favorite")
        self.searchPhotos.accept(searchPhotos.value) // reload 用
    }
    
    //讀
    func readFavoritePhotos()  {
        if let favoriteDict = UserDefaults.standard.value(forKey: "favorite") as? [String: Data]{
            self.favoritePhotosDict = favoriteDict
        }
    }
}
