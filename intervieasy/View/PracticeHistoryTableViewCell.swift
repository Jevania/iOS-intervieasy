//
//  PracticeHistoryTableViewCell.swift
//  intervieasy
//
//  Created by jevania on 06/05/24.
//

import UIKit

class PracticeHistoryTableViewCell: UITableViewCell {
    
    static let identifier = "PracticeHistoryTableViewCell"
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    let textVerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        
        return stackView
    }()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ic-star")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var practiceName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    private var timeStamp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .black.withAlphaComponent(0.5)
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    private var score: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.sizeToFit()
        
        return label
    }()
    
    private var chevronIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .blue2
        
        return imageView
    }()
    
    
    func setup(with practice: Practice) {
        practiceName.text = practice.title
        timeStamp.text = practice.timeStamp
        score.text = String(format: "%.0f", practice.score)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContentView()
        
        textVerStackView.addArrangedSubview(practiceName)
        textVerStackView.addArrangedSubview(timeStamp)
        horizontalStackView.addArrangedSubview(textVerStackView)
        
        image.addSubview(score)
        horizontalStackView.addArrangedSubview(image)
        horizontalStackView.addArrangedSubview(chevronIcon)
        
        contentView.addSubview(horizontalStackView)
        
        configureConstraints()
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .blueLight
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowRadius = 3
    }
    
    private func configureConstraints() {
        
        let horizontalStackViewConstraints = [
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        
        let textVerStackViewConstraints = [
            textVerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textVerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
            textVerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            textVerStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            textVerStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6)
        ]
        
        let imageConstraints = [
            image.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor),
            image.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ]
        
        let scoreConstraints = [
            score.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            score.centerXAnchor.constraint(equalTo: image.centerXAnchor),            score.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
        ]
        
        let chevronIconConstraints = [
            chevronIcon.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor),
            chevronIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            chevronIcon.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.07),
            chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ]
        
        NSLayoutConstraint.activate(horizontalStackViewConstraints)
        NSLayoutConstraint.activate(textVerStackViewConstraints)
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(scoreConstraints)
        NSLayoutConstraint.activate(chevronIconConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
