//
//  CreateGoalVC.swift
//  goal-post
//
//  Created by Kunal Tyagi on 20/01/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    
    var goalType: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.snapshotView(afterScreenUpdates: true)
        textView.delegate = self
        nextBtn.bindToKeyboard()
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselctedColor()
        screenTap()
        if textView.text == "" || textView.text == "What is your goal?"{
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7764705882, blue: 0.2666666667, alpha: 1)
        }
        else{
            nextBtn.isEnabled = true
            nextBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        }
    }
    
    func screenTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(screenTapAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc func screenTapAction(){
        view.endEditing(true)
    }
    
    @IBAction func shortTermPressed(_ sender: Any) {
        goalType = .shortTerm
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselctedColor()
    }
    
    @IBAction func longTermPressed(_ sender: Any) {
        goalType = .longTerm
        shortTermBtn.setDeselctedColor()
        longTermBtn.setSelectedColor()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        guard let finishGoalVC = storyboard?.instantiateViewController(withIdentifier: "FinishGoalVC") as? FinishGoalVC else { return }
        finishGoalVC.initData(description: textView.text!, type: goalType)
        presentDetail(finishGoalVC)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismissDetail()
    }
}

extension CreateGoalVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What is your goal?" || textView.text == "" {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.4922404289, green: 0.7722371817, blue: 0.4631441236, alpha: 1)
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7764705882, blue: 0.2666666667, alpha: 1)
        }
        else{
            nextBtn.isEnabled = true
            nextBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == "What is your goal?" {
            textView.text = "What is your goal?"
            textView.textColor = #colorLiteral(red: 0.7464011312, green: 0.8857318759, blue: 0.7402122021, alpha: 1)
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7764705882, blue: 0.2666666667, alpha: 1)
        }
        else{
            nextBtn.isEnabled = true
            nextBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == ""{
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.7764705882, blue: 0.2666666667, alpha: 1)
        }
        else{
            nextBtn.isEnabled = true
            nextBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
        }
    }
}
