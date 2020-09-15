//
//  Meal.swift
//  FoodTracker
//
//  Created by Stepan Grigoryev on 01.09.2020.
//  Copyright © 2020 Stepan Grigoryev. All rights reserved.
//

import UIKit
import Foundation

class Meal {
    var name: String
    var photo: UIImage?
    var rating: Int
    
    
    
    //MARK: Initialization
     
    init?(name: String, photo: UIImage?, rating: Int) {
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 || rating > 5 {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}

