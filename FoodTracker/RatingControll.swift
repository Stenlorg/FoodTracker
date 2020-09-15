//
//  RatingControll.swift
//  FoodTracker
//
//  Created by Stepan Grigoryev on 11.08.2020.
//  Copyright © 2020 Stepan Grigoryev. All rights reserved.
//

import UIKit

@IBDesignable class RatingControll: UIStackView {
    
    private var ratingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButton()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    
    private func setupButton() {
        for button in ratingButtons {
            removeArrangedSubview(button) //delete button from StackView
            button.removeFromSuperview() //delete pic from screen
        }
        ratingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let hightlightedStar = UIImage(named: "hightlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            
        
        
            let button = UIButton()
            //button.backgroundColor = UIColor.red
            
            //Add constrains
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            //Set accessibility label
            button.accessibilityLabel = "Set \(index+1) star rating"
            
            
            //set button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(hightlightedStar, for: .highlighted)
            button.setImage(hightlightedStar, for: [.highlighted, .selected])
            
            //Add button action
            button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
            
            //Create buttons
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @objc
    func ratingButtonTapped(_ button: UIButton) {
        guard  let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
             
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
             
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }

}
