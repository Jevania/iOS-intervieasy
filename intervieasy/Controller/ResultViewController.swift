//
//  ResultViewController.swift
//  intervieasy
//
//  Created by jevania on 08/05/24.
//

import UIKit
import AVFoundation
import AVKit

enum SpeakingComponent: String {
    case pace = "pace"
    case articulation = "articulation"
    case smoothness = "smoothness"
}

struct Indicator{
    var image: String? = ""
    var score: String? = ""
    var scoreDesc: String? = ""
    var indicatorDesc: String? = ""
    var backgroundColor: UIColor? = .white
}

class ResultViewController: UIViewController {
    
    var listPractice = PracticeService().getAllPractice()
    
    var listIndicator: [Indicator] = []
    var selectedIndicator: Indicator!
    
    var index: Int = 0
    var shouldConfigureIndex: Bool = true
    
    private var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ic-star")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var scoreLabel: UILabel = {
        let label = UILabel()
        label.configure(withText: "90", size: 44, weight: .bold)
        
        return label
    }()
    
    private var congratsLabel: UILabel = {
        let label = UILabel()
        label.configure(withText: "Congratulation!", size: 24, weight: .semibold)
        
        return label
    }()
    
    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    private let replayVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Replay Practice Video", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                button.addTarget(self, action: #selector(didTapReplayVideoButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func didTapReplayVideoButton() {
        let newUrl = URL(fileURLWithPath: listPractice[index].videoUrl ?? "")
        let player = AVPlayer(url: newUrl)
        
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
    }
    
    func configureIndex(with selectedIndex: Int) {
        index = selectedIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !shouldConfigureIndex{
            index = listPractice.count-1
        }
        
        view.backgroundColor = .white
        
        topView = TopHomeView(frame: CGRect(x: 0, y: 0, width: Int(view.bounds.width), height: Int(view.bounds.height*0.6)))
        
        view.addSubview(topView)
        
        starImageView.addSubview(scoreLabel)
        
        view.addSubview(starImageView)
        view.addSubview(congratsLabel)
        
        setupTableView()
        configureIndicatorList()
        view.addSubview(resultTableView)
        view.addSubview(replayVideoButton)
        
        configureView()
        configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listPractice = PracticeService().getAllPractice()
        self.resultTableView.reloadData()
    }
    
    private func setupTableView(){
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    private func configureView(){
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.title = "\(listPractice[index].title ?? "") Result"
        
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(didTapDeleteButton))
        deleteButton.tintColor = .darkGray
        navigationItem.rightBarButtonItem = deleteButton
        
        let score = Int(((listPractice[index].wpm +
                          listPractice[index].articulation +
                          listPractice[index].smoothRate)/3).rounded())
        scoreLabel.text = String(score)
    }
    
    @objc private func didTapDeleteButton() {
        let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure to delete this practice mock interview?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            PracticeService().deletePractice(practice: self.listPractice.remove(at: self.index))
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func configureConstraints(){
        let topViewConstraints = [
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        let starImageViewConstraints = [
            starImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            starImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ]
        
        let scoreLabelConstraints = [
            scoreLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            scoreLabel.centerXAnchor.constraint(equalTo: starImageView.centerXAnchor),
            scoreLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            scoreLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
        ]
        
        let congratsLabelConstraints = [
            congratsLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 16),
            congratsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            congratsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            congratsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            congratsLabel.heightAnchor.constraint(equalToConstant: 32)
        ]
        
        let resultTableViewConstraints = [
            resultTableView.topAnchor.constraint(equalTo: congratsLabel.bottomAnchor, constant: 16),
            resultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultTableView.heightAnchor.constraint(equalToConstant: CGFloat((100*4) + 4))
        ]
        
        let replayVideoButtonConstraints = [
            replayVideoButton.topAnchor.constraint(equalTo: resultTableView.bottomAnchor, constant: 4),
            replayVideoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            replayVideoButton.heightAnchor.constraint(equalToConstant: 50),
            replayVideoButton.leadingAnchor.constraint(equalTo: resultTableView.leadingAnchor, constant: 8),
            replayVideoButton.trailingAnchor.constraint(equalTo: resultTableView.trailingAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(topViewConstraints)
        NSLayoutConstraint.activate(starImageViewConstraints)
        NSLayoutConstraint.activate(scoreLabelConstraints)
        NSLayoutConstraint.activate(congratsLabelConstraints)
        NSLayoutConstraint.activate(resultTableViewConstraints)
        NSLayoutConstraint.activate(replayVideoButtonConstraints)
    }
    
    private func configureIndicatorList(){
        let wpm = Indicator(
            image: "ic-pace",
            score: "\(Int(listPractice[index].wpm.rounded())) WPM",
            scoreDesc: getDescription(.pace, Int(listPractice[index].wpm.rounded())),
            indicatorDesc: "Speaking pace is measured in words per minute (WPM), determining the speed at which you deliver your speech. Aim for 125-150 wpm for clear communication without rushing or losing your audience's attention. Fun Fact: Some of the most engaging TED Talks maintain a pace of around 135 wpm.",
            backgroundColor: .shadowYellow
        )
        
        let articulation = Indicator(
            image: "ic-articulation",
            score: String("\(Int(listPractice[index].articulation.rounded()))"),
            scoreDesc: getDescription(.articulation,
                                      Int(listPractice[index].articulation)),
            indicatorDesc: "Articulation refers to the clarity and precision with which you pronounce words and express sounds while speaking. Good articulation enhances communication by preventing misunderstandings and improving comprehension, helping you convey your message effectively and confidently. Did you know? Award-winning public speakers often achieve near-perfect articulation, with less than one mispronunciation per minute.",
            backgroundColor: .shadowTosca
        )
        
        let smoothness = Indicator(
            image: "ic-smoothness",
            score: String("\(Int(listPractice[index].smoothRate))"),
            scoreDesc: getDescription(.smoothness,
                                      Int(listPractice[index].smoothRate)),
            indicatorDesc: "Smoothness is key to captivating your audience. It refers to the fluidity and coherence of your speech delivery, avoiding awkward pauses or disruptions that may detract from the overall message. Interesting Fact: Some of history's most memorable speeches are praised for their smooth delivery, with transitions so seamless they seem effortless.",
            backgroundColor: .shadowPurple
        )
        
        let totalFillerWordUsed = listPractice[index].fwEh + listPractice[index].fwHa + listPractice[index].fwHm
        let ehWord = listPractice[index].fwEh == 1 ? "filler" : "fillers"
        let haWord = listPractice[index].fwHa == 1 ? "filler" : "fillers"
        let umWord = listPractice[index].fwHm == 1 ? "filler" : "fillers"
        
        let filler = Indicator(
            image: "ic-filler",
            score: String("\(totalFillerWordUsed) Fillers"),
            scoreDesc: "Eh = \(listPractice[index].fwEh) \(ehWord) | Ha = \(listPractice[index].fwHa), \(haWord) | Um = \(listPractice[index].fwHm) \(umWord)",
            indicatorDesc: "Eloquence is the ability to speak fluently, persuasively, and with grace. It involves conveying your message in a compelling and articulate manner, capturing the attention and interest of your audience. Did you know? The most eloquent speakers aim for zero filler words, allowing their message to flow smoothly and command attention effortlessly.",
            backgroundColor: .shadowGreen
        )
        
        listIndicator = [wpm, articulation, smoothness, filler]
    }
    
    private func getDescription(_ component: SpeakingComponent, _ score: Int) -> String{
        switch component {
        case .pace:
            if score <= 124 {
                return "A bit slow. Let's pick up the pace a touch!"
            } else if score <= 150 {
                return "Perfect, that's great!"
            } else {
                return "Pretty fast! Maybe ease off just a tad for clarity."
            }
        case .articulation:
            if score <= 25 {
                return "Needs improvement in articulation. Try to enunciate more clearly."
            } else if score <= 50 {
                return "Fair articulation. Keep practicing for clearer speech."
            } else if score <= 75 {
                return "Good articulation! Keep refining your speech for even better clarity."
            } else if score <= 99 {
                return "Excellent articulation! Your speech is very clear."
            } else {
                return "Perfect articulation! Your speech is crystal clear."
            }
        case . smoothness:
            if score <= 25 {
                return "Work on smoothness. Practice transitions between words for smoother speech."
            } else if score <= 50 {
                return "Fair smoothness. Keep practicing for smoother transitions."
            } else if score <= 75 {
                return "Good smoothness! Your speech flows well."
            } else if score <= 99 {
                return "Excellent smoothness! Your speech transitions seamlessly."
            } else {
                return "Perfect smoothness! Your speech flows effortlessly."
            }
        }
    }
}


extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier) as! ResultTableViewCell
        cell.backgroundColor = .clear
    
        if indexPath.row == 0{
            cell.setupCellColor(with: .shadowYellow)
            cell.componentLabel.text = "Speaking Pace"
            let wpm = listPractice[index].wpm
            cell.scoreLabel.text = "\(Int(wpm.rounded())) WPM"
            
        } else if indexPath.row == 1{
            cell.setupCellColor(with: .shadowTosca)
            cell.componentLabel.text = "Articulation Score"
            cell.scoreLabel.text = String("\(Int(listPractice[index].articulation.rounded()))")
            
        }else if indexPath.row == 2{
            cell.setupCellColor(with: .shadowPurple)
            cell.componentLabel.text = "Smooth Rate"
            cell.scoreLabel.text = String("\(Int(listPractice[index].smoothRate))")
            
        }else if indexPath.row == 3{
            cell.setupCellColor(with: .shadowGreen)
            let totalFillerWordUsed = listPractice[index].fwEh + listPractice[index].fwHa + listPractice[index].fwHm
            cell.componentLabel.text = "Eloquence"
            cell.scoreLabel.text = String("\(totalFillerWordUsed) \(totalFillerWordUsed == 1 ? "filler":"fillers")")
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndicator = listIndicator[indexPath.row]
    
        let indicatorVC = IndicatorViewController()
        indicatorVC.selectedIndicator = selectedIndicator
        
        self.present(indicatorVC, animated: true, completion: nil)
    }
    
}
