//
//  LiveCollectionViewController.swift
//  my_demo
//
//  Created by Class on 2022/4/7.
//

import UIKit

class LiveCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let nib = UINib(nibName: "myCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "myCollectionViewCell")
        
//        jsonobject = jasonfilecontent()

    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 33
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(myCollectionViewCell.self)", for: indexPath) as! myCollectionViewCell
        
        // Configure the cell
        cell.LiveImageView.image = UIImage(named: "pic3")

        return cell
    }
    

}
    
