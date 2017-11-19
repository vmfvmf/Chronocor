//
//  Chronocor.swift
//  Chronocor
//
//  Created by Vinicius Martins Ferraz on 19/11/17.
//  Copyright © 2017 Vinicius Martins Ferraz. All rights reserved.
//

import UIKit
import EventKit

class Chronocor{
    let diaTrabalho : EKEvent
    let horarioAlmoco : EKEvent
    
    init(diaTrabalho : EKEvent, horarioAlmoco : EKEvent){
        self.diaTrabalho = diaTrabalho
        self.horarioAlmoco = horarioAlmoco
    }
}
