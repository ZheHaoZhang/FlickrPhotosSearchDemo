//
//  SearchViewController.swift
//  FlickrPhotosSearchDemo
//
//  Created by 張哲豪 on 2019/4/10.
//  Copyright © 2019 張哲豪. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let minimalSearchLength = 1

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchValidOutlet: UILabel!
    @IBOutlet weak var pageTextField: UITextField!
    @IBOutlet weak var pageValidOutlet: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var disposeBag = DisposeBag()
    private var viewModel: SearchViewModel {
        return SearchViewModel.init(searchText: searchTextField.rx.text.orEmpty.asObservable(), pageText: pageTextField.rx.text.orEmpty.asObservable())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "搜尋輸入頁"
        self.setupRx()
    }
    func setupRx() {
        
        viewModel.searchValid
            .bind(to: searchValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.pageValid
            .debounce(1, scheduler: MainScheduler.instance) //防抖 時間內沒更新才觸發
            .subscribe({ (event) in
                self.pageValidOutlet.isHidden = event.element ?? false || self.pageTextField.text == ""
            }).disposed(by: disposeBag)
        
        viewModel.everythingValid.subscribe { (event) in
            let nextValue = event.element ?? false
            self.doneButton.isEnabled = nextValue
            self.doneButton.backgroundColor = nextValue ? UIColor.blue : UIColor.darkGray
            }.disposed(by: disposeBag)
        
        doneButton.rx.tap
            .subscribe(onNext: {
                print("button Tapped")
                self.goToFlickrTabBarController()
            })
            .disposed(by: disposeBag)
    }
    
    func goToFlickrTabBarController() {
        let storyboard = UIStoryboard(name: "Flickr", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "FlickrTabBarController") as! UITabBarController
        
        if let vc = tabBarController.viewControllers?.first as? FlickrSearchCollectionViewController {
            vc.searchText = self.searchTextField.text ?? "pizza"
            vc.searchPage = Int(self.pageTextField.text!) ?? 10
            self.navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
}
