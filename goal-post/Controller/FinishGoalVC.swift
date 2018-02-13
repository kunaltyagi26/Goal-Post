//
//  FinishGoalVC.swift
//  goal-post
//
//  Created by Kunal Tyagi on 20/01/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit
import CoreData

class FinishGoalVC: UIViewController {
    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTxt: UITextField!
    
    var goalDescription: String!
    var goalType: GoalType!
    
    func initData(description: String, type: GoalType){
        self.goalDescription = description
        self.goalType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenTap()
        view.snapshotView(afterScreenUpdates: true)
        createGoalBtn.bindToKeyboard()
        pointsTxt.delegate = self
        if pointsTxt.text == "" {
            createGoalBtn.isEnabled = false
            createGoalBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7764705882, blue: 0.2666666667, alpha: 1)
        }
        else{
            createGoalBtn.isEnabled = true
            createGoalBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        }
        pointsTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        if pointsTxt.text == "" {
            createGoalBtn.isEnabled = false
            createGoalBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7764705882, blue: 0.2666666667, alpha: 1)
        }
        else{
            createGoalBtn.isEnabled = true
            createGoalBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        }
    }
    
    func screenTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(screenTapAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc func screenTapAction(){
        view.endEditing(true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismissDetail()
    }
    @IBAction func createGoalPressed(_ sender: Any) {
        self.save { (complete) in
            if complete {
                presentSecondaryDetail()
            }
        }
    }
}

extension FinishGoalVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if pointsTxt.text == "" {
            createGoalBtn.isEnabled = false
            createGoalBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7764705882, blue: 0.2666666667, alpha: 1)
        }
        else{
            createGoalBtn.isEnabled = true
            createGoalBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if pointsTxt.text == "" {
            createGoalBtn.isEnabled = false
            createGoalBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7764705882, blue: 0.2666666667, alpha: 1)
        }
        else{
            createGoalBtn.isEnabled = true
            createGoalBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        }
    }
    
    func save(completion: (_ finished: Bool)-> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: managedContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTxt.text!)!
        goal.goalProgress = Int32(0)
        
        do{
            try managedContext.save()
            print("Data successfully saved.")
            completion(true)
        }
        catch{
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
}
