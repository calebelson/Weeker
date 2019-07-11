//
//  InfoLayerModel.swift
//  Weeker
//
//  Created by Caleb Elson on 7/11/19.
//  Copyright © 2019 Caleb Elson. All rights reserved.
//

import UIKit

class InfoLayerModel {
    var header: String?
    var content: [(mainText: String, detailText: String?, subheader: Bool)]
    
    init(header: String?, content: [(String, String?, Bool)]) {
        self.header = header
        self.content = content
    }
}
