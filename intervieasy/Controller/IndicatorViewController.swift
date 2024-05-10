//
//  ComponentViewController.swift
//  intervieasy
//
//  Created by jevania on 09/05/24.
//

import UIKit

class IndicatorViewController: UIViewController {
    var selectedIndicator: Indicator!
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.sizeToFit()
        
        return label
    }()
    
    private var descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.sizeToFit()
        
        return label
    }()
    
    private var indicatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Indicator"
        label.sizeToFit()
        
        return label
    }()
    
    private var indicatorDescLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.textColor = .black
        label.sizeToFit()
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        view.addSubview(imageView)
        view.addSubview(scoreLabel)
        view.addSubview(descLabel)
        view.addSubview(indicatorLabel)
        view.addSubview(indicatorDescLabel)
        
        configureConstraints()
    }
    
    private func configureView(){
        view.backgroundColor = selectedIndicator.backgroundColor
        imageView.image = UIImage(named: selectedIndicator.image ?? "error")
        scoreLabel.text = selectedIndicator.score
        descLabel.text = selectedIndicator.scoreDesc
        indicatorDescLabel.text = selectedIndicator.indicatorDesc
    }
    
    private func configureConstraints(){
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ]
        
        let scoreLabelConstraints = [
            scoreLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        
        let descLabelConstraints = [
            descLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: scoreLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: scoreLabel.trailingAnchor)
        ]
        
        let indicatorLabelConstraints = [
            indicatorLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: CGFloat(view.frame.height/10)),
            indicatorLabel.leadingAnchor.constraint(equalTo: scoreLabel.leadingAnchor),
            indicatorLabel.trailingAnchor.constraint(equalTo: scoreLabel.trailingAnchor)
        ]
        
        let indicatorDescLabelConstraints = [
            indicatorDescLabel.topAnchor.constraint(equalTo: indicatorLabel.bottomAnchor, constant: 16),
            indicatorDescLabel.leadingAnchor.constraint(equalTo: scoreLabel.leadingAnchor),
            indicatorDescLabel.trailingAnchor.constraint(equalTo: scoreLabel.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(scoreLabelConstraints)
        NSLayoutConstraint.activate(descLabelConstraints)
        NSLayoutConstraint.activate(indicatorLabelConstraints)
        NSLayoutConstraint.activate(indicatorDescLabelConstraints)
        
    }
    

}
