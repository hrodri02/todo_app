//
//  GroupTVCell.swift
//  productivityTracker
//
//  Created by Eri on 4/30/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit
import AVFoundation

class GroupTVCell: UITableViewCell
{
    var groupVC: GroupVC?
    
    var task: Task? {
        didSet {
            if let seconds = task?.seconds {
                setTextFields(time: TimeInterval(seconds))
            }
            
            if oldValue == nil {
                setCheckBox()
            }
        }
    }
    
    fileprivate var time = ""
    
    let taskNameTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "AvenirNext-Bold", size: 14.0)
        textfield.backgroundColor = UIColor(percent: 0.87)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var hoursTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "AvenirNext-Bold", size: 14.0)
        textfield.textColor = .black
        textfield.placeholder = "00"
        textfield.textAlignment = .right
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.addTarget(self, action: #selector(hoursTextFieldDidChange), for: UIControlEvents.editingChanged)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    @objc func hoursTextFieldDidChange(textfield: UITextField) {
        if let numChars = textfield.text?.count {
            if numChars >= 1 {
                secsTextField.becomeFirstResponder()
            }
        }
    }
    
    let hoursLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 14.0)
        label.textColor = UIColor(percent: 0.75)
        label.text = "h"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var minsTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "AvenirNext-Bold", size: 14.0)
        textfield.textColor = .black
        textfield.placeholder = "00"
        textfield.textAlignment = .right
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.addTarget(self, action: #selector(minsTextFieldDidChange), for: UIControlEvents.editingChanged)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    @objc func minsTextFieldDidChange(textfield: UITextField) {
        if let numChars = textfield.text?.count {
            if numChars >= 1 {
                secsTextField.becomeFirstResponder()
            }
        }
    }
    
    let minsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 14.0)
        label.textColor = UIColor(percent: 0.75)
        label.text = "m"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var secsTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "AvenirNext-Bold", size: 14.0)
        textfield.textColor = .black
        textfield.placeholder = "00"
        textfield.textAlignment = .right
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let secsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 14.0)
        label.textColor = UIColor(percent: 0.75)
        label.text = "s"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var startStopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = UIColor(r: 135/255, g: 206/255, b: 250/255)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(percent: 0.90)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var audioPlayer = AVAudioPlayer()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: .subtitle, reuseIdentifier: "GroupTVCell")
        
        secsTextField.delegate = self
        minsTextField.delegate = self
        hoursTextField.delegate = self
        
        resetButton.isEnabled = false
        
        setupImageView()
        setupAuidoPlayer()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        imageView?.image = UIImage(named: "unchecked_checkbox")
        imageView?.isUserInteractionEnabled = true
        imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCheckBoxTap(_:))))
    }
    
    func setupAuidoPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "alarm_clock", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
                
            }
        }
        catch {
            print(error)
        }
    }
    
    func addSubviews() {
        addSubview(taskNameTextField)
        addSubview(hoursTextField)
        addSubview(minsTextField)
        addSubview(secsTextField)
        
        addSubview(hoursLabel)
        addSubview(minsLabel)
        addSubview(secsLabel)
        addSubview(startStopButton)
        addSubview(resetButton)
    }
    
    func setupConstraints() {
        setupTaskName()
        setupSecsLabel()
        setupSecsTextField()
        setupMinsLabel()
        setupMinsTextField()
        setupHoursLabel()
        setupHoursTextField()
        setupStartStopButton()
        setupResetButton()
    }
    
    func setupTaskName() {
        guard let imageViewRightAnchor = imageView?.rightAnchor else {return}
        guard let imageViewTopAnchor = imageView?.topAnchor else {return}
        
        taskNameTextField.leftAnchor.constraint(equalTo: imageViewRightAnchor, constant: 5).isActive = true
        taskNameTextField.rightAnchor.constraint(equalTo: centerXAnchor).isActive = true
        taskNameTextField.topAnchor.constraint(equalTo: imageViewTopAnchor).isActive = true
    }
    
    func setupSecsLabel() {
        secsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        secsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
    
    func setupSecsTextField() {
        secsTextField.rightAnchor.constraint(equalTo: secsLabel.leftAnchor, constant: -1).isActive = true
        secsTextField.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
    
    func setupMinsLabel() {
        minsLabel.rightAnchor.constraint(equalTo: secsTextField.leftAnchor, constant: -3).isActive = true
        minsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
    
    func setupMinsTextField() {
        minsTextField.rightAnchor.constraint(equalTo: minsLabel.leftAnchor, constant: -1).isActive = true
        minsTextField.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
    
    func setupHoursLabel() {
        hoursLabel.rightAnchor.constraint(equalTo: minsTextField.leftAnchor, constant: -3).isActive = true
        hoursLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
    
    func setupHoursTextField() {
        hoursTextField.rightAnchor.constraint(equalTo: hoursLabel.leftAnchor, constant: -1).isActive = true
        hoursTextField.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
    
    func setupStartStopButton() {
        startStopButton.rightAnchor.constraint(equalTo: resetButton.leftAnchor, constant: -5).isActive = true
        startStopButton.topAnchor.constraint(equalTo: secsTextField.bottomAnchor, constant: 1).isActive = true
        startStopButton.widthAnchor.constraint(equalToConstant: startStopButton.intrinsicContentSize.width + 4).isActive = true
        startStopButton.heightAnchor.constraint(equalToConstant: startStopButton.intrinsicContentSize.height - 2).isActive = true
    }
    
    func setupResetButton() {
        resetButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        resetButton.topAnchor.constraint(equalTo: secsTextField.bottomAnchor, constant: 1).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: resetButton.intrinsicContentSize.width + 4).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: resetButton.intrinsicContentSize.height - 2).isActive = true
    }
    
    @objc func handleCheckBoxTap(_ sender: UITapGestureRecognizer) {
        toggleIsComplete()
        updatCheckBox()
        updateTaskInDB()
    }
    
    func toggleIsComplete() {
        guard var taskCompleted = task?.isComplete else {return}
        taskCompleted = !taskCompleted
        task?.isComplete = taskCompleted
    }
    
    func updateTaskInDB() {
        guard let groupId = groupVC?.group?.id else {return}
        guard let taskUpdated = task else {return}
        groupVC?.putTask(groupId, taskUpdated)
    }
    
    func setCheckBox() {
        guard let taskCompleted = task?.isComplete else {return}
        if taskCompleted {
            imageView?.image = UIImage(named: "checked_checkbox")
        }
        else {
            imageView?.image = UIImage(named: "unchecked_checkbox")
        }
    }
    
    func updatCheckBox() {
        guard let taskCompleted = task?.isComplete else {return}
        
        print("update checkbox")
        
        if taskCompleted {
            imageView?.image = UIImage(named: "checked_checkbox")
            groupVC?.group?.numTasksCompleted += 1
        }
        else {
            imageView?.image = UIImage(named: "unchecked_checkbox")
            groupVC?.group?.numTasksCompleted -= 1
        }
    }
    
    func setTextFields(time: TimeInterval) {
        let hours = Int(time) / 3600
        let mins = Int(time) / 60 % 60
        let secs = Int(time) % 60
        
        if hours > 0 || hoursTextField.text! != "" {
            hoursTextField.text = String(describing: hours)
        }
        
        if hours > 0 || mins > 0 || minsTextField.text! != "" {
            minsTextField.text = String(describing: mins)
        }
        
        if hours > 0  || mins > 0 || secs > 0 || secsTextField.text! != "" {
            secsTextField.text = String(describing: secs)
        }
        
        self.time = hoursTextField.text! + minsTextField.text! + secsTextField.text!
    }
}

extension GroupTVCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // shift characters right when user deletes a character
        if string.count == 0 {
            time.remove(at: time.index(before: time.endIndex))
        }
        else {
            // shift characters left when user enters a valid character
            if !string.isInt() {
                return false
            }
            
            if time.count == 6 {
                time.remove(at: time.startIndex)
            }
            
            time += string
        }
        
        var secs = ""
        var mins = ""
        var hours = ""
        
        for i in 0 ..< time.count {
            let index = (time.count - 1) - i
            let char = String(describing: time[index])
            
            switch i {
            case 0, 1:
                secs = char + secs
            case 2, 3:
                mins = char + mins
            case 4, 5:
                hours = char + hours
            default:
                break
            }
        }
        
        self.secsTextField.text = secs
        self.minsTextField.text = mins
        self.hoursTextField.text = hours
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        secsTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        time = self.hoursTextField.text! + self.minsTextField.text! + self.secsTextField.text!
        computeSecs()
    }
    
    func computeSecs() {
        task?.seconds = 0
        guard var seconds = task?.seconds else {return}
        
        if let secsStr = secsTextField.text, let secs = Int(secsStr) {
            seconds += secs
        }
        
        if let minsStr = minsTextField.text, let mins = Int(minsStr)  {
            seconds += mins * 60
        }
        
        if let hoursStr = hoursTextField.text, let hours = Int(hoursStr) {
            seconds += hours * 3600
        }
        
        task?.seconds = seconds
        task?.secondsSelected = seconds
        setTextFields(time: TimeInterval(seconds))
    }
}
