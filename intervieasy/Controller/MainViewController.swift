//
//  MainViewController.swift
//  intervieasy
//
//  Created by jevania on 05/05/24.
//

import UIKit

class MainViewController: UIViewController {
    
    var listPractice = PracticeService().getAllPractice()
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var bodyView: UIView = {
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
    
    let greetingTextHorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .firstBaseline
        
        return stackView
    }()
    
    let greetingVerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    let emptyHistoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    let mainVerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.alignment = .firstBaseline
        
        return stackView
    }()
    
    var todaysDate: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    var greeting1: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    var greeting2: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .darkGray
        label.text = "Let's practice interview together!"
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    var intervieasyImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var sadImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var practiceEmptyLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    private let startPracticeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Start Practice", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .red1
        
        button.tintColor = .white
        button.layer.cornerRadius = 15
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(didTapStartPracticeButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapStartPracticeButton() {
        let vc = QuestionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    var practiceHistoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        
        return label
    }()
    
    private let practiceHistoryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(PracticeHistoryTableViewCell.self, forCellReuseIdentifier: PracticeHistoryTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        greetingVerStackView.addArrangedSubview(todaysDate)
        greetingVerStackView.addArrangedSubview(greeting1)
        greetingVerStackView.addArrangedSubview(greeting2)
        
        greetingTextHorStackView.addArrangedSubview(greetingVerStackView)
        greetingTextHorStackView.addArrangedSubview(intervieasyImageView)
        
        emptyHistoryStackView.addArrangedSubview(sadImageView)
        emptyHistoryStackView.addArrangedSubview(practiceEmptyLabel)
        
        topView = TopHomeView(frame: CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: Int(view.bounds.height*0.6)))
        topView.addSubview(greetingTextHorStackView)
        topView.addSubview(emptyHistoryStackView)
        
        bodyView.addSubview(practiceHistoryLabel)
        
        setupTableView()
        bodyView.addSubview(practiceHistoryListTableView)
        
        topView.addSubview(bodyView)
        
        view.addSubview(topView)
        view.addSubview(startPracticeButton)
        
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
            
            self.listPractice = PracticeService().getAllPractice()
            self.practiceHistoryListTableView.reloadData()
            
            self.configureView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupTableView(){
        practiceHistoryListTableView.delegate = self
        practiceHistoryListTableView.dataSource = self
    }
    
    private func configureView() {
        todaysDate.text = Date().formattedDate()
        greeting1.text = "\(Date().greeting())!"
        intervieasyImageView.image = UIImage(named: "ic-speaking")
        
        practiceEmptyLabel.text = "Your practice history is still empty. Let's start practice now!"
        practiceHistoryLabel.text = "Your Mock Interview History"
        sadImageView.image = UIImage(named: "ic-sad")
        
        if listPractice.isEmpty{
            emptyHistoryStackView.isHidden = false
            bodyView.isHidden = true
        }else{
            emptyHistoryStackView.isHidden = true
            bodyView.isHidden = false
        }
        
    }
    
    private func configureConstraints() {
        
        let topViewConstraints = [
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        let greetingTextHorStackViewConstraints = [
            greetingTextHorStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            greetingTextHorStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            greetingTextHorStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            greetingTextHorStackView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        let intervieasyImageViewConstraints = [
            intervieasyImageView.widthAnchor.constraint(equalToConstant: 130),
            intervieasyImageView.heightAnchor.constraint(equalToConstant: 113),
            intervieasyImageView.trailingAnchor.constraint(equalTo: greetingTextHorStackView.trailingAnchor)
        ]
        
        let greetingVerStackViewConstraints = [
            greetingVerStackView.topAnchor.constraint(equalTo: greetingTextHorStackView.topAnchor),
            greetingVerStackView.bottomAnchor.constraint(equalTo: greetingTextHorStackView.bottomAnchor),
            greetingVerStackView.leadingAnchor.constraint(equalTo: greetingTextHorStackView.leadingAnchor),
            greetingVerStackView.trailingAnchor.constraint(equalTo: intervieasyImageView.leadingAnchor)
        ]
        
        let sadImageViewConstraints = [
            sadImageView.centerYAnchor.constraint(equalTo: emptyHistoryStackView.centerYAnchor),
            sadImageView.centerXAnchor.constraint(equalTo: emptyHistoryStackView.centerXAnchor),
            sadImageView.widthAnchor.constraint(equalTo: emptyHistoryStackView.widthAnchor, multiplier: 0.6),
            sadImageView.heightAnchor.constraint(equalTo: emptyHistoryStackView.heightAnchor, multiplier: 0.6)
        ]
        
        let practiceEmptyLabelConstraints = [
            practiceEmptyLabel.topAnchor.constraint(equalTo: sadImageView.bottomAnchor, constant: -32),
            practiceEmptyLabel.widthAnchor.constraint(equalTo: sadImageView.widthAnchor, multiplier: 1.1)
        ]
        
        let emptyHistoryStackViewConstraints = [
            emptyHistoryStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyHistoryStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            emptyHistoryStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            emptyHistoryStackView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let startPracticeButtonConstraints = [
            startPracticeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            startPracticeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startPracticeButton.heightAnchor.constraint(equalToConstant: 50),
            startPracticeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ]
        
        let bodyViewConstraints = [
            bodyView.topAnchor.constraint(equalTo: greetingTextHorStackView.bottomAnchor, constant: 32),
            bodyView.bottomAnchor.constraint(equalTo: startPracticeButton.topAnchor, constant: -32),
            bodyView.leadingAnchor.constraint(equalTo: emptyHistoryStackView.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: emptyHistoryStackView.trailingAnchor)
        ]
        
        let practiceHistoryLabelConstrains = [
            practiceHistoryLabel.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 16),
            practiceHistoryLabel.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 16),
            practiceHistoryLabel.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -16),
        ]
        
        let practiceHistoryListTableViewConstraints = [
            practiceHistoryListTableView.topAnchor.constraint(equalTo: practiceHistoryLabel.bottomAnchor, constant: 16),
            practiceHistoryListTableView.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -8),
            practiceHistoryListTableView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor),
            practiceHistoryListTableView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(bodyViewConstraints)
        NSLayoutConstraint.activate(practiceHistoryLabelConstrains)
        NSLayoutConstraint.activate(practiceHistoryListTableViewConstraints)
        NSLayoutConstraint.activate(emptyHistoryStackViewConstraints)
        NSLayoutConstraint.activate(sadImageViewConstraints)
        NSLayoutConstraint.activate(practiceEmptyLabelConstraints)
        NSLayoutConstraint.activate(topViewConstraints)
        NSLayoutConstraint.activate(greetingTextHorStackViewConstraints)
        NSLayoutConstraint.activate(intervieasyImageViewConstraints)
        NSLayoutConstraint.activate(greetingVerStackViewConstraints)
        NSLayoutConstraint.activate(startPracticeButtonConstraints)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listPractice.count == 0{
            configureView()
        }
        
        return listPractice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PracticeHistoryTableViewCell.identifier, for: indexPath) as? PracticeHistoryTableViewCell else {
            
            return UITableViewCell()
        }
          
        cell.setup(with: listPractice[indexPath.row])
        
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultVc = ResultViewController()
        
        resultVc.shouldConfigureIndex = true
        resultVc.configureIndex(with: indexPath.row)
        self.navigationController?.pushViewController(resultVc, animated: true)
    }
}
