//
//  UserSettingTableViewCell.swift
//  labMonitor
//
//  Created by huchuang on 2018/3/27.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import UIKit

class UserSettingTableViewCell: UITableViewCell {
    
    let titleL = UILabel()
    let subTitleL = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.addSubview(titleL)
        titleL.textColor = kTextColor
        self.addSubview(subTitleL)
        subTitleL.textColor = kLightTextColor
        
        let rightImv = UIImageView.init(image: UIImage.init(named: "箭头"))
        self.addSubview(rightImv)
        
        titleL.snp.updateConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
        }
        
        rightImv.snp.updateConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(10)
            make.height.equalTo(20)
        }
        
        subTitleL.snp.updateConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(rightImv.snp.left).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
