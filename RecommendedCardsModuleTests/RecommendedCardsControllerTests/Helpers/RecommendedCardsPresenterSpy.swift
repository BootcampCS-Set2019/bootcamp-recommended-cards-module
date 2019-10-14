//
//  RecommendedCardsPresenterMock.swift
//  RecommendedCardsModuleTests
//
//  Created by matheus.filipe.bispo on 11/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Entities
@testable import RecommendedCardsModule
import Repositories

class RecommendedCardsPresenterMock: RecommendedCardsPresenterProtocol {
    var invokedLoadSetsAndTypes = false
    var invokedLoadSetsAndTypesCount = 0
    var stubbedLoadSetsAndTypesResult: Future<Void, APIError>!

    func loadSetsAndTypes() -> Future<Void, APIError> {
        invokedLoadSetsAndTypes = true
        invokedLoadSetsAndTypesCount += 1
        return stubbedLoadSetsAndTypesResult
    }

    var invokedLoadAllCardsOfNextSet = false
    var invokedLoadAllCardsOfNextSetCount = 0
    var stubbedLoadAllCardsOfNextSetResult: Future<CardSetHelper, RecommendedCardsPresenterError>!
    func loadAllCardsOfNextSet() -> Future<CardSetHelper, RecommendedCardsPresenterError> {
        invokedLoadAllCardsOfNextSet = true
        invokedLoadAllCardsOfNextSetCount += 1
        return stubbedLoadAllCardsOfNextSetResult
    }
}
