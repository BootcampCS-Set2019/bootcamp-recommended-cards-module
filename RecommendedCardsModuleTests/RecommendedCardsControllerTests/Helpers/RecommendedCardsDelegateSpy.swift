//
//  RecommendedCardsDelegateSpy.swift
//  RecommendedCardsModuleTests
//
//  Created by matheus.filipe.bispo on 11/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//
import Entities
@testable import RecommendedCardsModule

class RecommendedCardsDelegateSpy: RecommendedCardsDelegate {
    var invokedDidTapCard = false
    var invokedDidTapCardCount = 0
    var invokedDidTapCardParameters: (card: Card, Void)?
    var invokedDidTapCardParametersList = [(card: Card, Void)]()

    func didTapCard(card: Card) {
        invokedDidTapCard = true
        invokedDidTapCardCount += 1
        invokedDidTapCardParameters = (card, ())
        invokedDidTapCardParametersList.append((card, ()))
    }
}
