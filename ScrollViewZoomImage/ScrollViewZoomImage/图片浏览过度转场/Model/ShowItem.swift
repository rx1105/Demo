//
//  ShowItem.swift
//  ScrollViewZoomImage
//
//  Created by Ans on 2017/7/19.
//  Copyright © 2017年 Ans. All rights reserved.
//

import UIKit

class ShowItem: NSObject {
//    var q_pic_url : String = ""
//    var z_pic_url : String = ""
    var imageName: String = ""
    var showBigImage: Bool = false
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(#function, key)
    }
}
