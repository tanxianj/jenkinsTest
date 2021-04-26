//
//  SuggestedVideosView.swift
//  jenkinsTest
//
//  Created by 谭显敬 on 2021/4/21.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit

protocol  SuggestedVideosBtnDelegate:NSObjectProtocol{
    func show()
    func hidden()
}

class SuggestedVideosView: UIView {

//    @IBOutlet weak var coll: UICollectionView!
    @IBOutlet weak var coll: UICollectionView!
    weak var delegate:SuggestedVideosBtnDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.coll.backgroundColor = .clear
        TXJCollConfiguration()
    }
    
    @IBAction func showBtn(_ sender: UIButton) {
        delegate?.show()
    }
    @IBAction func hiddenBtn(_ sender: UIButton) {
        delegate?.hidden()
    }
}
extension SuggestedVideosView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func TXJCollConfiguration() -> Void {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 100)
        self.coll.collectionViewLayout = layout
        self.coll.delegate = self
        self.coll.dataSource = self
        self.coll.register(UINib.init(nibName: "SuggestedVideosCell", bundle: Bundle.main), forCellWithReuseIdentifier: "collcellid")
//        SuggestedVideosCell
//        collcellid
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collcellid", for: indexPath) as! SuggestedVideosCell
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("推荐视频点击 \(indexPath.row)")
    }
    
}
