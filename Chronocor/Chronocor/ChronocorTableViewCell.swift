//
//  ChronocorViewCell.swift
//  Chronocor
//
//  Created by Vinicius Martins Ferraz on 19/11/17.
//  Copyright © 2017 Vinicius Martins Ferraz. All rights reserved.
//

import UIKit
import EventKit

class ChronocorTableViewCell: UITableViewCell {
    // MARK: properties
    @IBOutlet weak var dia: UILabel!    
    @IBOutlet weak var mes: UILabel!
    @IBOutlet weak var ano: UILabel!
    @IBOutlet weak var entradaTrab: UILabel!
    @IBOutlet weak var saidaTrab: UILabel!
    @IBOutlet weak var inicioAlmoco: UILabel!
    @IBOutlet weak var fimAlmoco: UILabel!   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
    

}
