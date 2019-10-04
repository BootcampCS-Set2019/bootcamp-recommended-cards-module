//
//  RecommendedCardsPresenterProtocol.swift
//  RecommendedCardsModule
//
//  Created by elton.faleta.santana on 04/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Entities

enum InteractorException {
    case networkError(Error)
    case thereIsNoNextSet
}

protocol RecommendedCardsPresenterProtocol {
    func fetchSets()
    func fetchNextSetCards()
    func interactor(didGetCards: [MagicCard], forSet: MagicCardSet)
    func interactor(didfailWith exception: InteractorException)
}
