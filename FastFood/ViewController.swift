//
//  ViewController.swift
//  FastFood
//
//  Created by Jarrod Glissmann on 9/29/14.
//  Copyright (c) 2014 Jarrod Glissmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var foodDictionary:[String:Dictionary<String, String>] = [:]
    var foodCategories:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var dc = DataConnection()
        //dc.getCollectionViewData("Sandwich")
        dc.getAllCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return foodCell()
    }
    
}

class foodCell: UICollectionViewCell {
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    
    
}