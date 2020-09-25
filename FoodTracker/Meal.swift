//
//  Meal.swift
//  FoodTracker
//
//  Created by Stepan Grigoryev on 01.09.2020.
//  Copyright © 2020 Stepan Grigoryev. All rights reserved.
//

import UIKit
import Foundation


private struct PropertyKey {
    static let name = "name"
    static let photo = "photo"
    static let rating = "rating"
}


class Meal: NSObject, NSCoding {
    var name: String
    var photo: UIImage?
    var rating: Int
    
    private static let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let mealFileUrl = Meal.documentsFolder.appendingPathComponent("meal")
    
    required convenience init? (coder: NSCoder) {
            
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            print("Unable to decode the name for a Meal object.")
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
        
    }
    
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
    
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
    }
}

