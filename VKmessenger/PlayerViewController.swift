//
//  PlayerViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.12.2020.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController {

    var media: Media!
    
    var player: AVPlayer! {
        didSet {
            playerManager = PlayerManager(player)
            
            let duration: Float64 = CMTimeGetSeconds((self.player.currentItem!.asset.duration) as! CMTime)
            print("Duration did set \(duration)")
            playerManager.delegate = self
            controlsView.delegate = self
        }
    }
    
    var playerContainerView = UIView()
    
    var playerView: PlayerView!
    
    var controlsView: PlayerControlsView!
    
    var playerManager: PlayerManager!
    
    var menuHidden = true {
        didSet {
            if menuHidden != oldValue {
                UIView.animate(withDuration: 0.4) { [self] in
                    navigationController?.setNeedsStatusBarAppearanceUpdate()
                    navigationController?.navigationBar.alpha = menuHidden ? 0 : 1
                    controlsView.alpha = menuHidden ? 0 : 1
                    toolBar.alpha = menuHidden ? 0 : 1
                    controlsBackgroundView.alpha = menuHidden ? 0 : 0.5
                }
            }
        }
    }
    
    let controlsBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.tintColor = .white
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        toolBar.alpha = 0
        return toolBar
    }()
    
    let shareItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.right"), style: .plain, target: self, action: #selector(didPressShareItem))
        return item
    }()
    
    let rewindItem: UIBarButtonItem  = {
        let item = UIBarButtonItem(image: UIImage(systemName: "gobackward.10"), style: .plain, target: self, action: #selector(didPressRewindItem))
        return item
    }()
    
    let playItem: UIBarButtonItem  = {
        let playButton = UIButton(type: .custom)
        playButton.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        playButton.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        playButton.setImage(UIImage(systemName: "pause.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)), for: .selected)
        playButton.setImage(UIImage(systemName: "pause.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)).withTintColor(.systemGray, renderingMode: .alwaysOriginal), for: [.highlighted, .selected])
        playButton.addTarget(self, action: #selector(didPressPlayItem), for: .touchUpInside)
        playButton.isSelected = true
        let item = UIBarButtonItem(customView: playButton)
        return item
    }()
    
    let fastForwardItem: UIBarButtonItem  = {
        let item = UIBarButtonItem(image: UIImage(systemName: "goforward.10"), style: .plain, target: self, action: #selector(didPressFastForwardItem))
        return item
    }()
    
    let saveItem: UIBarButtonItem  = {
        let saveItem = UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line.alt"), style: .plain, target: self, action: #selector(didPressSaveItem))
        return saveItem
    }()
    
    let replayButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressReplayButton), for: .touchUpInside)
        return button
    }()
    
    var isPlaying = true {
        didSet {
            if oldValue != isPlaying {
                if isPlaying {
                    if !(playItem.customView as! UIButton).isSelected {
                        (playItem.customView as! UIButton).isSelected = true
                    }
                    playerManager.play()
                } else {
                    if (playItem.customView as! UIButton).isSelected {
                        (playItem.customView as! UIButton).isSelected = false
                    }
                    playerManager.pause()
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return menuHidden
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .portrait]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupContainerView()
        setupPlayerView()
        playerView.play(with: media.url)
        setupControls()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.alpha = 1
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(named: "color")
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupContainerView() {
        playerContainerView.backgroundColor = .black
        let image = media.thumbnail
        let imageView = UIImageView(image: image)
        
        let xScale = view.bounds.width / imageView.bounds.width
        let yScale = view.bounds.height / imageView.bounds.height
        
        let scale = min(xScale, yScale)
        
        let playerHeight = imageView.bounds.height * scale
        let playerWidth = imageView.bounds.width * scale
        
        let verticalSpace = (view.bounds.height - playerHeight) / 2.0
        let horizontalSpace = (view.bounds.width - playerWidth) / 2.0
        
        playerContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerContainerView)
        
        playerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalSpace).isActive = true
        playerContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalSpace).isActive = true
        playerContainerView.widthAnchor.constraint(equalToConstant: playerWidth).isActive = true
        playerContainerView.heightAnchor.constraint(equalToConstant: playerHeight).isActive = true
    }
    
    func setupPlayerView() {
        playerView = PlayerView()
        playerView.delegate = self
        playerContainerView.addSubview(playerView)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.leftAnchor.constraint(equalTo: playerContainerView.leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: playerContainerView.rightAnchor).isActive = true
        playerView.heightAnchor.constraint(equalTo: playerContainerView.heightAnchor).isActive = true
        playerView.centerYAnchor.constraint(equalTo: playerContainerView.centerYAnchor).isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapPlayerView))
        playerView.addGestureRecognizer(gesture)
    }
    
    func setupControls() {
        controlsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlsBackgroundView)
        
        controlsBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        controlsBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controlsBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        toolBar.items = [shareItem, .flexibleSpace(), rewindItem, .fixedSpace(30),
                         playItem, .fixedSpace(30), fastForwardItem, .flexibleSpace(), saveItem]
    
        toolBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        toolBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsView = PlayerControlsView()
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlsView)
        controlsView.alpha = 0
        
        controlsView.topAnchor.constraint(equalTo: controlsBackgroundView.topAnchor).isActive = true
        controlsView.bottomAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        controlsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        controlsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        controlsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func didTapPlayerView() {
        menuHidden = !menuHidden
    }
    
    @objc func didPressRewindItem() {
        playerManager.rewind10Sec()
    }
    
    @objc func didPressPlayItem() {
        isPlaying = !isPlaying
        (playItem.customView as! UIButton).isSelected = isPlaying
    }
    
    @objc func didPressFastForwardItem() {
        playerManager.fastForward10Sec()
    }
    
    @objc func didPressReplayButton() {
        playerManager.replay()
        isPlaying = true
    }

    @objc func didPressShareItem() {
        
    }
    
    @objc func didPressSaveItem() {
        
    }
}

extension PlayerViewController: PlayerManagerDelegate {
    func playerDidChangeTime(_ time: CMTime) {
        controlsView.progressSliderView.value = Float(CMTimeGetSeconds(time))
        controlsView.timeFromBeginLabel.text = time.positionalTime
    }
    
    func playerDidFinishPlaying(_ note: NSNotification) {
        isPlaying = false
    }
}

extension PlayerViewController: PlayerViewDelegate {
    func setPlayer(_ player: AVPlayer) {
        self.player = player
        print("succes")
    }
}

extension PlayerViewController: PlayerConstrolsViewDelegate {
    func userDidBeginDrag() {
        isPlaying = false
    }
    
    func userDidEndDrag(_ time: CMTime) {
        playerManager.setTime(time)
        isPlaying = true
    }
    
    func getDuration() -> CMTime {
        return player.currentItem!.asset.duration
    }
}

extension CMTime {
    var roundedSeconds: TimeInterval {
        return seconds.rounded()
    }
    var hours:  Int { return Int(roundedSeconds / 3600) }
    var minute: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 3600) / 60) }
    var second: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 60)) }
    var positionalTime: String {
        return hours > 0 ?
            String(format: "%d:%02d:%02d",
                   hours, minute, second) :
            String(format: "%02d:%02d",
                   minute, second)
    }
}
