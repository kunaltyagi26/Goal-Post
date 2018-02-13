//
//  UIViewExt.swift
//  goal-post
//
//  Created by Kunal Tyagi on 20/01/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import UIKit

extension UIView{
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        self.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.transform = CGAffineTransform(translationX: 0, y: 0)
    }
}
