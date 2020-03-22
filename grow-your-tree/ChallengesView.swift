//
//  ChallengesView.swift
//  grow-your-tree
//
//  Created by Tim Hotfilter on 21.03.20.
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation
import UIKit


class ChallengesView : UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collection: UICollectionView!
    
    let cellIds = ["Dinner", "Local", "Quiz"]
    let cellSizes = Array( repeatElement(CGSize(width:175, height:200), count: 3))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collection.dequeueReusableCell(withReuseIdentifier: cellIds[indexPath.row], for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellIds.count
    }
}
