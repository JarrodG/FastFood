//
//  FastFood.swift
//  FastFood
//
//  Created by Jarrod Glissmann on 10/1/14.
//  Copyright (c) 2014 Jarrod Glissmann. All rights reserved.
//

import Foundation
import UIKit

class FastFood {
    //everything from the couch
    //uiimage
    
    var sodium:Double
    var sugar:Double
    var fat:Double
    var name:String
    var category:String
    var calories:Double
    var image:UIImage
    init(calories: Double, category: String, fat: Double, image: String, name: String, sodium: Double, sugar: Double){
        self.calories = calories
        self.category = category
        self.fat = fat
        self.name = name
        self.sodium = sodium
        self.sugar = sugar
        var url = NSURL(string: image)
        var data = NSData(contentsOfURL: url)
        self.image = UIImage(data: data)
    }
}