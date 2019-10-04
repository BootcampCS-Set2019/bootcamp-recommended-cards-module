//
//  RecommendedCardsPresenter.swift
//  RecommendedCardsModule
//
//  Created by elton.faleta.santana on 04/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Entities

class  RecommendedCardsPresenter {
    var interactor: RecommendedCardsInteractorProtocol?
}

extension RecommendedCardsPresenter: RecommendedCardsPresenterProtocol {
    
    func fetchSets() {
        self.interactor?.fetchSets()
    }

    func fetchNextSetCards() {
        self.interactor?.fetchNextSetCards()
    }

    func interactor(didfailWith exception: InteractorException) {
        //TODO: Notify view
    }

    func interactor(didGetCards: [MagicCard], forSet: MagicCardSet) {
        //TODO: Notify view
    }
}
