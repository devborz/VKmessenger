//
//  PlayerManager.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.12.2020.
//

import AVKit

class PlayerManager {
    
    var delegate: PlayerManagerDelegate?
    
    var player: AVPlayer
    
    init(_ player: AVPlayer) {
        self.player = player
        NotificationCenter.default.addObserver(self,
            selector: #selector(playerDidFinishPlaying(_:)),
            name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1000), queue: .main) { _ in
            self.delegate?.playerDidChangeTime(self.player.currentTime())
        }
    }
    
    func play() {
        
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func replay() {
        let newTime: Float64  = 0
        player.pause()
        
        let selectedTime: CMTime = CMTime(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player.seek(to: selectedTime)
        player.play()
    }
    
    func setTime(_ time: CMTime) {
        guard let duration = player.currentItem?.duration else { return }
        
        let newTime = CMTimeGetSeconds(time)
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        if newTime < durationInSeconds {
            let selectedTime: CMTime = CMTime(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player.seek(to: selectedTime)
        } else {
            let selectedTime: CMTime = CMTime(value: Int64(durationInSeconds * 1000 as Float64), timescale: 1000)
            player.seek(to: selectedTime)
        }
        
    }
    
    func rewind10Sec() {
        let diff: Float64 = 5
        
        let playerCurrenTime = CMTimeGetSeconds(player.currentTime())
        
        var newTime = playerCurrenTime - diff
        
        if newTime < 0 {
            newTime = 0
        }
        
        let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player.seek(to: selectedTime)
    }
    
    func fastForward10Sec() {
        let diff: Float64 = 5
        guard let duration = player.currentItem?.duration else { return }
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + diff
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        if newTime < durationInSeconds {
            let selectedTime: CMTime = CMTime(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player.seek(to: selectedTime)
        } else {
            let selectedTime: CMTime = CMTime(value: Int64(durationInSeconds * 1000 as Float64), timescale: 1000)
            player.seek(to: selectedTime)
        }
    }
    
    func getDuration() -> CMTime {
        guard let duration = player.currentItem?.duration else {
            return CMTime(value: 0, timescale: 1000)
        }
        return duration
    }
    
    @objc func playerDidFinishPlaying(_ note: NSNotification) {
        delegate?.playerDidFinishPlaying(note)
    }
}

protocol PlayerManagerDelegate {
    func playerDidFinishPlaying(_ note: NSNotification)
    
    func playerDidChangeTime(_ time: CMTime)
}
