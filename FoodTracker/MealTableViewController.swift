//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Stepan Grigoryev on 08.09.2020.
//  Copyright © 2020 Stepan Grigoryev. All rights reserved.
//

import UIKit

private let reuseIdentifire = "MealTableViewCell"

class MealTableViewController: UITableViewController {

    var meals = [Meal]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        //loadSampleMeals()
        if let savedMeals = loadSavedMeals(), !savedMeals.isEmpty {
            meals = savedMeals
        } else {
            loadSampleMeals()
        }
        
        
    }

    
    func  saveMeals() {
        do {
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
            try archiveData.write(to: Meal.mealFileUrl)
        } catch {
            print("Unexpected error \(error)")
        }
    }
    
    func loadSavedMeals() -> [Meal]?{
        do {
            let archiveData = try Data(contentsOf: Meal.mealFileUrl)
            //return try NSKeyedUnarchiver.unarchivedObject(ofClasses: [Meal.self], from: archiveData) as! [Meal]
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archiveData) as? [Meal]
    
        } catch {
            print("Unexpected error \(error)")
            return nil
        }
    }
    
    func loadSampleMeals() {
        let photo1 = UIImage(named:"meal1")
        let photo2 = UIImage(named:"meal2")
        let photo3 = UIImage(named:"meal3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
         
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
         
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        meals += [meal1, meal2, meal3]
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifire, for: indexPath) as! MealTableViewCell

        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.ratingControl.rating = meal.rating
        cell.photoImageView.image = meal.photo

        return cell
    }

    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow
            {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else
            {
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        saveMeals()
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        meals.swapAt(fromIndexPath.row, to.row)
        saveMeals()
    }


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier
        {
        case "AddItem":
            print("Add item")
        case "ShowDetail":
            print("Show detail")
            let mealDetailViewController = segue.destination as! MealViewController
            let selectedMealCell = sender as! MealTableViewCell
            let indexPath = tableView.indexPath(for: selectedMealCell)!
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
}
