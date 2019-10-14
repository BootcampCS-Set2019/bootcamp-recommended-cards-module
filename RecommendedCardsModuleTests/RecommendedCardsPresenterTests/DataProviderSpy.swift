//
import Entities
//  DataProviderSpy.swift
//  RecommendedCardsModuleTests
//
//  Created by matheus.filipe.bispo on 11/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//
@testable import RecommendedCardsModule
import Repositories

class DataProviderSpy: DataProviderProtocol {
    var invokedGetAllSets = false
    var invokedGetAllSetsCount = 0
    var stubbedGetAllSetsResult: Future<CardSets, APIError>!
    func getAllSets() -> Future<CardSets, APIError> {
        invokedGetAllSets = true
        invokedGetAllSetsCount += 1
        return stubbedGetAllSetsResult
    }

    var invokedGetAllTypes = false
    var invokedGetAllTypesCount = 0
    var stubbedGetAllTypesResult: Future<CardTypes, APIError>!
    func getAllTypes() -> Future<CardTypes, APIError> {
        invokedGetAllTypes = true
        invokedGetAllTypesCount += 1
        return stubbedGetAllTypesResult
    }

    var invokedGetCards = false
    var invokedGetCardsCount = 0
    //swiftlint:disable all
    var invokedGetCardsParameters: (type: String, set: CardSet, page: Int)?
    var invokedGetCardsParametersList = [(type: String, set: CardSet, page: Int)]()
    var stubbedGetCardsResult: Future<Cards, APIError>!
    func getCards(of type: String, in set: CardSet, at page: Int) -> Future<Cards, APIError> {
        invokedGetCards = true
        invokedGetCardsCount += 1
        invokedGetCardsParameters = (type, set, page)
        invokedGetCardsParametersList.append((type, set, page))
        return stubbedGetCardsResult
    }
}
