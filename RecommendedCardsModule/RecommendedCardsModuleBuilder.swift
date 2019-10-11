//
//  RecommendedCardsModuleBuilder.swift
//  RecommendedCardsModule
//
//  Created by matheus.filipe.bispo on 08/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Repositories
import Entities

public class RecommendedCardsModuleBuilder {
    public weak var delegate: RecommendedCardsDelegate?

    public init() {}

    public func buildRoot(provider: DataProvider) -> UIViewController {
        let presenter = RecommendedCardsPresenter(provider: provider)
        let controller = RecommendedCardsViewController(presenter: presenter)
        controller.delegate = self
        return controller
    }
}

extension RecommendedCardsModuleBuilder: RecommendedCardsDelegate {
    public func didTapCard(card: Card) {
        delegate?.didTapCard(card: card)
    }
}
