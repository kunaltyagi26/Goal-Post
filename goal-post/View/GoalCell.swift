//
//  GoalCell.swift
//  goal-post
//
//  Created by Kunal Tyagi on 19/01/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalDescLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    @IBOutlet weak var goalProgressLbl: UILabel!
    @IBOutlet weak var completionView: UIView!
    
    func configureCell(goal: Goal){
        self.goalDescLbl.text = goal.goalDescription
        self.goalTypeLbl.text = goal.goalType
        self.goalProgressLbl.text = String(describing: goal.goalProgress )
        
        if goal.goalProgress == goal.goalCompletionValue {
            completionView.isHidden = false
        }
        else {
            completionView.isHidden = true
        }
    }
}
