//
//  RecordingViewController.swift
//  intervieasy
//
//  Created by jevania on 07/05/24.
//

import UIKit
import Photos
import Speech
import SoundAnalysis

class RecordingViewController: UIViewController {
    
    var listPractice = PracticeService().getAllPractice()
    
    private let speechRecognizer: SFSpeechRecognizer = {
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) else {
            fatalError("Failed to initialize SFSpeechRecognizer")
        }
        return recognizer
    }()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    var speechResult: SFSpeechRecognitionResult?
    private let audioEngine = AVAudioEngine()
    
    var estimatedTime:Int = 0
    var minutes:Int = 1
    var timer:Timer = Timer()
    var isTimerRun:Bool = false
    var finalWord:Int = 0
    
    private var soundClassifier = try! FillerWordClassifier()
    let queue = DispatchQueue(label: "jevania.intervieasy")
    var streamAnalyzer: SNAudioStreamAnalyzer!
    var fillerWords = [(label: String, confidence: Float)]()
    
    var totalWord: Int?
    var wordsPerMinutes: Double = 0
    var averagePause: TimeInterval?
    var durationSpeak: String?
    
    var clearRate: Double = 0
    var smoothRate: Double = 0
    
    var videoSaveAt: String = ""
    var totalFwEh: Int = 0
    var totalFwHm: Int = 0
    var totalFwHa: Int = 0
    
    var cameraConfig: CameraHelper!
    let imagePickerController = UIImagePickerController()
    
    var videoRecordingStarted: Bool = false{
        didSet{
            if videoRecordingStarted {
                DispatchQueue.main.async {
                    self.toggleRecordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                    self.toggleRecordButton.tintColor = .systemRed
                }
            } else {
                DispatchQueue.main.async {
                    self.toggleRecordButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                }
            }
        }
    }
    
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let toggleCameraButton: RegularImageButton = {
        let button = RegularImageButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tintColor = .white
        button.layer.cornerRadius = 40
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera.fill"), for: .normal)
        
        button.addTarget(self, action: #selector(didTapToggleCameraButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapToggleCameraButton() {
        do {
            try cameraConfig.switchCameras()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private let toggleRecordButton: ImageButton = {
        let button = ImageButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .white
        button.tintColor = .blue2
        button.layer.cornerRadius = 50
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        
        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        
        button.addTarget(self, action: #selector(didTapToggleRecordButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Start Practice
    @objc private func didTapToggleRecordButton() {
        startPractice()
    }
    
    // MARK: Check camera permission
    func checkPermission(completion: @escaping ()->Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            completion()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    completion()
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        case .limited:
            print("User has limited the permission.")
        @unknown default:
            fatalError()
        }
    }
    
    fileprivate func registerNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name(rawValue: "App is going background"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        if videoRecordingStarted {
            videoRecordingStarted = false
            self.cameraConfig.stopRecording() { (error) in
                print(error ?? "Video recording error")
            }
        }
    }
    
    @objc func appCameToForeground() {
        print("App enters foreground")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blueBg
        
        view.addSubview(previewImageView)
        view.addSubview(toggleRecordButton)
        view.addSubview(toggleCameraButton)
        
        self.cameraConfig = CameraHelper()
        self.cameraConfig.currentCameraPosition = .front
        cameraConfig.setup { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            try? self.cameraConfig.displayPreview(self.previewImageView)
            self.toggleRecordButton.isUserInteractionEnabled = true
            self.toggleRecordButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        }
        
        configureView()
        configureConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            didCancelRecording()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        speechRecognizer.delegate = self
        
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.toggleRecordButton.isEnabled = true
                    
                case .denied:
                    self.toggleRecordButton.isEnabled = false
                    print("User denied access to speech recognition")
                    
                case .restricted:
                    self.toggleRecordButton.isEnabled = false
                    print("Speech recognition restricted on this device")
                    
                case .notDetermined:
                    self.toggleRecordButton.isEnabled = false
                    print("Speech recognition not yet authorized")
                    
                default:
                    self.toggleRecordButton.isEnabled = false
                }
            }
        }
        
    }
    
    // MARK: Filler Classifier
    func createClassificationRequest() {
        
        do {
            let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
            try streamAnalyzer.add(request, withObserver: self)
        } catch {
            fatalError("error adding the classification request")
        }
    }
    
    // MARK: Recording configuration
    private func startRecording() throws {
        // Cancel the previous task if it's running
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        
        // Create and configure the speech recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // MARK: On device
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [self] result, error in
            var isFinal = false
            
            if let result = result {
                let wordSpoken = result.bestTranscription.formattedString
                let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
                let components = wordSpoken.components(separatedBy: chararacterSet)
                let words = components.filter { !$0.isEmpty }
                totalWord = words.count
                
                self.speechResult = result
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.toggleRecordButton.isEnabled = true
                DispatchQueue.main.async {
                    self.toggleRecordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                    self.toggleRecordButton.tintColor = .systemRed
                }
            }
        }
        
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        streamAnalyzer = SNAudioStreamAnalyzer(format: recordingFormat)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
            self.queue.async {
                self.streamAnalyzer.analyze(buffer, atAudioFramePosition: when.sampleTime)
            }
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    // MARK: Timer
    func runTimer() {
        estimatedTime = 60 //decrease the secs
        minutes = 1
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        estimatedTime -= 1
        
        DispatchQueue.main.async {
            self.navigationItem.title = TimerHelper().getTime(timerCounting: self.estimatedTime)
        }
        speakFeedback()
    }
    
    func speakFeedback(){
        let speakTime = estimatedTime
        var wordShouldSay = 10
        
        if speakTime.isMultiple(of: 10){
            wordShouldSay = speakTime
        }
        
        if speakTime.isMultiple(of: 10) {
            if totalWord ?? 0 < wordShouldSay{
                showToast(message: "Speed it up, buddy!", fontSize:15)
            }
            else if totalWord ?? 0 > wordShouldSay{
                showToast(message: "Slow down, champ!", fontSize: 15)
            }
        }
    }
    
    //MARK: Speaking Result
    func speakingResult(){
        
        if (speechResult != nil){
            (averagePause, totalWord) = SpeakHelper().getWordPerMinutes(speakResult: self.speechResult)
            
            wordsPerMinutes = Double(totalWord ?? 0)*Double(60/estimatedTime)
            
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [self] (timer) in
                (clearRate, smoothRate) = SpeechArticulationHelper().getClearAndSmoothRate(speechFinishedResult: self.speechResult)
            }
        }else{
            print("there is no data to process")
        }
    }
    
    // MARK: Toast
    @objc fileprivate func showToastForSaved() {
        showToast(message: "Saved!", fontSize: 12.0)
    }
    
    @objc fileprivate func showToastForRecordingStopped() {
        showToast(message: "Recording Stopped", fontSize: 12.0)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showToast(message: "Could not save!! \n\(error)", fontSize: 12)
        } else {
            showToast(message: "Saved", fontSize: 12.0)
        }
    }
    
    @objc func video(_ video: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showToast(message: "Could not save!! \n\(error)", fontSize: 12)
        } else {
            showToast(message: "Saved", fontSize: 12.0)
        }
        print(video)
    }
    
    func startPractice(){
        if self.audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.toggleRecordButton.isEnabled = false
            
            self.timer.invalidate()
            self.speakingResult()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                PracticeService().savePractice(
                    title: "Practice \(self.listPractice.count+1)",
                    wpm: self.wordsPerMinutes,
                    articulation: self.clearRate,
                    smoothRate: self.smoothRate,
                    videoUrl: self.cameraConfig.getVideoUrl(),
                    fwEh: Int32(self.totalFwEh),
                    fwHa: Int32(self.totalFwHa),
                    fwHm:Int32(self.totalFwHm),
                    timeStamp: TimerHelper().getCurrentDate(),
                    score: (self.wordsPerMinutes + self.clearRate + self.smoothRate)/3)
                
                let resultVC = ResultViewController()
                self.present(resultVC, animated: true, completion: nil)
            }
        } else {
            do {
                try self.startRecording()
                
                self.toggleRecordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                self.toggleRecordButton.tintColor = .systemRed
                self.runTimer()
                
                createClassificationRequest()
            } catch {
                print("Recording Not Available")
                self.toggleRecordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                self.toggleRecordButton.tintColor = .systemRed
            }
        }
        
        if self.videoRecordingStarted {
            self.videoRecordingStarted = false
            self.cameraConfig.stopRecording { (error) in
                print(error ?? "Video recording error")
            }
            
        } else if !self.videoRecordingStarted {
            self.videoRecordingStarted = true
            self.cameraConfig.recordVideo { (url, error) in
                guard let url = url else {
                    print(error ?? "Video recording error")
                    return
                }
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(self.video(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    // MARK: back to main screen
    @objc private func didCancelRecording(){
        if videoRecordingStarted{
            let alert = UIAlertController(title: "Progress Not Going To Save", message: "Are you sure you want to go back? your progress is NOT going to save", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    self.navigationController?.popViewController(animated: true)
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                @unknown default:
                    fatalError()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    fatalError()
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func configureView(){
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.title = "00:01:00"
    }
    
    private func configureConstraints(){
        let previewImageViewConstraints = [
            previewImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let toggleRecordButtonConstraints = [
            toggleRecordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleRecordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64),
            toggleRecordButton.widthAnchor.constraint(equalToConstant: 100),
            toggleRecordButton.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        let toggleCameraButtonConstraints = [
            toggleCameraButton.leadingAnchor.constraint(equalTo: toggleRecordButton.trailingAnchor, constant: 32),
            toggleCameraButton.centerYAnchor.constraint(equalTo: toggleRecordButton.centerYAnchor)
        ]
        NSLayoutConstraint.activate(previewImageViewConstraints)
        NSLayoutConstraint.activate(toggleRecordButtonConstraints)
        NSLayoutConstraint.activate(toggleCameraButtonConstraints)
    }
}

extension RecordingViewController: SFSpeechRecognizerDelegate {
    
    // MARK: SFSpeechRecognizerDelegate
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            toggleRecordButton.isEnabled = true
            DispatchQueue.main.async {
                self.toggleRecordButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            }
        } else {
            toggleRecordButton.isEnabled = false
            print("Recognition Not Available")
            DispatchQueue.main.async {
                self.toggleRecordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                self.toggleRecordButton.tintColor = .systemRed
            }
        }
    }
}

extension RecordingViewController: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }
        var temp = [(label: String, confidence: Float)]()
        let sorted = result.classifications.sorted { (first, second) -> Bool in
            return first.confidence > second.confidence
        }
        for classification in sorted {
            let confidence = classification.confidence * 100
            if confidence > 5 {
                temp.append((label: classification.identifier, confidence: Float(confidence)))
                
                if classification.identifier == "eh" && confidence>=50 {
                    self.totalFwEh += 1
                }else if classification.identifier == "ha" && confidence>=50 {
                    self.totalFwHa += 1
                }else if classification.identifier == "hm" && confidence>=50 {
                    self.totalFwHm += 1
                }
            }
        }
        
        //MARK: Filler Word
        fillerWords = temp
    }
}
