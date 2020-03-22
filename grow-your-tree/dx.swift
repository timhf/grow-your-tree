//
//  Level.swift
//  grow-your-tree
//
//  Created by Tim Hotfilter on 22.03.20.
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation
import UIKit


struct Level {
    var score_value : Int = 0
    let level_limits = [100,300,500,1000,2000,3000,5000,10000,20000,30000]
    
    var level : Int {
        get {
            for (idx, limit) in level_limits.enumerated() {
                if score_value < limit {
                    return idx
                }
            }
            return 0
        }
    }
    
    init(score : Int) {
        self.score_value = score
    }
    
    var treeImage : UIImage {
        get{
            let path = String(format: "Level%d", (self.level + 1)) //Fixme: clean
            let bundlePath = Bundle.main.path(forResource: path, ofType: "png")
            let image = UIImage(contentsOfFile: bundlePath!)!
            return image
        }
    }
}

