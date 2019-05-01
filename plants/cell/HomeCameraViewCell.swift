
//
//  HomeCameraViewCell.swift
//  plants
//
//  Created by viplab on 2019/3/5.
//  Copyright © 2019年 viplab. All rights reserved.
//

import UIKit

class HomeCameraViewCell: UITableViewCell {
    
    @IBOutlet var Cameraimg : UIImageView!
    @IBOutlet var CameraLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
