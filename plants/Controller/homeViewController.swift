//
//  homeViewController.swift
//  plants
//
//  Created by viplab on 2019/3/5.
//  Copyright © 2019年 viplab. All rights reserved.
//

import UIKit

class homeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }


    
    
    //MARK: - 建立Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeDetailViewCell.self), for: indexPath) as! HomeDetailViewCell
            cell.DetailLabel.text = "植物圖鑑"
            cell.Detailimg.image = UIImage(named: "book1")
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeCameraViewCell.self), for: indexPath) as! HomeCameraViewCell
            cell.CameraLabel.text = "辨識系統"
            cell.Cameraimg.image = UIImage(named: "search")
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeShareViewCell.self), for: indexPath) as! HomeShareViewCell
            cell.shareLabel.text = "分享照片"
            cell.shareimg.image = UIImage(named: "camera")
            
            return cell
           
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }

    }
}
