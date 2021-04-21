//
//  PlayViewController.swift
//  jenkinsTest
//
//  Created by 谭显敬 on 2021/4/19.
//

import UIKit
import AVFoundation
import NicooPlayer
//enum playType:Int {
//    case playTypeDefault = 0
//    case playTypeTenxun
//}
let KScreenWidth = UIScreen.main.bounds.width
let KScreenHeight = UIScreen.main.bounds.height
class PlayViewController: UIViewController {
    var titleStr: String = ""
    var type:Int = 0
    let url = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")
    private lazy var playerItem: AVPlayerItem = {
        let Item = AVPlayerItem(url: url!)
        Item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
        Item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: nil)
        return Item
    }()
    
    private lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        playerLayer.frame = self.playSuperView.bounds
        return playerLayer
    }()
    private lazy var player: AVPlayer = {
        let player = AVPlayer(playerItem: self.playerItem)
        return player
    }()
    
    /////////////////////////////////////
    private lazy var playerView: NicooPlayerView = {
        let player = NicooPlayerView(frame: self.playSuperView.bounds, bothSidesTimelable: true)
        player.videoLayerGravity = .resizeAspectFill
        player.videoNameShowOnlyFullScreen = true
        player.delegate = self
        player.customViewDelegate = self
        return player
    }()
    /////////////////////////////////////
    /// 是否响应转动屏幕
    private var isRollEnable = true
    /// 等待缓存列表
    private var waitCacheUrlArray: [URL]?
    
    /// 当前选中序号
    private var currentPlayerConfigIndex: Int = 1
    /// 音视频播放列表
    private var playerConfigArray: [HYPlayerCommonConfig]
        = [
            HYPlayerCommonConfig(title: "本地音频测试",
                                 audioUrl: Bundle.main.path(forResource: "testSong", ofType: "mp3"),
                                 placeHoldImg: "radio_bg_video"),
            HYPlayerCommonConfig(title: "网络视频测试2",
                                 videoUrl: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",//"http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4",
                                 needCache: false,
                                 placeHoldImg: "radio_bg_video"),
            HYPlayerCommonConfig(title: "网络视频测试3",
                                 videoUrl: "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4",
                                 needCache: true,
                                 placeHoldImg: "radio_bg_video"),
            HYPlayerCommonConfig(title: "本地视频测试",
                                 videoUrl: Bundle.main.path(forResource: "testMovie", ofType: "mp4"),
                                 placeHoldImg: "radio_bg_video"),
            HYPlayerCommonConfig(title: "音频测试",
                                 audioUrl: "http://music.163.com/song/media/outer/url?id=447925558.mp3",
                                 needCache: true,
                                 placeHoldImg: "radio_bg_video")]
    
    /// HYPlayer播放器
    private var videoView: HYPlayerCommonView?
    
//    /// 黑底
//    private lazy var dartView: UIView = {
//        let view = UIView()
//        view.isHidden = true
//        view.isUserInteractionEnabled = true
//        let hidTap = UITapGestureRecognizer(target: self, action: #selector(removeCacheView))
//        view.addGestureRecognizer(hidTap)
//        view.backgroundColor = .black
//        view.alpha = 0
//        return view
//    }()
    
    /// 缓存列表
    private lazy var cacheView: HYPlayerCacheListView = {
        let view = HYPlayerCacheListView(frame: CGRect(x: 0, y: HY_SCREEN_HEIGHT, width: HY_SCREEN_WIDTH, height: 405))
        view.delegate = self
        return view
    }()
    
    @IBOutlet weak var playSuperView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleStr
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        /*
         https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8
         
         https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8
         
         */
        //        playerItem = M3u8ResourceLoader.shared.playerItem(with: "http://www.flashls.org/playlists/test_001/stream_1000k_48k_640x360.m3u8")
        
        
        
        
        switch self.type {
        case 0:
            /*
            playerItem = AVPlayerItem(url: url!)
            playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
            playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: nil)
            
            player = AVPlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspect
            playerLayer.contentsScale = UIScreen.main.scale
            playerLayer.frame = self.playSuperView.bounds
             */
            self.playSuperView.layer.insertSublayer(playerLayer, at: 0)
            
            break
            
        case 1:
            playerView.playVideo(url, "VideoName", self.playSuperView)
            
            break
        case 2:
            createUI()
            addDownloadObserver()
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
extension PlayViewController:NicooPlayerDelegate, NicooCustomMuneDelegate{
    func showCustomMuneView() -> UIView? {
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view1.backgroundColor = .green
        //        view1.itemClick = { [weak self] in
        //            print("itemClick ===== ?>>>>>>>>")
        //        }
        return view1
        
    }
    
    func retryToPlayVideo(_ player: NicooPlayerView, _ videoModel: NicooVideoModel?, _ fatherView: UIView?) {
        print("网络不可用时调用")
        let url = URL(string: videoModel?.videoUrl ?? "")
        if  let sinceTime = videoModel?.videoPlaySinceTime, sinceTime > 0 {
            player.replayVideo(url, videoModel?.videoName, fatherView, sinceTime)
        }else {
            player.playVideo(url, videoModel?.videoName, fatherView)
        }
    }
}
//MARK:HYPlayerCommonViewDelegate
extension PlayViewController:HYPlayerCommonViewDelegate{
    private func createUI() {
        /*
         let naviView = UIView()
         naviView.backgroundColor = .white
         view.addSubview(naviView)
         naviView.snp.makeConstraints { (make) in
             make.leading.trailing.top.equalToSuperview()
             make.height.equalTo(HY_IS_IPHONEX ? 88 : 64)
         }
         
         
         let returnBtn = UIButton()
         returnBtn.setImage(UIImage(named: "video_ic_back"), for: .normal)
         returnBtn.addTarget(self, action: #selector(returnBtnPressed), for: .touchUpInside)
         naviView.addSubview(returnBtn)
         returnBtn.snp.makeConstraints { (make) in
             make.leading.equalTo(16)
             make.bottom.equalTo(-12)
             make.height.width.equalTo(18)
         }
         
         let cacheBtn = UIButton()
         cacheBtn.setImage(UIImage(named: "video_ic_download"), for: .normal)
         cacheBtn.addTarget(self, action: #selector(showCacheList), for: .touchUpInside)
         naviView.addSubview(cacheBtn)
         cacheBtn.snp.makeConstraints { (make) in
             make.trailing.equalTo(-14)
             make.centerY.equalTo(returnBtn)
             make.height.width.equalTo(24)
         }
         
         let playView = UIView()
         playView.backgroundColor = .white
         playView.clipsToBounds = true
         view.addSubview(playView)
         playView.snp.makeConstraints { (make) in
             make.top.equalTo(naviView.snp.bottom)
             make.leading.trailing.equalToSuperview()
             make.height.equalTo(UIScreen.main.bounds.size.width / 16 * 9)
         }
         */
        
        videoView = HYPlayerCommonView(playSuperView)
        videoView?.delegate = self
        videoView?.updateCurrentPlayer(playerConfig: playerConfigArray[currentPlayerConfigIndex])
        
    }
    /** 添加下载监听*/
    private func addDownloadObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(cacheManagerDidFinishCachingAVideo(_:)), name: .HYVideoCacheManagerDidFinishCachingAVideo, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cacheManagerDidFinishCachingAllVideos(_:)), name: .HYVideoCacheManagerDidFinishCachingAllVideos, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cacheManagerDidUpdateProgress(_:)), name: .HYVideoCacheManagerDidUpdateProgress, object: nil)
    }
    /** 删除缓存*/
    private func deleteCache(url: URL) {
        
        if videoView?.videoCacher.cacheList.contains(url.absoluteString.HYmd5) == true {
            
            let location = HYDefaultVideoCacheLocation(remoteURL: url, mediaType: .video)
            videoView?.videoCacher.removeCache(located: location)
            
            if let videoCacher = videoView?.videoCacher {
                cacheView.reloadCache(videoCacher: videoCacher)
            }
        }
    }
    
    //  是否支持自动转屏
    override var shouldAutorotate: Bool {
        return isRollEnable
    }
    
    // 支持哪些转屏方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }

    
    
    /** 展示缓存列表*/
    @objc private func showCacheList() {
        if let videoCacher = videoView?.videoCacher {
            cacheView.configView(cacheList: playerConfigArray, videoCacher: videoCacher)
            UIApplication.shared.windows.first?.addSubview(cacheView)
            
            playSuperView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.playSuperView.alpha = 0.5
                self.cacheView.frame = CGRect(x: 0, y: HY_SCREEN_HEIGHT - 405, width: HY_SCREEN_WIDTH, height: 405)
            })
        }
    }
    
    /** 隐藏缓存列表*/
    @objc private func removeCacheView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.playSuperView.alpha = 0
            self.cacheView.frame = CGRect(x: 0, y: HY_SCREEN_HEIGHT, width: HY_SCREEN_WIDTH, height: 405)
        }) { (success) in
            self.playSuperView.isHidden = true
            self.cacheView.removeFromSuperview()
        }
    }
    
    /** 返回*/
    @objc private func returnBtnPressed() {
        dismiss(animated: true)
    }
    
    /** 缓存列表单个视频下载完成*/
    @objc func cacheManagerDidFinishCachingAVideo(_ notification: Notification) {
        print("下载完成")
        if let cache = notification.userInfo?["videoCache"] as? HYMediaCacheLocation {
            DispatchQueue.main.async {
                self.cacheView.finishVideoCache(cacheIdentifier: cache.identifier)
                if let videoCacher = self.videoView?.videoCacher {
                    self.cacheView.reloadCache(videoCacher: videoCacher)
                }
            }
        }
        
    }
    
    /** 缓存列表全部选中视频下载完成*/
    @objc func cacheManagerDidFinishCachingAllVideos(_ notification: Notification) {
        print("全部下载完成")
        DispatchQueue.main.async {
            if let videoCacher = self.videoView?.videoCacher {
                //                self.cacheView.finishAllVideoCache()
                self.cacheView.reloadCache(videoCacher: videoCacher)
            }
        }
    }
    
    /** 缓存列表视频下载进度*/
    @objc func cacheManagerDidUpdateProgress(_ notification: Notification) {
        
        if let cache = notification.userInfo?["videoCache"] as? HYMediaCacheLocation, let progress = (notification.userInfo?["progress"] as? NSNumber)?.floatValue {
            print("当前缓存进度：\(Int(progress * 100))%")
            DispatchQueue.main.async {
                self.cacheView.updateCacheProgress(cacheIdentifier: cache.identifier, progress: CGFloat(progress))
            }
        }
    }
    
    //MARK:协议回调start
    /** 全屏状态改变*/
    func changeFullScreen(isFull: Bool) {
        print(isFull ? "全屏" : "退出全屏")
    }
    
    /** 全屏锁定*/
    func fullScreenLock(isLock: Bool) {
        isRollEnable = !isLock
    }
    
    /** 展示控制台*/
    func showControlPanel() {
        print("展示控制台")
    }
    
    /** 隐藏控制台*/
    func hideControlPanel() {
        print("隐藏控制台")
    }
    
    /** 流量提醒*/
    func flowRemind() {
        print("正在使用流量")
    }
    
    /** 开始播放*/
    func startPlayer() {
        print("开始播放")
    }
    
    /** 播放暂停*/
    func pausePlayer() {
        print("暂停播放")
    }
    
    /** 结束播放*/
    func stopPlayer() {
        print("结束播放")
    }
    
    /** 缓存开始*/
    func startCache() {
        print("缓存开始")
    }
    
    /** 缓存进行中*/
    func inCaching(progress: Float) {
        print("缓存进度更新：\(progress)")
    }
    
    /** 缓存完成*/
    func completeCache() {
        print("缓存完成")
    }
    
    /** 缓存失败*/
    func faildCache() {
        print("缓存失败")
    }
    //MARK:协议回调end
    
    
}
//MARK: HYPlayerCacheListViewDelegate
extension PlayViewController: HYPlayerCacheListViewDelegate {
    /** 确认删除缓存*/
    func alertToDeleteVideoCache(url: URL) {
        let alert = UIAlertController(title: "确认删除缓存", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "删除", style: .default, handler: { (action) -> Void in
            self.deleteCache(url: url)
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /** 删除缓存*/
    func deleteVideoCache(urls: [URL]) {
        
        let alert = UIAlertController(title: "确认删除缓存", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "删除", style: .default, handler: { (action) -> Void in
            for url in urls {
                self.deleteCache(url: url)
            }
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    /** 开始缓存*/
    func startVideoCache() {
        
    }
}
