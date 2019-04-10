//
//  Extensiones.swift
//  FlickrPhotosSearchDemo
//
//  Created by 張哲豪 on 2019/4/10.
//  Copyright © 2019 張哲豪. All rights reserved.
//

import UIKit

extension String {
    
    var isNumber: Bool {
        let characters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && rangeOfCharacter(from: characters) == nil
    }
    
    var isValidNumber: Bool{
        let emailRegEx = "^[0-9]*"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
