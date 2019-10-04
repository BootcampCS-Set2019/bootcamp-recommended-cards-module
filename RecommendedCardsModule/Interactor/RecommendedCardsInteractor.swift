//
//  RecommendedCardsInteractor.swift
//  RecommendedCardsModule
//
//  Created by elton.faleta.santana on 04/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Foundation
import Repositories
import Entities

class RecommendedCardsInteractor {
    private var dataProvider: MTGSDKDataProvider
    var cardsSets: [String: MagicCard] = [:]
    var sets: [MagicCardSet] = []

    var presenter: RecommendedCardsPresenterProtocol?

    required init(withApiDataProvider dataProvider: MTGSDKDataProvider) {
        self.dataProvider = dataProvider
    }
}

extension RecommendedCardsInteractor: RecommendedCardsInteractorProtocol {
    func fetchSets() {
        self.dataProvider.getAllSets { [unowned self] (sets, error) in
            guard let sets = sets, error != nil else {
                return
            }
            self.sets = sets.sorted(by: { (previous, next) -> Bool in
                previous.name! < next.name!
            })
            self.fetchNextSetCards()
        }
    }

    func fetchNextSetCards() {
        let setToFetchCode: String? = {
            for set in self.sets {
                if let code = set.code,
                    self.cardsSets[code] == nil {
                    return code
                }
            }
            return nil
        }()

        guard let code = setToFetchCode else {
            self.presenter?.interactor(didfailWith: .thereIsNoNextSet)
            return
        }

        var hasEntireSet = false
        var page = 1
        var responseCards: [MagicCard] = []

        while !hasEntireSet {
            self.dataProvider.getCards(inSet: code, atPage: page) { (cards, error) in
                guard let cards = cards, error != nil else {
                    self.presenter?.interactor(didfailWith: .networkError(error!))
                    return
                }
                if !cards.isEmpty {
                    responseCards.append(contentsOf: cards)
                    page += 1
                } else {
                    hasEntireSet = true
                }
            }
        }
    }
}
