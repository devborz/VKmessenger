//
//  PlayerControlsView.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.12.2020.
//

import UIKit
import AVKit

class PlayerControlsView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    var delegate: PlayerConstrolsViewDelegate? {
        didSet {
            if delegate != nil {
                let duration: Float64 = CMTimeGetSeconds(delegate!.getDuration())
                print("Duration \(duration)")
                progressSliderView.maximumValue = Float(duration)
                timeToEndLabel.text = delegate!.getDuration().positionalTime
            }
        }
    }
    
    @IBOutlet weak var timeFromBeginLabel: UILabel!
    
    @IBOutlet weak var timeToEndLabel: UILabel!
    
    @IBOutlet weak var progressSliderView: UISlider!
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlayerControlsView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        
        let thumbImage = UIImage(systemName: "circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15)).withTintColor(.white, renderingMode: .alwaysOriginal)
        progressSliderView.setThumbImage(thumbImage, for: .normal)
        progressSliderView.tintColor = .white
        progressSliderView.isContinuous = false
        progressSliderView.value = 0
    }
    
    @IBAction func sliderDidBeginDrag(_ sender: Any) {
        delegate?.userDidBeginDrag()
    }
    
    @IBAction func sliderDidEndDrag(_ sender: Any) {
        let duration = delegate?.getDuration()
        
        guard duration != nil else { return }
        
        let time: CMTime = CMTimeMultiplyByFloat64(duration!, multiplier: Float64(progressSliderView.value / progressSliderView.maximumValue))
        delegate?.userDidEndDrag(time)
    }
    
    
}

protocol PlayerConstrolsViewDelegate {
    func userDidBeginDrag()
    
    func userDidEndDrag(_ time: CMTime)
    
    func getDuration() -> CMTime
}

