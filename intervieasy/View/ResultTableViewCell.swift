//
//  ResultTableViewCell.swift
//  intervieasy
//
//  Created by jevania on 08/05/24.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    static let identifier = "ResultTableViewCell"
    
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
        
        return stackView
    }()
    
    var componentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .black
        label.sizeToFit()
        
        return label
    }()
    
    var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .black
        label.sizeToFit()
        
        return label
    }()
    
    private var chevronIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .black.withAlphaComponent(0.3)
        
        return imageView
    }()
    
    var cellColor: UIColor? {
        didSet {
            configureContentView()
        }
    }
    
    func setupCellColor(with cellColor: UIColor) {
        self.cellColor = cellColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContentView()
        
        textVerStackView.addArrangedSubview(componentLabel)
        textVerStackView.addArrangedSubview(scoreLabel)
        horizontalStackView.addArrangedSubview(textVerStackView)
        
        horizontalStackView.addArrangedSubview(chevronIcon)
        
        contentView.addSubview(horizontalStackView)
        
        configureConstraints()
    }
    
    private func configureContentView() {
        guard let cellColor = cellColor else { return }
        contentView.backgroundColor = cellColor
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
            textVerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textVerStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            textVerStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6)
        ]
        
        let chevronIconConstraints = [
            chevronIcon.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor),
            chevronIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            chevronIcon.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.07),
            chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ]
        
        NSLayoutConstraint.activate(horizontalStackViewConstraints)
        NSLayoutConstraint.activate(textVerStackViewConstraints)
        NSLayoutConstraint.activate(chevronIconConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
