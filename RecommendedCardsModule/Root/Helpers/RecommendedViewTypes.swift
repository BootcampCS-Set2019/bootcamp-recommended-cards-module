//
//  RecommendedViewTypes.swift
//  RecommendedCardsModule
//
//  Created by matheus.filipe.bispo on 07/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Entities

struct CardSetHelper {
    var set: CardSet
    var types: [CardTypeHelper]
}

struct CardTypeHelper {
    var name: String
    var cards: [Card]
}
