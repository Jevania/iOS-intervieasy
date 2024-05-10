//
//  TopHomeView.swift
//  intervieasy
//
//  Created by jevania on 06/05/24.
//

import Foundation
import UIKit

class TopHomeView: UIView {
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.blue1.cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGradient()
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
}
