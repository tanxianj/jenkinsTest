//
//  DouYinCell.swift
//  jenkinsTest
//
//  Created by 谭显敬 on 2021/4/23.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit

class DouYinCell: UITableViewCell {
    static let cellid = "douyinCell"
    // 是否播放器已经存在
    var isPlayerExist = false
    
    var playButtonClickBlock:((_ sender: Any) ->())?
    @IBOutlet var mg_bottom: NSLayoutConstraint!
    @IBOutlet weak var backGroundImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .black
        let tp = UITapGestureRecognizer(target: self, action: #selector(bgImageTouchAction))
        backGroundImage.addGestureRecognizer(tp)
    }
    @objc func playButtonClick(_ sender: UIButton) {
        if  self.playButtonClickBlock != nil {
            self.playButtonClickBlock!(sender)
        }
    }
   @objc func bgImageTouchAction(_ sender: Any) {
        txjLog("这是图片点击事件")
        if self.playButtonClickBlock != nil{
            self.playButtonClickBlock!(sender)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
