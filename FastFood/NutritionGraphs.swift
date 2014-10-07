//
//  NutritionGraphs.swift
//  FastFood
//
//  Created by Jarrod Glissmann on 10/7/14.
//  Copyright (c) 2014 Jarrod Glissmann. All rights reserved.
//

import UIKit
@IBDesignable
class NutritionGraphs: UIView {
    @IBInspectable var percentage:CGFloat = 0
    
    override func drawRect(rect: CGRect)
    {
        
        //Drawing code
        if percentage <= 100 {
            var bottomRectangle = UIBezierPath(rect: CGRect(x: 10.0, y: 60.0, width: 470, height: 30))
            bottomRectangle.closePath()
            UIColor.blueColor().setFill()
            bottomRectangle.fill()
            
            var topRectangle = UIBezierPath(rect: CGRect(x: 10, y: 10, width: percentage * 4.7, height: 30))
            topRectangle.closePath()
            if percentage <= 33 {
                UIColor.greenColor().setFill()
            } else if percentage <= 66 {
                UIColor.yellowColor().setFill()
            } else if percentage <= 100{
                UIColor.orangeColor().setFill()
            } else {
                UIColor.redColor().setFill()
            }
            topRectangle.fill()
        } else {
            
            var bottomRectangle = UIBezierPath(rect: CGRect(x: 10.0, y: 60.0, width:(100 / percentage) * 470, height: 30))
            bottomRectangle.closePath()
            UIColor.blueColor().setFill()
            bottomRectangle.fill()
            
            var topRectangle = UIBezierPath(rect: CGRect(x: 10.0, y: 10.0, width: 470, height: 30))
            topRectangle.closePath()
            UIColor.redColor().setFill()
            topRectangle.fill()
        }
        
        
        
        
    }
    

}
