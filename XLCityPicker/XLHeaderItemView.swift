//
//  XLHeaderItemView.swift
//  XLCityPicker
//
//  Created by kayling on 2019/1/21.
//  Copyright © 2019年 Kayling. All rights reserved.
//

import UIKit

class XLHeaderItemView: UIView {

    @IBOutlet weak var ib_itemLabel: UILabel!
    
    @IBOutlet weak var ib_lineViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var ib_contentView: XLCPContentView!
    
    @IBOutlet weak var ib_msgLabel: UILabel!
    
    var cityModles: [XLCityPickerViewController.CityModel]!{didSet{dataCome()}}
}

extension XLHeaderItemView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        ib_lineViewHC.constant = 0.5
        
    }
    
    func dataCome(){
        self.ib_msgLabel.isHidden = cityModles.count != 0
        self.ib_contentView.cityModles = cityModles
    }
    
    
    class func getHeaderItemView(title: String) -> XLHeaderItemView{
        
        let itemView = Bundle.main.loadNibNamed("XLHeaderItemView", owner: nil, options: nil)?.first as! XLHeaderItemView
        itemView.ib_itemLabel.text = title
        
        return itemView
    }
}

class XLCPContentView: UIView {
    
    var cityModles: [XLCityPickerViewController.CityModel]!{
        didSet{
        print("====\(cityModles.count)")
        btnsPrepare()
            
        }
        
    }
    
    let maxRowCount = 4
    var btns: [ItemBtn] = []
    
    
    
    /** 添加按钮 */
    func btnsPrepare(){
        
        if cityModles == nil {return}
        
        for cityModel in cityModles{
            
            let itemBtn = ItemBtn()
            itemBtn.setTitle(cityModel.name, for: .normal)
            itemBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            btns.append(itemBtn)
            itemBtn.cityModel = cityModel
            self.addSubview(itemBtn)
        }
    }
    
    
    /** 按钮点击事件 */
    @objc func btnClick(btn: ItemBtn){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CityChoosedNoti), object: nil, userInfo: ["citiModel":btn.cityModel])
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if btns.count == 0 {return}
        let marginForRow: CGFloat = 16.0
        let marginForCol: CGFloat = 13
        let width: CGFloat = (self.bounds.size.width - (CGFloat(maxRowCount - 1)) * marginForRow) / CGFloat(maxRowCount)
        
        let height: CGFloat = 30
        for (index,btn) in btns.enumerated() {
            
            let row = index % maxRowCount
            
            let col = index / maxRowCount
            
            let x = (width + marginForRow) * CGFloat(row)
            let y = (height + marginForCol) * CGFloat(col)
            
            btn.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }
    }
    
}

extension XLCPContentView {
    
    class ItemBtn: UIButton {
        
        var cityModel: XLCityPickerViewController.CityModel!
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            /** 视图准备 */
            self.viewPrepare()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            /** 视图准备 */
            self.viewPrepare()
        }
        
        /** 视图准备 */
        func viewPrepare(){
            
            self.setTitleColor(UIColor.black, for: .normal)
            self.setTitleColor(UIColor.lightGray, for: .highlighted)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            self.layer.cornerRadius = 4
            self.layer.masksToBounds = true
            self.backgroundColor = UIColor.yellow
        }
    }
    
}
