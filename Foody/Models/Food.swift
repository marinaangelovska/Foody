//
//  Food.swift
//  Foody
//
//  Created by Marina Angelovska on 4/30/18.
//  Copyright © 2018 Marina Angelovska. All rights reserved.
//

import Foundation
import UIKit

class Food {
    var title: String = ""
    var owner: String = ""
    var image: UIImage? = nil
    var url: String = ""
    
    init(title: String, owner: String, image: UIImage, url: String) {
        self.title = title
        self.owner = owner
        self.image = image
        self.url = url
    }
}

