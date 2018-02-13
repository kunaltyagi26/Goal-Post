//
//  ViewController.swift
//  goal-post
//
//  Created by Kunal Tyagi on 18/01/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {
    @IBOutlet weak var undoView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var goals: [Goal] = []
    var removedGoal: Goal = Goal()
    var removedGoalIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        view.snapshotView(afterScreenUpdates: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                }
                else {
                    tableView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func addGoalBtnPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return }
        presentDetail(createGoalVC)
    }
    
    @IBAction func unwindToGoalsVC(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func undoPressed(_ sender: Any) {
        /*guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.undoManager = undoManager
        managedContext.undoManager?.undo()
        print(goals.count)
        do{
            try managedContext.save()
            print("Data successfully deleted.")
        }
        catch{
            debugPrint("Could not save: \(error.localizedDescription)")
        }
        fetchCoreDataObjects()
        tableView.reloadData()
        //print(goals.count)*/
        undoView.isHidden = true
    }
    
}

extension GoalsVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell() }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeGoal(atIndexPath: indexPath, completion: { (complete) in
                if complete {
                    self.fetchCoreDataObjects()
                    print(self.goals.count)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.undoView.isHidden = false
                }
            })
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1", handler: { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath, completion: { (complete) in
                if complete {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            })
        })
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
        let goal = goals[indexPath.row]
        if goal.goalProgress == goal.goalCompletionValue {
            return [deleteAction]
        }
        else {
            return [deleteAction, addAction]
        }
    }
}

extension GoalsVC {
    func setProgress(atIndexPath indexPath: IndexPath, completion: (_ complete: Bool)-> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let chosenGoal = goals[indexPath.row]
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        }
        do {
            try managedContext.save()
            print("Progress is set successfully.")
            completion(true)
        }
        catch{
            debugPrint("Could not set progress: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func removeGoal(atIndexPath indexPath: IndexPath, completion: (_ complete: Bool)-> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        removedGoal = goals[indexPath.row]
        removedGoalIndex = indexPath.row
        //print(goals.count)
        managedContext.delete(goals[indexPath.row])
        do{
            try managedContext.save()
            print("Data successfully deleted.")
            completion(true)
        }
        catch{
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
        //print(goals.count)
        completion(true)
    }
    
    func fetch(completion: (_ complete: Bool)-> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do {
            goals = try managedContext.fetch(fetchRequest)
            print("Succesfully fetched data.")
            completion(true)
        }
        catch {
            debugPrint("Couldn't fetch: \(error.localizedDescription )")
            completion(false)
        }
    }
}
