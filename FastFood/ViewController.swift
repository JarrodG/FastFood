//
//  ViewController.swift
//  FastFood
//
//  Created by Jarrod Glissmann on 9/29/14.
//  Copyright (c) 2014 Jarrod Glissmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var currentHealthFactor = "Sodium"
    var foodDictionary:[String:[FastFood]] = [:]
    var foodCategories:[String] = []
    var purchasedItems:[FastFood] = []
    var nutritionDictionary:[String:Double] = [:]
    
    @IBOutlet weak var receiptTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var graphTableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //activity.startAnimating()
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            var dc = DataConnection()
            self.foodCategories = dc.getAllCategories()
            for category in self.foodCategories{
                self.foodDictionary[category] = dc.getCollectionViewData(category)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView.reloadData()
                self.activity.stopAnimating()
                //self.activity.hidden = true
            })
        })
        
        nutritionCalculation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return foodCategories.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var sectionName = foodCategories[section]
        var foodArray = foodDictionary[sectionName]! as Array
        
        return foodArray.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as foodCell
        
        var name = foodCategories[indexPath.section]
        var foodArray = foodDictionary[name]! as Array
        var foodItem = foodArray[indexPath.row]
        //println(foodItem.print())
        cell.foodImage.image = foodItem.image
        //cell.foodImage.image = UIImage(named: "Image")
        cell.foodLabel.text = foodItem.name
        var percentageAmount:Double = 0
        if currentHealthFactor == "Sodium" {
            percentageAmount = foodItem.getPecentageSodium()
        }
        if currentHealthFactor == "Sugar" {
            percentageAmount = foodItem.getPercentageSugar()
        }
        if currentHealthFactor == "Fat" {
            percentageAmount = foodItem.getPecentageFat()
        }
        if currentHealthFactor == "Calories" {
            percentageAmount = foodItem.getPercentageCalories()
        }
        percentageAmount *= 100
        switch percentageAmount {
        case 0...15:
            cell.foodView.backgroundColor = UIColor.greenColor()
        case 15...33:
            cell.foodView.backgroundColor = UIColor.yellowColor()
        case 33...50:
            cell.foodView.backgroundColor = UIColor.orangeColor()
        default:
            cell.foodView.backgroundColor = UIColor.redColor()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var currentCategory = foodCategories[indexPath.section]
        var arrayOfFoods = foodDictionary[currentCategory]! as Array
        var foodItem = arrayOfFoods[indexPath.row]
        purchasedItems.append(foodItem)
        receiptTableView.reloadData()
        nutritionCalculation()
        graphTableView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath) as CollectionHeader
        header.headerLabel.text = foodCategories[indexPath.section]
        return header
    }
    
    @IBAction func saltButton(sender: UIButton) {
        currentHealthFactor = "Sodium"
        collectionView.reloadData()
    }
    
    @IBAction func sugarButton(sender: UIButton) {
        currentHealthFactor = "Sugar"
        collectionView.reloadData()
    }
    
    @IBAction func butterButton(sender: UIButton) {
        currentHealthFactor = "Fat"
        collectionView.reloadData()
    }
    
    @IBAction func caloriesButton(sender: UIButton) {
        currentHealthFactor = "Calories"
        collectionView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return purchasedItems.count
        }
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("receiptCell", forIndexPath: indexPath) as receiptCell
            var currentFood = purchasedItems[indexPath.row]
            cell.itemName.text = currentFood.name
            
            return cell
        }
        
        if tableView.tag == 2 {
            var cell = tableView.dequeueReusableCellWithIdentifier("graphCell", forIndexPath: indexPath) as graphCell
            
            if indexPath.row == 0 {
                cell.nutritionName.text = "Calories"
                cell.graphView.percentage = CGFloat(nutritionDictionary["Calories"]!)
            } else if indexPath.row == 1 {
                cell.nutritionName.text = "Fat"
                cell.graphView.percentage = CGFloat(nutritionDictionary["Fat"]!)
            } else if indexPath.row == 2 {
                cell.nutritionName.text = "Sodium"
                cell.graphView.percentage = CGFloat(nutritionDictionary["Sodium"]!)
            } else if indexPath.row == 3 {
                cell.nutritionName.text = "Sugar"
                cell.graphView.percentage = CGFloat(nutritionDictionary["Sugar"]!)
            }
            cell.graphView.setNeedsDisplay()
            return cell
        }
        return UITableViewCell()
    }
    
    func nutritionCalculation() {
        var calories: Double = 0
        var fat: Double = 0
        var sodium: Double = 0
        var sugar: Double = 0
        for item in purchasedItems {
            calories += item.calories
            fat += item.fat
            sodium += item.sodium
            sugar += item.sugar
        }
        nutritionDictionary["Calories"] = calories / 2500 * 100
        nutritionDictionary["Fat"] = fat / 70 * 100
        nutritionDictionary["Sodium"] = sodium / 2300 * 100
        nutritionDictionary["Sugar"] = sugar / 90 * 100
    }
    
    @IBAction func resetButton(sender: UIButton) {
        purchasedItems.removeAll(keepCapacity: false)
        nutritionCalculation()
        receiptTableView.reloadData()
        graphTableView.reloadData()
    }
    
    
    
}

class foodCell: UICollectionViewCell {
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    
}

class CollectionHeader: UICollectionReusableView {
    @IBOutlet weak var headerLabel: UILabel!
    
}

class receiptCell: UITableViewCell {
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
}

class graphCell: UITableViewCell {
    
    @IBOutlet weak var nutritionName: UILabel!
    @IBOutlet weak var graphView: NutritionGraphs!
    
}










