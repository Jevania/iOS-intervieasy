//
//  UILabel+CustomLabel.swift
//  intervieasy
//
//  Created by jevania on 08/05/24.
//

import Foundation
import UIKit

extension UILabel {
    func configure(withText text: String, size: CGFloat, weight: UIFont.Weight) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        self.textAlignment = .center
        self.textColor = .black
        self.text = text
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
    }
}
