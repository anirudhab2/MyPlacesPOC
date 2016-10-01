//
//  CustomAlertView.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 01/10/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import UIKit

// MARK: Alert View Tag
private let AlertViewTag = 1928

// MARK: - Main Class
class CustomAlertView: UIView {
    
    // MARK: Variables
    private let buttonHeight: CGFloat = 60
    
    private var centerFrame: CGRect!
    private var leftFrame: CGRect!
    private var rightFrame: CGRect!
    
    private var containerView: UIView!
    
    private var messageLabel: UILabel!
    private var firstButton: CustomButton?
    private var secondButton: CustomButton?

    // MARK: Initialization
    init(message: String) {
        
        super.init(frame: UIScreen.mainScreen().bounds)
        setupView()
        setMessage(message)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        
        let defaultFrame = CGRect(x: 10, y: 25, width: screenWidth-20, height: 150)
        
        containerView = UIView(frame: defaultFrame)
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.clipsToBounds = true
        addSubview(self.containerView)
        
        
        centerFrame = CGRect(x: 0, y: self.containerView.bounds.maxY-buttonHeight, width: self.containerView.bounds.width, height: buttonHeight)
        leftFrame = CGRect(x: 0, y: self.containerView.bounds.maxY-buttonHeight, width: self.containerView.bounds.width/2, height: buttonHeight)
        rightFrame = CGRect(x: self.containerView.bounds.width/2, y: self.containerView.bounds.maxY-buttonHeight, width: self.containerView.bounds.width/2, height: buttonHeight)
        
        self.containerView.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.cornerRadius = 4
    }
    
    // MARK: Setting Message and Adjusting Frames
    private func setMessage(message: String) {
        messageLabel = UILabel()
        messageLabel.frame = CGRect(x: 10, y: 10, width: self.bounds.width-30, height: 100)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        messageLabel.textAlignment = .Center
        
        messageLabel.text = message
        
        messageLabel.sizeToFit()
        messageLabel.center.x = containerView.bounds.midX
        messageLabel.center.y = containerView.bounds.midY - buttonHeight/3
        containerView.addSubview(messageLabel)
    }
    
    // MARK: Show/Dismiss Alert
    func showInView(view: UIView) {
        
        if (view.viewWithTag(AlertViewTag) == nil) {
            self.tag = AlertViewTag
            view.addSubview(self)
            self.frame = view.bounds
        } else {
            return
        }
        
        containerView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        containerView.alpha = 0
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {
            
            self.containerView.transform = CGAffineTransformIdentity
            self.containerView.alpha = 1
            
        }) { (finished) in }
    }
    
    private func dismiss() {
        self.removeFromSuperview()
    }
    
    // MARK: Adding Actions
    func addFirstButton(title: String, action: () -> Void) {
        let button = CustomButton(title: title, frame: self.centerFrame)
        button.setTitle(title, forState: .Normal)
        button.action = action
        button.addTarget(self, action: #selector(self.buttonTapped(_:)), forControlEvents: .TouchUpInside)
        
        firstButton = button
        containerView.addSubview(self.firstButton!)
    }
    
    func addSecondButton(title: String, action: () -> Void) {
        if (self.firstButton != nil) {
            self.firstButton?.frame = self.leftFrame
        }
        
        let button = CustomButton(title: title, frame: self.rightFrame)
        button.setTitle(title, forState: .Normal)
        button.action = action
        button.addTarget(self, action: #selector(self.buttonTapped(_:)), forControlEvents: .TouchUpInside)
        
        secondButton = button
        containerView.addSubview(self.secondButton!)
    }
    
    // MARK: Alert Button Action
    internal func buttonTapped(button: CustomButton) {
        dismiss()
        button.action()
    }
}