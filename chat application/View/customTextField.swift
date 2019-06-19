//
//  customTextField.swift
//  Chat Application
//
//  Created by Arman morshed on 12/6/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit

@IBDesignable
class customTextField: UITextField {

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 10

    override func prepareForInterfaceBuilder() {
        customizeTextField()
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeTextField()
        updateView()
        
    }
    
    func customizeTextField(){
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.25)
        layer.cornerRadius = 10.0
        textAlignment = .left
        enablesReturnKeyAutomatically = true
        
        if placeholder == nil {
            placeholder = ""
        }
        
        if let p = placeholder {
            let place = NSAttributedString(string: p, attributes: [.foregroundColor: UIColor.white])
            
            attributedPlaceholder = place
            textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
            imageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
}
