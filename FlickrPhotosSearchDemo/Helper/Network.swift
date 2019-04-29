//
//  Network.swift
//  FlickrDeno
//
//  Created by 張哲豪 on 2019/4/9.
//  Copyright © 2019 張哲豪. All rights reserved.
//

import Foundation
import Alamofire

class APIManager: NSObject {

    static let baseUrl = "https://api.flickr.com/services/rest/"
    static let flickrArgument = ["api_key": "5310c66c51415bb2d35f1412a6c704f3", "format": "json", "nojsoncallback": "1"]
    
    enum API: String{
        case flickrPhotosSearch = "flickr.photos.search"
    }

    
    static func sendRequest(method: Alamofire.HTTPMethod ,api: API, sendData: [String : String]?, completion:@escaping (Result<Data>) -> ()) {
        
        var parameters = flickrArgument
        parameters["method"] = api.rawValue
        if let sendData = sendData {
            parameters.merge(sendData, uniquingKeysWith: min)
        }
        
        
        let request = Alamofire.request(baseUrl, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        request.responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let value = response.data{
                    completion(.success(value))
                }else{
                    //
                }
                break
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
}
