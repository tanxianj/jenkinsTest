//
//  ImageTextView.swift
//  jenkinsTest
//
//  Created by 谭显敬 on 2021/4/24.
//  Copyright © 2021 swift. All rights reserved.
//

import UIKit

open class ImageTextView: UIView {
    
    fileprivate let imageView = UIImageView.configuredImageView()
    fileprivate lazy var textLabel = UILabel()
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    public override init(frame: CGRect) {
        super.init(frame: frame)
        #if !TARGET_INTERFACE_BUILDER  // 非interfabuilder环境下
        // 如果是从代码层面开始使用Autolayout,需要对使用的View的translatesAutoresizingMaskIntoConstraints的属性设置为false
        translatesAutoresizingMaskIntoConstraints = false
        #endif
        prepareView()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareView()
    }
    // 布局
    func prepareView(){
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: CGFloat(14))
        
        addSubview(imageView)
        addSubview(textLabel)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal )
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant:10 ) ,
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor) ,
            textLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor , constant:2 ) ,
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor) ,
            textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant:-10)
        ])
        
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 4
//        layer.masksToBounds = true
    }
}
extension UIImageView{
    class func configuredImageView() ->UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }
}
extension ImageTextView{
    @IBInspectable
    open var image:UIImage{
        get{
            return imageView.image!
        }
        set{
            imageView.image = newValue
        }
    }
    @IBInspectable
    open var text:String{
        get{
            return textLabel.text!
        }
        set{
            textLabel.text = newValue
        }
    }
    @IBInspectable
    open var textColor:UIColor?{
        get{
            return textLabel.textColor
        }
        set{
            textLabel.textColor = newValue
        }
    }
//    @IBInspectable
//    open var textSize:UInt{
//        didSet{
//            textLabel.font = UIFont.systemFont(ofSize: CGFloat(10.0))
//        }
//    }
}
