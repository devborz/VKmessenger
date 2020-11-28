//
//  InputBarView.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 03.11.2020.
//

import UIKit

class InputBarView: UIView {
    
    // MARK Delegate & DataSource instances
    
    var delegate: InputBarViewDelegate?
    
    var dataSource: InputBarViewDataSource?
    
    // MARK - Views
    
    var itemsCollectionView: UICollectionView?
    
    let textView = UITextView()
    
    let inputViewContainerView = UIView()
    
    let rightButtonsContainerView = UIView()
    
    let attachButton = UIButton()
    
    let sendButton = UIButton()
    
    let recordButton = UIButton()
    
    // MARK - Constraints
    
    var textViewHeightCostraint: NSLayoutConstraint?
    
    var itemsCollectionViewHeightCostraint: NSLayoutConstraint?
    
    var itemsCollectionViewTopCostraint: NSLayoutConstraint?
    
    // MARK - Conditions
    
    var textViewIsOversized = false {
        didSet {
            guard oldValue != textViewIsOversized else {
                return
            }
            textView.isScrollEnabled = textViewIsOversized
            if textViewIsOversized {
                textViewHeightCostraint = textView.heightAnchor.constraint(equalToConstant: 200)
                textViewHeightCostraint?.isActive = true
            } else {
                textViewHeightCostraint?.isActive = false
            }
            textView.setNeedsUpdateConstraints()
        }
    }
    
    var countOfAttachedItems = 0 {
        didSet {
            if (oldValue == 0 && countOfAttachedItems > 0) || (oldValue > 0 && countOfAttachedItems == 0) {
                if countOfAttachedItems == 0 {
                    itemsCollectionViewHeightCostraint?.constant = 0
                    itemsCollectionViewTopCostraint?.constant = 0
                    if textViewIsEmpty {
                        inputViewIsEmpty = true
                    }
                } else {
                    itemsCollectionViewHeightCostraint?.constant = 80
                    itemsCollectionViewTopCostraint?.constant = 8
                    inputViewIsEmpty = false
                }
                self.itemsCollectionView?.layoutIfNeeded()
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
                    rightButton = .record
                } else {
                    rightButton = .send
                }
            }
        }
    }
    
    enum RightButton {
    case send
    case record
    }
    
    var rightButton: RightButton = .record {
        didSet {
            if oldValue != rightButton {
                switch rightButton {
                case .record: showRecordButton()
                case .send: showSendButton()
                }
            }
        }
    }
    
    // MARK - Initializaton
    
    init() {
        super.init(frame: .zero)
        
        setupAttachButton()
        
        setupInputContainerView()
        
        setupAttachedCollectionView()
        
        setupInputTextView()
        
        setupRightButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Layout
    
    func setupAttachedCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 34, height: 34)
        
        itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let itemsCollectionView = itemsCollectionView else { return }
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        
        itemsCollectionView.register(AttachedItemCell.self, forCellWithReuseIdentifier: "AttachedItemCell")
        
        itemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        inputViewContainerView.addSubview(itemsCollectionView)
        
        itemsCollectionViewTopCostraint = itemsCollectionView.topAnchor.constraint(equalTo: inputViewContainerView.topAnchor)
        itemsCollectionViewTopCostraint?.isActive = true
        itemsCollectionView.leftAnchor.constraint(equalTo: inputViewContainerView.leftAnchor, constant: 8).isActive = true
        itemsCollectionView.rightAnchor.constraint(equalTo: inputViewContainerView.rightAnchor, constant: -8).isActive = true
        itemsCollectionViewHeightCostraint = itemsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        itemsCollectionViewHeightCostraint?.isActive = true
        
        itemsCollectionView.backgroundColor = .clear
    }
    
    func setupInputContainerView() {
        inputViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(inputViewContainerView)
        
        inputViewContainerView.leftAnchor.constraint(equalTo: attachButton.rightAnchor).isActive = true
        inputViewContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        inputViewContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        inputViewContainerView.backgroundColor = UIColor(named: "InputViewColor")
        inputViewContainerView.layer.cornerRadius = 17
        inputViewContainerView.layer.borderWidth = 0
        inputViewContainerView.clipsToBounds = true
        inputViewContainerView.layer.masksToBounds = true
    }
    
    func setupInputTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        inputViewContainerView.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: itemsCollectionView!.bottomAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: inputViewContainerView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: inputViewContainerView.rightAnchor, constant: -8).isActive = true
        textView.bottomAnchor.constraint(equalTo: inputViewContainerView.bottomAnchor).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        textView.heightAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        
        textView.backgroundColor = UIColor(named: "InputViewColor")
        textView.delegate = self
        textView.textColor = .lightGray
        textView.endEditing(true)
        textView.alwaysBounceVertical = true
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isScrollEnabled = false
        textView.text = "Сообщение"
        
        textView.keyboardDismissMode = .interactive
    }
    
    func setupRightButtons() {
        rightButtonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightButtonsContainerView)
        
        rightButtonsContainerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        rightButtonsContainerView.leftAnchor.constraint(equalTo: inputViewContainerView.rightAnchor).isActive = true
        rightButtonsContainerView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightButtonsContainerView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        rightButtonsContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        setupRecordButton()
        setupSendButton()
        self.sendButton.transform = self.recordButton.transform.scaledBy(x: 1/2, y: 1/2)
        sendButton.removeFromSuperview()
    }
    
    func setupAttachButton() {
        attachButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(attachButton)
        
        attachButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        attachButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        attachButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        attachButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        attachButton.addTarget(self, action: #selector(didPressAttachButton), for: .touchUpInside)
        
        attachButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        attachButton.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        attachButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        attachButton.contentMode = .scaleAspectFit
    }
    
    func setupSendButton() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
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
        recordButton.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK - Actions
    
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
                textView.text = nil
                textViewIsEmpty = true
                textView.isScrollEnabled = false
                textViewHeightCostraint?.isActive = false
                textView.setNeedsUpdateConstraints()
                
                text = MessageProccesser.formatMessage(text!)
                
                guard let dataSource = dataSource else { return }
                
                let message = Message(sender: dataSource.currentSender(self), messageId: "2", sentDate: Date().addingTimeInterval(-86400), kind: .text(text!))
                
                delegate?.didPressSendButton(self, with: message)
            }
        }
    }
    
    @objc func didPressRecordButton() {
        
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
}

// MARK - TextView Delegate

extension InputBarView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewIsOversized = textView.contentSize.height >= 200
        textViewIsEmpty = textView.text == ""
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewNeedsPlaceHolder = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewNeedsPlaceHolder = true
    }
}

// MARK - CollectionView Delegate & DataSource

extension InputBarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        countOfAttachedItems = self.dataSource?.countOfAttachedItems(self) ?? 0
        return countOfAttachedItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachedItemCell", for: indexPath) as! AttachedItemCell
        if let item = dataSource?.attachedItem(self, forIndexPath: indexPath) {
            cell.setup(item)
            cell.delegate = self
            cell.dataSource = self
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 74)
    }
}

// MARK - Cell Delegate & DataSource

extension InputBarView: AttachedItemCellDelegate, AttachedItemCellDataSource {
    func didTapDeleteItem(withIndexPath indexPath: IndexPath) {
        delegate?.didDeleteItem(self, atIndexPath: indexPath)
        itemsCollectionView?.deleteItems(at: [indexPath])
        itemsCollectionView?.reloadData()
    }
    
    func indexPath(forCell cell: AttachedItemCell) -> IndexPath? {
        return itemsCollectionView?.indexPath(for: cell)
    }
}

// MARK - Delegate & DataSource

protocol InputBarViewDelegate {
    func didPressSendButton(_ inputBarView: InputBarView, with message: Message)
    
    func didPressAttachButton(_ inputBarView: InputBarView)
    
    func didEndRecording(_ inputBarView: InputBarView, voiceMesage: String)
    
    func didDeleteItem(_ inputBarView: InputBarView, atIndexPath indexPath: IndexPath)
}

protocol InputBarViewDataSource {
    func countOfAttachedItems(_ inputBarView: InputBarView) -> Int
    
    func attachedItem(_ inputBarView: InputBarView, forIndexPath indexPath: IndexPath) -> AttachedItem
    
    func currentSender(_ inputBarView: InputBarView) -> User
}
