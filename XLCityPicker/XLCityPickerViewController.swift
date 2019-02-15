//
//  XLCityPickerViewController.swift
//  XLCityPicker
//
//  Created by kayling on 2019/1/21.
//  Copyright © 2019年 Kayling. All rights reserved.
//

import UIKit

/** 通知 */
let CityChoosedNoti = "CityChoosedNoti"
/** 归档key */
let SelectedCityKey = "SelectedCityKey"

protocol XLCityPickerDelegate{
    
    func selectedCityModel(cityPicker: XLCityPickerViewController, cityModel:XLCityPickerViewController.CityModel)
}

class XLCityPickerViewController: UIViewController {
    
    var delegate: XLCityPickerDelegate!
    
    var cityModels: [CityModel]!
    
    static let cityPVCTintColor = UIColor.gray
    
    /** 可设置：当前城市 */
    var currentCity: String!{
        didSet{
            getedCurrentCityWithName(currentCityName: currentCity)
        }
    }
    
    /** 可设置：热门城市 */
    var hotCities: [String]!
    
    lazy var indexTitleLabel: UILabel = {UILabel()}()
    
    var showTime: CGFloat = 1.0
    
    var indexTitleIndexArray: [Int] = []
    
    var selectedCityModel: ((_ cityModel: CityModel) -> Void)!
    
    lazy var dismissBtn: UIButton = { UIButton(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24)) }()
    
    lazy var selectedCityArray: [String] = {
        
        guard UserDefaults.standard.object(forKey: SelectedCityKey) == nil else {
            
            return UserDefaults.standard.object(forKey: SelectedCityKey) as! [String]
        }
        
        return [String]()
    }()
    
    var currentCityItemView: XLHeaderItemView!
    
    deinit{
        print("控制器安全释放")
    }
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        /** 返回按钮 */
        dismissBtnPrepare()
        
        /** 为tableView准备 */
        tableViewPrepare()
        
        /** 处理label */
        labelPrepare()
        
        self.tableView.sectionIndexColor = XLCityPickerViewController.cityPVCTintColor
        
        /** headerView */
        headerviewPrepare()
        
        /** 定位处理 */
//        locationPrepare()
        
        //通知处理
        NotificationCenter.default.addObserver(self, selector: #selector(notiAction), name: NSNotification.Name(rawValue: CityChoosedNoti), object: nil)
    }
    
    /** 返回按钮 */
    func dismissBtnPrepare(){
        
        dismissBtn.setImage(UIImage.init(named: "cancel"), for: .normal)
        dismissBtn.addTarget(self, action: #selector(dismissBack), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissBtn)
    }
    
    @objc func dismissBack(){
        self.dismiss(animated: true, completion: nil)
    }
 
}

extension XLCityPickerViewController {
    class CityModel {
        @objc
        let id: Int
        let pid: Int
        let name: String
        let spell: String
        var children: [CityModel]?
        
        init(id: Int, pid: Int, name: String, spell: String){
            
            self.id = id
            self.pid = pid
            self.name = name
            self.spell = spell
            
        }
        
        /** 首字母获取 */
        var getFirstUpperLetter: String {return (self.spell as NSString).substring(to: 1).uppercased()}
        
        
        /** 寻找城市模型:*/
        class func findCityModelWithCityName(cityNames: [String]?, cityModels: [CityModel], isFuzzy: Bool) -> [CityModel]?{
            
            if cityNames == nil {return nil}
            
            var destinationModels: [CityModel]? = []
            
            for name in cityNames!{
                
                for cityModel in cityModels{ //省
                    
                    if cityModel.children == nil {continue}
                    
                    for cityModel2 in cityModel.children! { //市
                        
                        if !isFuzzy { //精确查找
                            
                            if cityModel2.name != name {continue}
                            
                            destinationModels?.append(cityModel2)
                            
                        }else{//模糊搜索
                            
                            let checkName = (name as NSString).lowercased
                            
                            if (cityModel2.name as NSString).range(of: name).length > 0 || ((cityModel2.spell as NSString).lowercased as NSString).range(of: checkName).length > 0{
                                destinationModels?.append(cityModel2)
                                
                            }
                        }
                    }
                }
                
            }
            
            return destinationModels
        }
        
        /** 城市检索 */
        class func searchCityModelsWithCondition(condition: String, cities: [CityModel]) -> [CityModel]?{
            
            return self.findCityModelWithCityName(cityNames: [condition], cityModels: cities, isFuzzy: true)
        }
    }
}
