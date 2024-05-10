//
//  CustomButton.swift
//  intervieasy
//
//  Created by jevania on 07/05/24.
//

import UIKit


class RegularImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let imageView = self.imageView {
            let imageSize = CGSize(width: 60, height: 50)
            let imageX = (self.bounds.width - imageSize.width) / 2
            let imageY = (self.bounds.height - imageSize.height) / 2
            imageView.frame = CGRect(x: imageX, y: imageY, width: imageSize.width, height: imageSize.height)
        }
    }
}

class ImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let imageView = self.imageView {
            let imageSize = CGSize(width: 60, height: 60)
            let imageX = (self.bounds.width - imageSize.width) / 2
            let imageY = (self.bounds.height - imageSize.height) / 2
            imageView.frame = CGRect(x: imageX, y: imageY, width: imageSize.width, height: imageSize.height)
        }
    }
}

class SmallImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let imageView = self.imageView {
            let imageSize = CGSize(width: 30, height: 30)
            let imageX = (self.bounds.width - imageSize.width) / 2
            let imageY = (self.bounds.height - imageSize.height) / 2
            imageView.frame = CGRect(x: imageX, y: imageY, width: imageSize.width, height: imageSize.height)
        }
    }
}
