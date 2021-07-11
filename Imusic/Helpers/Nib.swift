//
//  Nib.swift
//  Imusic
//
//  Created by Роман Елфимов on 11.07.2021.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
    }
}
