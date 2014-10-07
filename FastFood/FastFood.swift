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
    //function that prints out something that you can read like big mac has ___ calories
    
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
        //println(image)
        var url = NSURL(string: image)
        var data = NSData(contentsOfURL: url)
        self.image = UIImage(data: data)
    }
    
    func print() -> String {
        return "A \(name) has \(calories) calories, \(fat) fat, \(sodium) sodium, and \(sugar) sugar."
    }
    
    func getPercentageCalories() -> Double{
        return calories / 2500
    }
    
    func getPecentageSodium() -> Double {
        return sodium / 2300
    }
    
    func getPecentageFat() -> Double {
        return fat / 70
    }
    
    func getPercentageSugar() -> Double {
        return sugar / 90
    }
}