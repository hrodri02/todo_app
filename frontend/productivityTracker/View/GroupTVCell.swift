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
            
            if let secondsSelected = task?.secondsSelected {
                if secondsSelected == 0 {
                    resetButton.isEnabled = false
                }
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
        taskNameTextField.rightAnchor.constraint(equalTo: hoursTextField.leftAnchor, constant: -10).isActive = true
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
        
        // set hours textfield
        setHoursTextField(hours)
        
        // set mins textfield
        setMinsTextField(hours, mins)
        
        // set secs textfield
        setSecsTextField(hours, mins, secs)
        
        self.time = hoursTextField.text! + minsTextField.text! + secsTextField.text!
    }
    
    private func setHoursTextField(_ hours: Int) {
        if hours > 0 {
            hoursTextField.text = String(describing: hours)
        }
        else {
            hoursTextField.text = ""
        }
    }
    
    private func setMinsTextField(_ hours: Int, _ mins: Int) {
        if hours > 0 || mins > 0 {
            minsTextField.text = String(describing: mins)
        }
        else {
            minsTextField.text = ""
        }
        
        // appending 0 to the back
        if mins == 0 && hours > 0 {
            minsTextField.text! += "0"
        }
        
        // appending 0 to the front
        if (0 < mins && mins < 10) && (hours > 0) {
            minsTextField.text! = "0" + minsTextField.text!
        }
    }
    
    private func setSecsTextField(_ hours: Int, _ mins: Int, _ secs: Int) {
        if hours > 0  || mins > 0 || secs > 0 {
            secsTextField.text = String(describing: secs)
        }
        else if secsTextField.text! != "" {
            secsTextField.text = "0"
        }
        
        // appending 0 to the back
        if secs == 0 && (mins > 0 || hours > 0) {
            secsTextField.text! += "0"
        }
        
        // appending 0 to the front
        if (0 < secs && secs < 10) && (mins > 0 || hours > 0) {
            secsTextField.text! = "0" + secsTextField.text!
        }
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
        
        setTextFields(from: time)
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        secsTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        time = self.hoursTextField.text! + self.minsTextField.text! + self.secsTextField.text!
        
        time = time.removeLeadingZeros()
        
        setTextFields(from: time)
        
        guard let secs = secsTextField.text else {return}
        guard let mins = minsTextField.text else {return}
        guard let hours = hoursTextField.text else {return}
        
        computeSecs(hours: hours, mins: mins, secs: secs)
    }
    
    private func setTextFields(from time: String) {
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
    }
    
    func computeSecs(hours: String, mins: String, secs: String) {
        
        task?.seconds = 0
        guard var seconds = task?.seconds else {return}
        
        if let secs = Int(secs) {
            seconds += secs
        }
        
        if let mins = Int(mins) {
            seconds += mins * 60
        }
        
        if let hours = Int(hours) {
            seconds += hours * 3600
        }
        
        task?.seconds = seconds
        task?.secondsSelected = seconds
        
        if seconds > 0 {
            startStopButton.isEnabled = true
        }
        else {
            startStopButton.isEnabled = false
        }
        
        setTextFields(time: TimeInterval(seconds))
    }
}
