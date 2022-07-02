//
//  SectionModel.swift
//  RxTableView
//
//  Created by Paul Matar on 02/07/2022.
//

import Foundation
import RxDataSources

struct SectionModel {
    var header: String
    var items: [Food]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [Food]) {
        self = original
        self.items = items
    }
}

