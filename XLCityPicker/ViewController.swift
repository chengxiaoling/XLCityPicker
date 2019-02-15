//
//  ViewController.swift
//  XLCityPicker
//
//  Created by kayling on 2019/1/21.
//  Copyright © 2019年 Kayling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cityButton = UIButton.init(frame: CGRect.init(x: UIScreen.main.bounds.width/2 - 50, y: 100, width: 100, height: 50))
        cityButton.addTarget(self, action: #selector(showAction), for: .touchUpInside)
        cityButton.backgroundColor = UIColor.red
        cityButton.setTitle("上海", for: .normal)
        cityButton.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(cityButton)
    }

    @objc func showAction() {
        let cityVC = XLCityPickerViewController()
        cityVC.currentCity = "上海"
        let navVC = UINavigationController.init(rootViewController: cityVC)
        navVC.navigationBar.barStyle = .black
        self.present(navVC, animated: true, completion: nil)
        //解析字典数据
        let cityModels = cityModelsPrepare()
        cityVC.cityModels = cityModels
        cityVC.hotCities = ["北京","上海","广州","成都","厦门"]
        //选中了城市
        cityVC.selectedCityModel = { (cityModel: XLCityPickerViewController.CityModel) in
            
            print("您选中了城市： \(cityModel.name)")
        }
//
    }

}


/** 这里是无关的解析业务 */
extension ViewController{
    
    /** 解析字典数据，由于swift中字典转模型工具不完善，这里先手动处理 */
    func cityModelsPrepare() -> [XLCityPickerViewController.CityModel]{
        
        //加载plist，你也可以加载网络数据
        let plistUrl = Bundle.main.url(forResource: "City", withExtension: "plist")!
        let cityArray = NSArray.init(contentsOf: plistUrl) as! [NSDictionary]
        
        var cityModels: [XLCityPickerViewController.CityModel] = []
        
        for dict in cityArray{
            let cityModel = parse(dict: dict)
            cityModels.append(cityModel)
        }
        
        return cityModels
    }
    
    func parse(dict: NSDictionary) -> XLCityPickerViewController.CityModel{
        
        let id = dict["id"] as! Int
        let pid = dict["pid"] as! Int
        let name = dict["name"] as! String
        let spell = dict["spell"] as! String
        
        let cityModel = XLCityPickerViewController.CityModel(id: id, pid: pid, name: name, spell: spell)
        
        let children = dict["children"]
        
        if children != nil { //有子级
            
            var childrenArr: [XLCityPickerViewController.CityModel] = []
            for childDict in children as! NSArray {
                
                let childrencityModel = parse(dict: childDict as! NSDictionary)
                
                childrenArr.append(childrencityModel)
            }
            
            cityModel.children = childrenArr
        }
        
        return cityModel
    }
    
}

