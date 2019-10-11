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
    public static func buildRoot(provider: DataProvider) -> RecommendedCardsViewController {
        let presenter = RecommendedCardsPresenter(provider: provider)
        let controller = RecommendedCardsViewController(presenter: presenter)
        return controller
    }
}
