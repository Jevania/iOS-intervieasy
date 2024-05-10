//
//  QuestionViewController.swift
//  intervieasy
//
//  Created by jevania on 09/05/24.
//

import UIKit

class QuestionViewController: UIViewController {
    var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private var instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        let attributedText = NSMutableAttributedString(
            string: "Your recording answer can be no longer than",
            attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.black
        ])

        attributedText.append(NSAttributedString(
            string: " 1 minute",
            attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.red
        ]))


        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    var questionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 3
        
        return view
    }()
    
    var questionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    private let randomizeButton: SmallImageButton = {
        let button = SmallImageButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tintColor = .gray
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2
        button.layer.masksToBounds = false
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.circle.fill"), for: .normal)

        button.addTarget(self, action: #selector(didTapRandomizeButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapRandomizeButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.questionLabel.text = JSONHelper.getRandomInterviewQuestion()
        }
    }
    
    private let startMockButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Start Mock Interview", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .red1
        
        button.tintColor = .white
        button.layer.cornerRadius = 15
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(didTapStartMockButtonn), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapStartMockButtonn() {
        let vc = RecordingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        topView = TopHomeView(frame: CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: Int(view.bounds.height*0.6)))
        view.addSubview(topView)
        
        questionView.addSubview(questionLabel)
        view.addSubview(questionView)
        view.addSubview(instructionLabel)
        view.addSubview(randomizeButton)
        view.addSubview(startMockButton)
        
        configureConstraints()
    }
    
    private func configureView(){
        questionLabel.text = JSONHelper.getRandomInterviewQuestion()
        view.backgroundColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.title = "Interview Question"
    }
    
    private func configureConstraints(){
        let topViewConstraints = [
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        let questionLabelConstraints = [
            questionLabel.centerYAnchor.constraint(equalTo: questionView.centerYAnchor),
            questionLabel.centerXAnchor.constraint(equalTo: questionView.centerXAnchor),
            questionLabel.widthAnchor.constraint(equalTo: questionView.widthAnchor, multiplier: 0.9)
        ]
        
        let questionViewConstraints = [
            questionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            questionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            questionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            questionView.heightAnchor.constraint(equalTo: questionLabel.heightAnchor, multiplier: 2)
        ]
        
        let instructionLabelConstraints = [
            instructionLabel.bottomAnchor.constraint(equalTo: questionView.topAnchor, constant: -32),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ]
        
        let randomizeButtonConstraints = [
            randomizeButton.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: 8),
            randomizeButton.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 8)
        ]
        
        let startMockButtonConstraints = [
            startMockButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            startMockButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startMockButton.heightAnchor.constraint(equalToConstant: 50),
            startMockButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ]
        
        NSLayoutConstraint.activate(startMockButtonConstraints)
        NSLayoutConstraint.activate(randomizeButtonConstraints)
        NSLayoutConstraint.activate(questionLabelConstraints)
        NSLayoutConstraint.activate(questionViewConstraints)
        NSLayoutConstraint.activate(instructionLabelConstraints)
        NSLayoutConstraint.activate(topViewConstraints)
    }
    
}
