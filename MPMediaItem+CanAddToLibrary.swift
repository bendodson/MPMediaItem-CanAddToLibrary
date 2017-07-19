//
//  MPMediaItem+CanAddToLibrary.swift
//
//  Created by Ben Dodson on 13/07/2017.
//  Copyright © 2017 Dodo Apps. All rights reserved.
//

import UIKit
import MediaPlayer

extension MPMediaItem {

    var canAddToLibrary: Bool {
        let id = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyPersistentID)
        let query = MPMediaQuery(filterPredicates: [id])
        let count = query.items?.count ?? 0
        return count == 0
    }
    
}
