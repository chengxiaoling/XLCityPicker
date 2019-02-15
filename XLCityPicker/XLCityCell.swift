//
//  XLCityCell.swift
//  XLCityPicker
//
//  Created by kayling on 2019/1/21.
//  Copyright © 2019年 Kayling. All rights reserved.
//

import UIKit

class XLCityCell: UITableViewCell {

    var cityModel: XLCityPickerViewController.CityModel! {didSet{dataFill()}}
    
}

extension XLCityCell{
    
    static var rid: String {return "XLCityCell"}
    
    class func cityCellInTableView(tableView: UITableView) -> XLCityCell {
        
        //取出cell
        var cityCell = tableView.dequeueReusableCell(withIdentifier: rid) as? XLCityCell
        
        if cityCell == nil {cityCell = XLCityCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: rid)}
        
        return cityCell!
    }
    
    
    /** 数据填充 */
    func dataFill(){
        
        self.textLabel?.text = "\(cityModel.name)"
        
    }
    
}
