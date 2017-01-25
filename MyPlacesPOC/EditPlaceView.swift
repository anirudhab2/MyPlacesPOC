//
//  EditPlaceView.swift
//  MyPlacesPOC
//
//  Created by Anirudha Tolambia on 30/09/16.
//  Copyright © 2016 Anirudha Tolambia. All rights reserved.
//

import UIKit

// MARK: - Sending Actions for Placemark Editing
@objc
protocol EditPlaceDelegate {
    optional func placeTitleChangedForAnnotation(annotation: PlacemarkAnnotation, newTitle: String)
    optional func newPlaceWithTitle(title: String)
}


// MARK: - Main Class
class EditPlaceView: UIView, UITextFieldDelegate {
    
    // MARK: Variables
    private var textField: UITextField!
    private var saveButton: CustomButton!
    private var cancelButton: CustomButton!
    private var annotation: PlacemarkAnnotation!
    
    weak var delegate: EditPlaceDelegate?
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func initialize() {
        
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0.85*bounds.width, height: 50))
        textField.center.x = center.x
        textField.center.y = center.y - 100
        textField.backgroundColor = UIColor.whiteColor()
        textField.tintColor = UIColor.darkThemeColor()
        textField.textColor = UIColor.darkThemeColor()
        textField.placeholder = "Title"
        textField.textAlignment = .Center
        textField.returnKeyType = .Done
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.darkThemeColor().CGColor
        textField.delegate = self
        addSubview(textField)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.textFieldEditingChanged), name: UITextFieldTextDidChangeNotification, object: textField)
        
        
        saveButton = CustomButton(title: "Save", frame: CGRect(x: textField.frame.minX, y: textField.frame.maxY, width: textField.bounds.width/2, height: 50))
        saveButton.enabled = false
        saveButton.addTarget(self, action: #selector(self.saveButtonTapped), forControlEvents: .TouchUpInside)
        addSubview(saveButton)
        
        
        cancelButton = CustomButton(title: "Cancel", frame: CGRect(x: textField.frame.midX, y: textField.frame.maxY, width: textField.bounds.width/2, height: 50))
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), forControlEvents: .TouchUpInside)
        addSubview(cancelButton)
        
        textField.becomeFirstResponder()
        
    }
    
    // MARK: Actions
    internal func saveButtonTapped() {
        if let delegate = delegate {
            if (textFieldContainsValidCharacters()) {
                let components = textField.text!.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter { !$0.isEmpty }
                let validTitle = components.joinWithSeparator(" ")
                
                if (annotation != nil) {
                    delegate.placeTitleChangedForAnnotation!(annotation, newTitle: validTitle)
                } else {
                    delegate.newPlaceWithTitle!(validTitle)
                }
                
                dismiss()
            }
        }
    }
    
    internal func cancelButtonTapped() {
        dismiss()
    }
    
    internal func dismiss() {
        self.removeFromSuperview()
        saveButton.enabled = false
        textField.text = nil
        annotation = nil
    }

    // MARK: Text Field Controls
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (textFieldContainsValidCharacters() == false) {
            saveButton.enabled = false
        }
        return true
    }
    
    internal func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textFieldContainsValidCharacters()) {
            self.saveButtonTapped()
        }
        return true
    }
    
    internal func textFieldEditingChanged() {
        saveButton.enabled = textFieldContainsValidCharacters()
    }
    
    internal func textFieldContainsValidCharacters() -> Bool {
        let components = textField.text!.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter { !$0.isEmpty }
        let stringToCheck = components.joinWithSeparator("")
        
        return !(stringToCheck.characters.count == 0)
    }
    
    // MARK: Public Methods
    func setAnnotation(annotation: PlacemarkAnnotation) {
        self.annotation = annotation
    }
}

