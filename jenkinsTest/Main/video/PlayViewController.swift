//
//  PlayViewController.swift
//  jenkinsTest
//
//  Created by 谭显敬 on 2021/4/19.
//

import UIKit
import AVFoundation
enum playType {
    case playTypeDefault
    case playTypeTenxun
}
class PlayViewController: UIViewController {
    var titleStr: String = ""
    var type:playType = .playTypeDefault
    
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    var player: AVPlayer!
    
    
    @IBOutlet weak var playSuperView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleStr
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        /*
         http://www.flashls.org/playlists/test_001/stream_1000k_48k_640x360.m3u8
         
         http://cdn.theoplayer.com/video/star_wars_episode_vii-the_force_awakens_official_comic-con_2015_reel_(2015)/index.m3u8&hls=1
         
         */
//        playerItem = M3u8ResourceLoader.shared.playerItem(with: "http://www.flashls.org/playlists/test_001/stream_1000k_48k_640x360.m3u8")
        let url = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        playerItem = AVPlayerItem(url: url!)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: nil)
        
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        playerLayer.frame = self.playSuperView.bounds
        self.playSuperView.layer.insertSublayer(playerLayer, at: 0)
        
        
        switch self.type {
        case .playTypeDefault:
            
            break
            
        case .playTypeTenxun:
            break
            
        default:
            print("其他")
        }
    }
    
    deinit {
        playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
    }
   
}

extension PlayViewController{
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
            // 缓冲进度 暂时不处理
        } else if keyPath == #keyPath(AVPlayerItem.status) {
            // 监听状态改变
            if playerItem.status == .readyToPlay {
                // 只有在这个状态下才能播放
                player.play()
            } else {
                print("加载异常")
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
   
}
