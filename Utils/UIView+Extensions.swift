//
//  UIView+Extensions.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 30/01/2018.
//

import UIKit

extension UIView {
    
    /// Add layout constraint to the passed view to fit the view 
    func fit(view: UIView) {
        // Top constraint
        self.addConstraint(NSLayoutConstraint(item: view,
                                              attribute: NSLayoutAttribute.top,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.top,
                                              multiplier: 1,
                                              constant: 0))
        
        // Bottom constraint
        self.addConstraint(NSLayoutConstraint(item: view,
                                              attribute: NSLayoutAttribute.bottom,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.bottom,
                                              multiplier: 1,
                                              constant: 0))
        
        // Leading constraint
        self.addConstraint(NSLayoutConstraint(item: view,
                                              attribute: NSLayoutAttribute.leading,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.leading,
                                              multiplier: 1,
                                              constant: 0))
        
        // Trainling constraint
        self.addConstraint(NSLayoutConstraint(item: view,
                                              attribute: NSLayoutAttribute.trailing,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.trailing,
                                              multiplier: 1,
                                              constant: 0))
    }
}
