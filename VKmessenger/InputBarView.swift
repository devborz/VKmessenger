//
//  InputBarView.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 03.11.2020.
//

import UIKit

class InputBarView: UIView {
    
    var delegate: InputBarViewDelegate?
    
    var inputTextView = UITextView()
    
    var textViewIsOversized = false {
        didSet {
            guard oldValue != textViewIsOversized else {
                return
            }
            inputTextView.isScrollEnabled = textViewIsOversized
            inputTextView.setNeedsUpdateConstraints()
        }
    }
    
    var inputTextViewContainerView = UIView()
    
    var rightButtonsContainerView = UIView()
    
    var attachButton = UIButton()
    
    var sendButton = UIButton()
    
    var recordButton = UIButton()
    
    var textViewIsEmpty = true {
        didSet {
            if oldValue != textViewIsEmpty {
                if textViewIsEmpty {
                    showRecordButton()
                } else {
                    showSendButton()
                }
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        attachButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        rightButtonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputTextViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        
        setupAttachButton()
        
        setupInputTextView()
        
        setupRightButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRightButtons() {
        self.addSubview(rightButtonsContainerView)
        
        rightButtonsContainerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        rightButtonsContainerView.leftAnchor.constraint(equalTo: inputTextViewContainerView.rightAnchor).isActive = true
        rightButtonsContainerView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightButtonsContainerView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        rightButtonsContainerView.bottomAnchor.constraint(equalTo: inputTextViewContainerView.bottomAnchor).isActive = true
        
        setupRecordButton()
        setupSendButton()
        self.sendButton.transform = self.recordButton.transform.scaledBy(x: 1/2, y: 1/2)
        sendButton.removeFromSuperview()
    }
    
    func setupAttachButton() {
        self.addSubview(attachButton)
        
        attachButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        attachButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        attachButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        attachButton.addTarget(self, action: #selector(didPressAttachButton), for: .touchUpInside)
        
        attachButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        attachButton.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        attachButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        attachButton.contentMode = .scaleAspectFit
    }
    
    func setupSendButton() {
        rightButtonsContainerView.addSubview(sendButton)
        
        sendButton.topAnchor.constraint(equalTo: rightButtonsContainerView.topAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: rightButtonsContainerView.rightAnchor).isActive = true
        sendButton.leftAnchor.constraint(equalTo: rightButtonsContainerView.leftAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: rightButtonsContainerView.bottomAnchor).isActive = true
        
        sendButton.addTarget(self, action: #selector(didPressSendButton), for: .touchUpInside)
        
        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        sendButton.setTitle(nil, for: .normal)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        sendButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        sendButton.contentMode = .scaleAspectFit
    }
    
    func setupRecordButton() {
        rightButtonsContainerView.addSubview(recordButton)
        
        recordButton.topAnchor.constraint(equalTo: rightButtonsContainerView.topAnchor).isActive = true
        recordButton.rightAnchor.constraint(equalTo: rightButtonsContainerView.rightAnchor).isActive = true
        recordButton.leftAnchor.constraint(equalTo: rightButtonsContainerView.leftAnchor).isActive = true
        recordButton.bottomAnchor.constraint(equalTo: rightButtonsContainerView.bottomAnchor).isActive = true
        
        recordButton.addTarget(self, action: #selector(didPressRecordButton), for: .touchUpInside)
        
        recordButton.setImage(UIImage(systemName: "mic"), for: .normal)
        recordButton.setTitle(nil, for: .normal)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        recordButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        recordButton.contentMode = .scaleAspectFit
    }
    
    @objc func didPressAttachButton() {
        delegate?.didPressAttachButton(self)
    }
    
    @objc func didPressSendButton() {
        delegate?.didPressSendButton(self, with: inputTextView.text)
        inputTextView.text = nil
        inputTextView.isScrollEnabled = false
        inputTextView.setNeedsUpdateConstraints()
        textViewIsEmpty = true
    }
    
    @objc func didPressRecordButton() {
        
    }
    
    func addPlaceholder() {
        if inputTextView.text.isEmpty {
            inputTextView.text = "Сообщение"
            inputTextView.textColor = .lightGray
        }
    }
    
    func removePlaceholder() {
        if inputTextView.textColor == .lightGray {
            inputTextView.text = nil
            inputTextView.textColor = UIColor(named: "TextColor")
        }
    }
    
    func showRecordButton() {
        setupRecordButton()
        self.recordButton.alpha = 0
        UIView.animate(withDuration: 0.15) {
            self.recordButton.alpha = 1
            self.recordButton.transform = self.recordButton.transform.scaledBy(x: 2, y: 2)
            self.sendButton.transform = self.sendButton.transform.scaledBy(x: 1/2, y: 1/2)
            self.sendButton.alpha = 0
        } completion: { (completed) in
            if completed {
                self.sendButton.removeFromSuperview()
            }
        }
    }
    
    func showSendButton() {
        setupSendButton()
        
        self.sendButton.alpha = 0
        UIView.animate(withDuration: 0.15) {
            self.recordButton.alpha = 0
            self.recordButton.transform = self.recordButton.transform.scaledBy(x: 1/2, y: 1/2)
            self.sendButton.transform = self.sendButton.transform.scaledBy(x: 2, y: 2)
            self.sendButton.alpha = 1
        } completion: { (completed) in
            if completed {
                self.recordButton.removeFromSuperview()
            }
        }
    }
    
    func setupInputTextView() {
        self.addSubview(inputTextViewContainerView)
        
        inputTextViewContainerView.leftAnchor.constraint(equalTo: attachButton.rightAnchor).isActive = true
        inputTextViewContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        inputTextViewContainerView.bottomAnchor.constraint(equalTo: attachButton.bottomAnchor).isActive = true
        inputTextViewContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        inputTextViewContainerView.addSubview(inputTextView)
        
        inputTextView.topAnchor.constraint(equalTo: inputTextViewContainerView.topAnchor).isActive = true
        inputTextView.leftAnchor.constraint(equalTo: inputTextViewContainerView.leftAnchor, constant: 8).isActive = true
        inputTextView.rightAnchor.constraint(equalTo: inputTextViewContainerView.rightAnchor, constant: -8).isActive = true
        inputTextView.bottomAnchor.constraint(equalTo: inputTextViewContainerView.bottomAnchor).isActive = true
        inputTextView.heightAnchor.constraint(equalTo: inputTextViewContainerView.heightAnchor).isActive = true
        inputTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        inputTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        
        inputTextViewContainerView.backgroundColor = UIColor(named: "InputViewColor")
        inputTextViewContainerView.layer.cornerRadius = 17
        inputTextViewContainerView.layer.borderWidth = 0
        inputTextViewContainerView.clipsToBounds = true
        inputTextViewContainerView.layer.masksToBounds = true
        
        inputTextView.backgroundColor = UIColor(named: "InputViewColor")
        inputTextView.delegate = self
        inputTextView.textColor = .lightGray
        inputTextView.endEditing(true)
        inputTextView.alwaysBounceVertical = true
        inputTextView.font = UIFont.systemFont(ofSize: 17)
        inputTextView.isScrollEnabled = false
        inputTextView.text = "Сообщение"
        
        inputTextView.keyboardDismissMode = .interactive
    }
}

extension InputBarView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if inputTextView.text.isEmpty {
            textViewIsEmpty = true
        } else {
            textViewIsEmpty = false
        }
        textViewIsOversized = textView.contentSize.height >= 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        removePlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        addPlaceholder()
    }
}

protocol InputBarViewDelegate {
    func didPressSendButton(_ inputBarView: InputBarView, with textInTextView: String)
    
    func didPressAttachButton(_ inputBarView: InputBarView)
    
    func didEndRecording(_ inputBarView: InputBarView, voiceMesage: String)
}
