//
//  SearchViewModel.swift
//  FlickrPhotosSearchDemo
//
//  Created by 張哲豪 on 2019/5/7.
//  Copyright © 2019 張哲豪. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewModel {

    //Output
    let searchValid: Observable<Bool>
    let pageValid: Observable<Bool>
    let everythingValid: Observable<Bool>
    
    init(searchText: Observable<String>, pageText: Observable<String>) {
        searchValid = searchText
            .map { $0.count >= minimalSearchLength }
            .share(replay: 1)
        
        pageValid = pageText
            .map { $0.isNumber }
            .share(replay: 1)
        
        everythingValid = Observable.combineLatest(searchValid, pageValid) {$0 && $1}.share(replay: 1)
    }
}
