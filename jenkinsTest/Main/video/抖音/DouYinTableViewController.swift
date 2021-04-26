//
//  DouYinTableViewController.swift
//  jenkinsTest
//
//  Created by 谭显敬 on 2021/4/23.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit
import NicooPlayer
import CommonCrypto

class DouYinTableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    /// 当前正在播放的cell 所在的 indexPath
    var playerCellIndex: IndexPath?
    /// 当前添加播放器的cell
    var lastPlayerCell: DouYinCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "播放器"
        let v = UIView()
        
        tableView.tableHeaderView = v
        tableView.tableFooterView = v
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .blue
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
        let encrypted = "Zf1zRHv5amP8iJ9UdVrmdiIyky/UB+0+tp7ElvdIIWBZC3gmL8stWtyAPTjmBDait8bJlhiICxd786E2NeQgsI6CE6XMuxK+Iwv9n+dMB17QvDLjOtDzm8nJtjiEMH7s5A1DR4d04pzaDWgMn0tRmrC4ES48taYZNQpLg0Sb87neYKFFljTv9i4HhSgVnXR4lBgbcBt6BUMdcnyVLNOX6sxTNyE37RNlbm3PelbWnahcmx9XhPoVniVUi4t3vx48WNH49hdQmqF0nd90sE5/RdL6TQI6N6wGwZXtaiHR1HJHmyb0CwbJAy/WYLiEa/KFjBcstpZvdMU="
        let cont = "{\"id\":\"1\",\"DomainName\":\"www.cesss++++++++++++++++++++hsfwi.comssss\",\"LinkType\":\"7<font>1@@$@#$%^$*^&*(ˉ(∞)ˉ)-----————————(&*1\",\"UseType\":\"1\",\"IsNeedCheck\":\"1\",\"version\":\"v1\",\"controller\":\"domain\",\"function\":\"domainUpdate\"}"
        let code = DESUtil.encryptUseDES(clearText: cont, key: APPKey)
        
        print("code is \(code.replacingOccurrences(of: "+", with: "%2b"))")
        
        let  data = "https://www.baidu.com/啊啊啊啊啊"
        
        print("data \(data.urlEncoded())")
        
        let string =  DESUtil.decryptUseDES(plainText: encrypted, key: APPKey)
        print(string)
        
        let  model = TestModel(fromDictionary: string.toDictionary())
        print(model.username ?? "userName 失败")
        print(model.pwd ?? "pwd 失败")
        
        
        
        HTTPSessionManager.shareInstance.requseDatasWithList(type: .post,
                                                             URLString: "http://192.168.110.170:81/vueapi/v1/domain/domainIndex",
                                                             pageNum: 1,
                                                             paramares: ["DomainName":"啊啊啊啊"]) { (model) in
            print(model.toDictionary())
        }
        
        
    }
    deinit {
        print("试图控制器被释放了")
        removePlayer()
        if let cc = lastPlayerCell?.value(forKey: "retainCount"),let vv = self.value(forKey: "retainCount") {
            print("cccccccccccccccccc = \(cc)  ==  \(vv)")
        }
    }
}
extension String{
    //将原始的url编码为合法的url
        func urlEncoded() -> String {
            let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed)
            return encodeUrlString ?? ""
        }
         
        //将编码后的url转换回原始的url
        func urlDecoded() -> String {
            return self.removingPercentEncoding ?? ""
        }
   
}
extension DouYinTableViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DouYinCell.cellid, for: indexPath) as! DouYinCell
        cell.playButtonClickBlock = { [weak self] (sender) in
            guard let strongSelf = self else {
                return
            }
            /// 当前页面已经存在一个播放器，并且本地点击不是上次一个cell ，先移除上一个
            if strongSelf.lastPlayerCell != nil && strongSelf.playerCellIndex != nil && strongSelf.playerCellIndex! != indexPath {
                
                for view in strongSelf.lastPlayerCell!.backGroundImage.subviews {
                    if view is NicooPlayerView {
                        view.removeFromSuperview()
                        strongSelf.lastPlayerCell!.isPlayerExist = false
                    }
                }
            }
            /// cell 上没有播放器，才添加 （不加这个，循环引用，具体多少个对象的循环引用，自己数）
            if !cell.isPlayerExist {
                let player = NicooPlayerView(frame: cell.bounds)
                player.videoLayerGravity = .resizeAspect
                player.delegate = self
               // player.customViewDelegate = self   // 这个是用于自定义右上角按钮的显示
                let url = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")
                player.playVideo(url, "VideoName", cell.backGroundImage)
                cell.isPlayerExist = true
                strongSelf.playerCellIndex = indexPath
                strongSelf.lastPlayerCell = cell
            } else {
                print("not player exsit")
            }
            
        }
        // Configure the cell...

        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h:CGFloat = self.view.bounds.size.height - CGFloat(KNavigationH) - KtabbarH
        
        return h
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellNicoo = cell as! DouYinCell
        if cellNicoo.isPlayerExist {
            for view in cellNicoo.backGroundImage.subviews {
                if view is NicooPlayerView {
                    view.removeFromSuperview()
                    cellNicoo.isPlayerExist = false
                    playerCellIndex = nil
                    lastPlayerCell = nil
                }
            }
        }
    }
}
extension DouYinTableViewController{
    
    /// 移除播放器
    func removePlayer() {
        if self.lastPlayerCell != nil && lastPlayerCell!.isPlayerExist {
            for view in lastPlayerCell!.backGroundImage.subviews {
                if view is NicooPlayerView {
                    view.removeFromSuperview()
                    lastPlayerCell!.isPlayerExist = false
                    playerCellIndex = nil
                    lastPlayerCell = nil
                }
            }
        }
    }
}
// MARK: - 代理方法： 1. 网络不好，点击重试的操作。   2、 自定义操作栏
extension DouYinTableViewController: NicooPlayerDelegate, NicooCustomMuneDelegate {
    
    // NicooPlayerDelegate 网络重试
    
    func retryToPlayVideo(_ player: NicooPlayerView , _ videoModel: NicooVideoModel?, _ fatherView: UIView?) {
        let url = URL(string: videoModel?.videoUrl ?? "")
        if  let sinceTime = videoModel?.videoPlaySinceTime, sinceTime > 0 {
            player.replayVideo(url, videoModel?.videoName, fatherView, sinceTime)
        }else {
            player.playVideo(url, videoModel?.videoName, fatherView)
        }
    }
    
    func currentVideoPlayToEnd(_ videoModel: NicooVideoModel?, _ isPlayingDownLoadFile: Bool) {
        print("CellPlayVC ---> currentVideoPlayToEnd")
    }
    
//    /// 自定义操作控件代理  ：NicooCustomMuneDelegate,   customTopBarActions 和 showCustomMuneView的优先级为  后者优先， 实现后者， 前者不起效
//
//        func showCustomMuneView() -> UIView? {
//
//            if self.index%2 == 0 {
//                let view = CustomMuneView(frame: self.view.bounds)
//                view.itemClick = { [weak self] in
//                    print("itemClick ===== ?>>>>>>>>")
//                }
//                 return view
//            }else {
//                let view1 = CustomMuneView11(frame: self.view.bounds)
//                view1.itemClick = { [weak self] in
//                     print("itemClick ===== ?>>>>>>>>")
//                }
//                return view1
//            }
//
//        }
    
}
