//
//  RecommendedCardsModuleBuilder.swift
//  RecommendedCardsModule
//
//  Created by matheus.filipe.bispo on 08/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Foundation

public class RecommendedCardsModuleBuilder {
    public static func buildRoot() -> UIViewController {
        let presenter = RecommendedCardsPresenter()
        return RecommendedCardsViewController(presenter: presenter)
    }
}
