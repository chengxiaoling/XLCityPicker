//
//  XLCityPickerViewController+TableView.swift
//  XLCityPicker
//
//  Created by kayling on 2019/1/21.
//  Copyright © 2019年 Kayling. All rights reserved.
//

import Foundation
import UIKit

extension XLCityPickerViewController:UITableViewDataSource,UITableViewDelegate {
    
    private var currentCityModel: CityModel? {
        if self.currentCity==nil{return nil}
        if cityModels == nil {return nil}
        return CityModel.findCityModelWithCityName(cityNames: [self.currentCity], cityModels: self.cityModels, isFuzzy: false)?.first
    }
    
    private var hotCityModels: [CityModel]? {if self.hotCities==nil{return nil};return CityModel.findCityModelWithCityName(cityNames: self.hotCities, cityModels: self.cityModels, isFuzzy: false)}
    
    private var historyModels: [CityModel]? {if self.selectedCityArray.count == 0 {return nil};return CityModel.findCityModelWithCityName(cityNames: self.selectedCityArray, cityModels: self.cityModels, isFuzzy: false)}
    
    private var headViewWith: CGFloat{return UIScreen.main.bounds.width - 10}
    
    private var headerViewH: CGFloat{
        
        let h1: CGFloat = 100
        var h2: CGFloat = 100; if (self.historyModels?.count ?? 0) > 4{h2+=40}
        var h3: CGFloat = 100; if (self.hotCities?.count ?? 0) > 4 {h3+=40}
        return h1+h2+h3
    }
    
    private var sortedCityModles: [CityModel] {
        
        return cityModels.sorted(by: { (m1, m2) -> Bool in
            m1.getFirstUpperLetter < m2.getFirstUpperLetter
        })

    }
    
    
    /** 计算高度 */
    private func headItemViewH(count: Int) -> CGRect{
        
        let height: CGFloat = count <= 4 ? 96 : 140
        return CGRect.init(x: 0, y: 0, width: headViewWith, height: height)
    }
    
    
    /** 为tableView准备 */
    func tableViewPrepare(){
        
        self.title = "城市选择"
        
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    
    @objc func notiAction(noti: Notification){
        
        let userInfo = noti.userInfo as! [String: CityModel]
        let cityModel = userInfo["citiModel"]!
        citySelected(cityModel: cityModel)
        
    }
    
    /** headerView */
    func headerviewPrepare(){
        
        let headerView = UIView()
        
        headerView.frame = CGRect.init(x: 0, y: 0, width: headViewWith, height: headerViewH)
        
        let itemView = XLHeaderItemView.getHeaderItemView(title: "当前城市")
        currentCityItemView = itemView
        var currentCities: [CityModel] = []
        if self.currentCityModel != nil {currentCities.append(self.currentCityModel!)}
        itemView.cityModles = currentCities
        var frame1 = headItemViewH(count: itemView.cityModles.count)
        frame1.origin.y = 0
        itemView.frame = frame1
        headerView.addSubview(itemView)
        
        
        let itemView2 = XLHeaderItemView.getHeaderItemView(title: "历史选择")//.getHeaderItemView("历史选择")
        var historyCityModels: [CityModel] = []
        if self.historyModels != nil {historyCityModels += self.historyModels!}
        itemView2.cityModles = historyCityModels
        var frame2 = headItemViewH(count: itemView2.cityModles.count)
        frame2.origin.y = frame1.maxY
        itemView2.frame = frame2
        headerView.addSubview(itemView2)
        
        
        
        let itemView3 = XLHeaderItemView.getHeaderItemView(title: "热门城市")
        var hotCityModels: [CityModel] = []
        if self.hotCityModels != nil {
            print("hot----\((self.hotCityModels?.count)!)")
            hotCityModels += self.hotCityModels!
            
        }
        itemView3.cityModles = hotCityModels
        var frame3 = headItemViewH(count: itemView3.cityModles.count)//(itemView3.cityModles.count)
        frame3.origin.y = frame2.maxY
        itemView3.frame = frame3
        headerView.addSubview(itemView3)
        
        
        self.tableView?.tableHeaderView = headerView
    }
    
    
    /**  定位到具体的城市了  */
    func getedCurrentCityWithName(currentCityName: String){
        
        if self.currentCityModel == nil {return}
        if currentCityItemView?.cityModles.count != 0 {return}
        currentCityItemView?.cityModles = [self.currentCityModel!]
    }
    
    
    /** 处理label */
    func labelPrepare(){
        
        indexTitleLabel.backgroundColor = UIColor.orange
        indexTitleLabel.center = self.view.center
        indexTitleLabel.bounds = CGRect.init(x: 0, y: 0, width: 120, height: 100)
        indexTitleLabel.font = UIFont.boldSystemFont(ofSize: 80)
        indexTitleLabel.textAlignment = .center
        indexTitleLabel.textColor = UIColor.white
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedCityModles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let children = sortedCityModles[section].children
        
        return children==nil ? 0 : children!.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortedCityModles[section].name
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = XLCityCell.cityCellInTableView(tableView: tableView)
        
        cell.cityModel = sortedCityModles[indexPath.section].children?[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cityModel = sortedCityModles[indexPath.section].children![indexPath.row]
        citySelected(cityModel: cityModel)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
//    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]! {
//        return indexHandle()
//    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        showIndexTitle(indexTitle: title)
        
        self.showTime = 1
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.2 * Double(NSEC_PER_SEC))), execute: {
            self.showTime = 0.8
        })
        

        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.4 * Double(NSEC_PER_SEC))), execute: {
            if self.showTime == 0.8 {
                self.showTime = 0.6
            }
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.6 * Double(NSEC_PER_SEC))), execute: {
            if self.showTime == 0.6 {
                self.showTime = 0.4
            }
        })

        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.8 * Double(NSEC_PER_SEC))), execute: {
            if self.showTime == 0.4 {
                self.showTime = 0.2
            }
        })

        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(1 * Double(NSEC_PER_SEC))), execute: {
            if self.showTime == 0.2 {
                self.dismissIndexTitle()
            }
        })

        
        return indexTitleIndexArray[index]
    }
    
    
    func showIndexTitle(indexTitle: String){
        
        self.dismissBtn.isEnabled = false
        self.view.isUserInteractionEnabled = false
        indexTitleLabel.text = indexTitle
        self.view.addSubview(indexTitleLabel)
        
    }
    
    func dismissIndexTitle(){
        self.dismissBtn.isEnabled = true
        self.view.isUserInteractionEnabled = true
        indexTitleLabel.removeFromSuperview()
    }
    
    
    /** 选中城市处理 */
    func citySelected(cityModel: CityModel){
        
        if let cityIndex = self.selectedCityArray.firstIndex(of: cityModel.name) {
            self.selectedCityArray.remove(at: cityIndex)
        }else{
            if self.selectedCityArray.count >= 8 {self.selectedCityArray.removeLast()}
        }
        
        self.selectedCityArray.insert(cityModel.name, at: 0)
        UserDefaults.standard.set(self.selectedCityArray, forKey: SelectedCityKey)
        selectedCityModel?(cityModel)
        delegate?.selectedCityModel(cityPicker: self, cityModel: cityModel)
        self.dismissBack()
    }
}




