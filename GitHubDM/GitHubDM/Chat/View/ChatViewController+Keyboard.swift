//
//  ChatViewController+Keyboard.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/9.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

extension ChatViewController {
    func unregisterKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setupHandlingKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let endValue: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let durationValue: NSNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curveOption = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else {
                return
        }
        let duration = durationValue.doubleValue
        let options = UIView.AnimationOptions(rawValue: UInt(curveOption.uintValue))
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {
                let keyboardHeight = endValue.cgRectValue.height - self.view.safeAreaInsets.bottom
                self.tableView.contentInset.bottom = keyboardHeight
                self.tableView.verticalScrollIndicatorInsets.bottom = keyboardHeight
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let durationValue: NSNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curveOption = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else {
                return
        }
        let duration = durationValue.doubleValue
        let options = UIView.AnimationOptions(rawValue: UInt(curveOption.uintValue))
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {
                self.tableView.contentInset.bottom = 0
                self.tableView.verticalScrollIndicatorInsets.bottom = 0
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
