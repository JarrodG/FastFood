//
//  DatabaseConnection.swift
//  FastFood
//
//  Created by Jarrod Glissmann on 9/30/14.
//  Copyright (c) 2014 Jarrod Glissmann. All rights reserved.
//

import Foundation


class DataConnection {
    //Used by the collection view. Pass in category and get a string array with [name, url of image]
    
    func getCollectionViewData(categoryName:String)->[FastFood]{
        
        var resultArray:[FastFood] = []
        var couchString = "http://10.100.201.76:5984/mcdonalds/_design/pages/_view/ByCategory?key=%22\(categoryName)%22"
        var couchURL = NSURL(string: couchString)
        var data = NSData.dataWithContentsOfURL(couchURL, options: nil, error: nil)
        var dataDictionary: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
        //println(dataDictionary)
        var rowsArray = dataDictionary!["rows"]
        
        for oranges in rowsArray as NSArray{
            var databaseString:String = "http://10.100.201.76:5984/mcdonalds/"
            var finalString = ""
            if let id: AnyObject? = oranges["id"]{
                databaseString += id as String
                databaseString += "/"
            }
            
            if let pictureID: NSDictionary = oranges["value"] as? NSDictionary{
                var calories = pictureID["Calories"] as Double
                var category = pictureID["Category"] as String
                var fat = pictureID["Fat"] as Double
                var name = pictureID["Name"] as String
                var sodium = pictureID["Sodium"] as Double
                var sugar = pictureID["Sugar"] as Double
                
                var sandwichName: NSDictionary = pictureID["_attachments"] as NSDictionary
                
                
                for (imageNames, imageData) in sandwichName {
                    
                    databaseString += imageNames as String
                    finalString = databaseString.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    println(finalString)
                    
                    //resultDictionary[sandwichName![0] as String] = databaseString
                }
                var foodItem = FastFood(calories: calories, category: category, fat: fat, image: finalString, name: name, sodium: sodium, sugar: sugar)
                resultArray.append(foodItem)
            }
            
        }
        

        return resultArray
    }
    
    func getAllCategories() -> [String] {
        var resultArray:[String] = []
        //http//:10.100.201.76:5984/mcdonalds/_design/pages/_view/AllCategories?group=true
        var couchString = "http://10.100.201.76:5984/mcdonalds/_design/pages/_view/AllCategories?group=true"
        var couchURL = NSURL(string: couchString)
        var data = NSData.dataWithContentsOfURL(couchURL, options: nil, error: nil)
        var dataDictionary: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
        var rowsArray = dataDictionary!["rows"]
        for i in rowsArray as NSArray{
            if let key: AnyObject? = i["key"]{
                resultArray.append(key as String)
            }
        }
        return resultArray
    }
    

    
    
    
}