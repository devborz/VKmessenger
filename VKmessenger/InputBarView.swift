//
//  InputBarView.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 03.11.2020.
//

import UIKit

class InputBarView: UIView {

    // MARK: Delegate & DataSource instances
    
    var delegate: InputBarViewDelegate?
    
    var dataSource: InputBarViewDataSource?
    
    // MARK: Views
    
    var itemsCollectionView: UICollectionView!
    
    let separatorView = UIView()
    
    let textView = UITextView()
    
    let inputContainerView = UIView()
    
    let rightContainerView = UIView()
    
    let attachButton = UIButton()
    
    let sendButton = UIButton()
    
    let recordButton = UIButton()
    
    var messageToReplyView: UIView!
    
    // MARK: Constraints
    
    var textViewHeightConstraint: NSLayoutConstraint?
    
    var collectionViewHeightConstraint: NSLayoutConstraint?
    
    var collectionViewTopConstraint: NSLayoutConstraint?
    
    var separatorHeightConstraint: NSLayoutConstraint?
    
    var sendButtonHeightConstraint: NSLayoutConstraint?
    
    var recordButtonHeightConstraint: NSLayoutConstraint?
    
    // MARK: Attached Data
    
    var messageToReply: Message?
    
    var attachedItems: [AttachedItem] = []
    
    // MARK: Conditions
    
    var textViewIsOversized = false {
        didSet {
            guard oldValue != textViewIsOversized else {
                return
            }
            textView.isScrollEnabled = textViewIsOversized
            if textViewIsOversized {
                textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: textView.contentSize.height)
                textViewHeightConstraint?.isActive = true
            } else {
                textViewHeightConstraint?.isActive = false
            }
            textView.setNeedsUpdateConstraints()
        }
    }
    
    var countOfAttachedItems = 0 {
        didSet {
            if (oldValue == 0 && countOfAttachedItems > 0) || (oldValue > 0 && countOfAttachedItems == 0) {
                if countOfAttachedItems == 0 {
                    collectionViewHeightConstraint?.constant = 0
                    collectionViewTopConstraint?.constant = 0
                    separatorHeightConstraint?.constant = 0
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
                        self.delegate?.didChangedHeight(self, difference: -108)
                        self.superview?.layoutIfNeeded()
                    }, completion: nil)
                    if textViewIsEmpty {
                        inputViewIsEmpty = true
                    }
                } else {
                    collectionViewHeightConstraint?.constant = 100
                    collectionViewTopConstraint?.constant = 8
                    separatorHeightConstraint?.constant = 0.5
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
                        self.delegate?.didChangedHeight(self, difference: 108)
                        self.superview?.layoutIfNeeded()
                    }, completion: nil)
                    inputViewIsEmpty = false
                }
            }
        }
    }
    
    var textViewNeedsPlaceHolder = true {
        didSet {
            if oldValue != textViewNeedsPlaceHolder {
                if textViewNeedsPlaceHolder {
                    addPlaceholder()
                } else {
                    removePlaceholder()
                }
            }
        }
    }
    
    var textViewIsEmpty = true {
        didSet {
            if oldValue != textViewIsEmpty {
                if textViewIsEmpty {
                    if countOfAttachedItems == 0 {
                        inputViewIsEmpty = true
                    }
                } else {
                    inputViewIsEmpty = false
                }
            }
        }
    }
    
    var inputViewIsEmpty = true {
        didSet {
            if oldValue != inputViewIsEmpty {
                if inputViewIsEmpty {
                    currentRightButton = .record
                } else {
                    currentRightButton = .send
                }
            }
        }
    }
    
    var textViewHeight: CGFloat = 0
    
    enum RightButton {
    case send
    case record
    }
    
    var currentRightButton: RightButton = .record {
        didSet {
            if oldValue != currentRightButton {
                switch currentRightButton {
                case .record: showRecordButton()
                case .send: showSendButton()
                }
            }
        }
    }
    
    // MARK: Initializaton
    
    init() {
        super.init(frame: .zero)
        
        setupAttachButton()
        
        setupInputContainerView()
        
        setupCollectionView()
        
        setupInputTextView()
        
        setupRightButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    func setupReplyView() {
        messageToReplyView = UIView()
        messageToReplyView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageToReplyView)
        
        messageToReplyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageToReplyView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        messageToReplyView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        messageToReplyView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        messageToReplyView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let leftVerticalLine = UIView()
        leftVerticalLine.translatesAutoresizingMaskIntoConstraints = false
        messageToReplyView.addSubview(leftVerticalLine)
        
        leftVerticalLine.topAnchor.constraint(equalTo: messageToReplyView.topAnchor, constant: 5).isActive = true
        leftVerticalLine.leftAnchor.constraint(equalTo: messageToReplyView.leftAnchor, constant: 50).isActive = true
        leftVerticalLine.widthAnchor.constraint(equalToConstant: 2).isActive = true
        leftVerticalLine.bottomAnchor.constraint(equalTo: messageToReplyView.bottomAnchor, constant: -5).isActive = true
        leftVerticalLine.backgroundColor = .systemBlue
        leftVerticalLine.layer.cornerRadius = 1
        leftVerticalLine.clipsToBounds = true
        
        let senderNameLabel = UILabel()
        senderNameLabel.text = messageToReply?.sender.userName
        senderNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        senderNameLabel.textColor = .systemBlue
        senderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageToReplyView.addSubview(senderNameLabel)
        
        senderNameLabel.topAnchor.constraint(equalTo: messageToReplyView.topAnchor, constant: 8).isActive = true
        senderNameLabel.leftAnchor.constraint(equalTo: leftVerticalLine.rightAnchor, constant: 5).isActive = true
        senderNameLabel.rightAnchor.constraint(equalTo: messageToReplyView.rightAnchor, constant: -50).isActive = true
        
        let contentDescriptionLabel = UILabel()
        contentDescriptionLabel.text = "Сообщение"
        contentDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
        contentDescriptionLabel.textColor = .systemGray
        contentDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        messageToReplyView.addSubview(contentDescriptionLabel)
        
        contentDescriptionLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 5).isActive = true
        contentDescriptionLabel.leftAnchor.constraint(equalTo: leftVerticalLine.rightAnchor, constant: 5).isActive = true
        contentDescriptionLabel.rightAnchor.constraint(equalTo: messageToReplyView.rightAnchor, constant: -50).isActive = true
        
        let removeButton = UIButton()
        removeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeButton.tintColor = .systemGray
        removeButton.addTarget(self, action: #selector(didPressMessageToReplyRemove), for: .touchUpInside)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        messageToReplyView.addSubview(removeButton)
        
        removeButton.topAnchor.constraint(equalTo: messageToReplyView.topAnchor, constant: 10).isActive = true
        removeButton.rightAnchor.constraint(equalTo: messageToReplyView.rightAnchor, constant: -15).isActive = true
        removeButton.bottomAnchor.constraint(equalTo: messageToReplyView.bottomAnchor, constant: -10).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 45, height: 45)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let itemsCollectionView = itemsCollectionView else { return }
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        
        itemsCollectionView.register(AttachedItemCell.self, forCellWithReuseIdentifier: "AttachedItemCell")
        
        itemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(itemsCollectionView)
        
        collectionViewTopConstraint = itemsCollectionView.topAnchor.constraint(equalTo: inputContainerView.topAnchor)
        collectionViewTopConstraint?.isActive = true
        itemsCollectionView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 0).isActive = true
        itemsCollectionView.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: 0).isActive = true
        collectionViewHeightConstraint = itemsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        
        collectionViewHeightConstraint?.isActive = true
        
        itemsCollectionView.backgroundColor = .clear
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(separatorView)
        
        separatorView.topAnchor.constraint(equalTo: itemsCollectionView.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 10).isActive = true
        separatorView.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: -10).isActive = true
        separatorHeightConstraint = separatorView.heightAnchor.constraint(equalToConstant: 0)
        separatorHeightConstraint?.isActive = true
        
        separatorView.backgroundColor = .systemGray4
    }
    
    func setupInputContainerView() {
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(inputContainerView)
        
        inputContainerView.leftAnchor.constraint(equalTo: attachButton.rightAnchor, constant: 5).isActive = true
        let topConstraint = inputContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        topConstraint.isActive = true
        inputContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        inputContainerView.backgroundColor = UIColor(named: "color2")
        inputContainerView.layer.cornerRadius = 17
        inputContainerView.layer.borderWidth = 0
        inputContainerView.clipsToBounds = true
        inputContainerView.layer.masksToBounds = true
    }
    
    func setupInputTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: -8).isActive = true
        textView.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        textView.heightAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        
        textView.backgroundColor = UIColor(named: "color2")
        textView.delegate = self
        textView.textColor = .lightGray
        textView.endEditing(true)
        textView.alwaysBounceVertical = true
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isScrollEnabled = false
        textView.keyboardDismissMode = .interactive
        
        textView.text = "Сообщение"
        textView.sizeToFit()
        textViewHeight = textView.frame.height
    }
    
    func setupAttachButton() {
        attachButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(attachButton)
        
        attachButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        attachButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        attachButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        attachButton.heightAnchor.constraint(equalTo: attachButton.widthAnchor).isActive = true
        
        attachButton.addTarget(self, action: #selector(didPressAttachButton), for: .touchUpInside)
        
        attachButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        attachButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        attachButton.contentMode = .scaleAspectFit
    }
    
    func setupRightButtons() {
        rightContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightContainerView)
        
        rightContainerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        rightContainerView.leftAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant:  5).isActive = true
        rightContainerView.widthAnchor.constraint(equalTo: rightContainerView.heightAnchor).isActive = true
        rightContainerView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        rightContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        setupRecordButton()
    }
    
    func setupSendButton() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        rightContainerView.addSubview(sendButton)
        
        sendButton.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor).isActive = true
        sendButtonHeightConstraint = sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor)
        sendButtonHeightConstraint?.isActive = true
        
        sendButton.addTarget(self, action: #selector(didPressSendButton), for: .touchUpInside)
        
        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        sendButton.setTitle(nil, for: .normal)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        sendButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        sendButton.contentMode = .scaleAspectFit
    }
    
    func setupRecordButton() {
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        rightContainerView.addSubview(recordButton)
        
        recordButton.centerYAnchor.constraint(equalTo: rightContainerView.centerYAnchor).isActive = true
        recordButton.centerXAnchor.constraint(equalTo: rightContainerView.centerXAnchor).isActive = true
        recordButtonHeightConstraint = recordButton.heightAnchor.constraint(equalTo: recordButton.widthAnchor)
        recordButtonHeightConstraint?.isActive = true
        
        recordButton.addTarget(self, action: #selector(didTouchUpOutsideRecordButton), for: .touchUpOutside)
        recordButton.addTarget(self, action: #selector(didTouchUpInsideRecordButton), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(didTouchDownRecordButton), for: .touchDown)
        
        
        recordButton.setImage(UIImage(systemName: "mic"), for: .normal)
        recordButton.setTitle(nil, for: .normal)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        recordButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        recordButton.contentMode = .scaleAspectFit
    }
    
    // MARK:  Actions
    
    @objc func didPressAttachButton() {
        textView.endEditing(true)
        if countOfAttachedItems <= 10 {
            delegate?.didPressAttachButton(self)
        }
    }
    
    @objc func didPressSendButton() {
        if !inputViewIsEmpty {
            var text: String?
            
            if !textViewIsEmpty {
                text = textView.text
                
                if attachedItems.count == 0 && MessageProccesser.formatMessage(text!) == "" {
                    return
                }
                textView.text = nil
                textViewHeight = 35
                textViewIsEmpty = true
                textView.isScrollEnabled = false
                textViewHeightConstraint?.isActive = false
                textView.setNeedsUpdateConstraints()
                
                text = MessageProccesser.formatMessage(text!)
            } else {
                text = ""
            }
        
            var attachedMessage: AttachedItem?
            
            if let messageToReply = messageToReply {
                attachedMessage = .Message(message: messageToReply)
                self.messageToReply = nil
                messageToReplyView.removeFromSuperview()
            }
            
            let message = Message(sender: dataSource!.currentSender(self), messageId: "2", sentDate: Date().addingTimeInterval(-86400), kind: .standart(text: text!, attachedItems: attachedItems, messageToReply: attachedMessage), type: .outgoing, state: .unread)
            
            attachedItems = []
            itemsCollectionView.reloadSections([0])
            
            delegate?.didPressSendButton(self, with: message)
            
        }
    }
    
    @objc func didTouchUpInsideRecordButton() {
        print("end")
    }
    
    @objc func didTouchUpOutsideRecordButton() {
        print("fix")
    }
    
    @objc func didTouchDownRecordButton() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        print("begin")
    }
    
    @objc func didPressMessageToReplyRemove() {
        messageToReplyView.removeFromSuperview()
        messageToReplyView = nil
        messageToReply = nil
    }
    
    func addPlaceholder() {
        if textView.text.isEmpty {
            textView.text = "Сообщение"
            textView.textColor = .lightGray
        }
    }
    
    func removePlaceholder() {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = UIColor(named: "TextColor")
        }
    }
    
    func showRecordButton() {
        setupRecordButton()
        self.recordButton.alpha = 1
        self.recordButton.transform = CGAffineTransform.identity.scaledBy(x: 1/2, y: 1/2)
        UIView.animate(withDuration: 0.15) {
            self.recordButton.transform = self.recordButton.transform.scaledBy(x: 2, y: 2)
        } completion: { (completed) in
            if completed {
            }
        }
        self.sendButton.alpha = 0
        self.sendButton.removeFromSuperview()
    }
    
    func showSendButton() {
        setupSendButton()
        sendButton.alpha = 1
        sendButton.transform = self.sendButton.transform.scaledBy(x: 1/2, y: 1/2)
        UIView.animate(withDuration: 0.15) {
            self.sendButton.transform = self.sendButton.transform.scaledBy(x: 2, y: 2)
        } completion: { (completed) in
            if completed {
            }
        }
        self.recordButton.alpha = 0
        self.recordButton.removeFromSuperview()
    }
}

// MARK: TextView Delegate

extension InputBarView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if !textViewIsOversized { textView.sizeToFit() }
        let linesCount = textView.text.components(separatedBy: "\n").count - 1
        if linesCount == 6 {
            textViewIsOversized = !textViewIsOversized
        } else {
            textViewIsOversized = linesCount > 6
        }
        let currentTextViewHeight = textView.frame.height
        if textViewHeight != currentTextViewHeight {
            delegate?.didChangedHeight(self, difference: currentTextViewHeight - textViewHeight)
            textViewHeight = currentTextViewHeight
        }
        textViewIsEmpty = textView.text == ""
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewNeedsPlaceHolder = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewNeedsPlaceHolder = true
    }
}

// MARK: CollectionView Delegate & DataSource

extension InputBarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        countOfAttachedItems = attachedItems.count
        return countOfAttachedItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachedItemCell", for: indexPath) as! AttachedItemCell
        let item = attachedItems[indexPath.item]
        
        cell.setup(item)
        cell.delegate = self
        cell.dataSource = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 95)
    }
}

// MARK: Cell Delegate & DataSource

extension InputBarView: AttachedItemCellDelegate, AttachedItemCellDataSource {
    func didTapDeleteItem(withIndexPath indexPath: IndexPath) {
        attachedItems.remove(at: indexPath.item)
        itemsCollectionView.deleteItems(at: [indexPath])
        itemsCollectionView.reloadData()
    }
    
    func indexPath(forCell cell: AttachedItemCell) -> IndexPath? {
        return itemsCollectionView.indexPath(for: cell)
    }
}

// MARK: Messages Delegate

extension InputBarView: MessagesDelegate {
    func didSelectItemToAttach(_ attachedItem: AttachedItem) {
        attachedItems.append(attachedItem)
        itemsCollectionView.reloadSections([0])
    }
    
    func didSelectMessageToReply(_ message: Message) {
        if messageToReply != nil {
            messageToReplyView.removeFromSuperview()
        }
        messageToReply = message
        setupReplyView()
        textView.becomeFirstResponder()
    }
}

// MARK: Delegate & DataSource

protocol InputBarViewDelegate {
    func didPressSendButton(_ inputBarView: InputBarView, with message: Message)
    
    func didPressAttachButton(_ inputBarView: InputBarView)
    
    func didEndRecording(_ inputBarView: InputBarView, voiceMesage: String)
    
    func didChangedHeight(_ inputBarView: InputBarView, difference: CGFloat)
}

protocol InputBarViewDataSource {
    
    func currentSender(_ inputBarView: InputBarView) -> User
}
