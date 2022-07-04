//
//  Category.swift
//  TodoeyRealm
//
//  Created by Илья Шаповалов on 04.07.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
