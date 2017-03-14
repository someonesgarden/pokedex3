//
//  customSegmentedControl.swift
//  Pokedex3
//
//  Created by USER on 2017/03/14.
//  Copyright © 2017年 Someonesgarden. All rights reserved.
//

import UIKit

class customSegmentedControl: UISegmentedControl {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)

        layer.cornerRadius = -2.0
        layer.borderWidth = 0.0
        layer.masksToBounds = true
    }

}
