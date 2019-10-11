//
//  RecommendedCardsPresenterSpec.swift
//  RecommendedCardsModuleTests
//
//  Created by matheus.filipe.bispo on 11/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Entities
import Nimble
import Nimble_Snapshots
import Quick
@testable import RecommendedCardsModule
import Repositories

class RecommendedCardsPresenterSpec: QuickSpec {
    override func spec() {
        describe("RecommendedCardsPresenter") {
            var dataProviderSpy: DataProviderSpy!
            var presenter: RecommendedCardsPresenter!

            beforeEach {
                dataProviderSpy = DataProviderSpy()
                presenter = RecommendedCardsPresenter(provider: dataProviderSpy)
            }

            afterEach {
                dataProviderSpy = nil
                presenter = nil
            }

            context("when call loadSetsAndTypes") {
                it("has load all the sets and types from DataProvider") {
                    dataProviderSpy.stubbedGetAllSetsResult = Future<CardSets, APIError> {
                        $0.resolve(value: CardSets(sets: []))
                    }

                    dataProviderSpy.stubbedGetAllTypesResult = Future<CardTypes, APIError> {
                        $0.resolve(value: CardTypes(types: []))
                    }

                    _ = presenter.loadSetsAndTypes()

                    expect(dataProviderSpy.invokedGetAllSets).toEventually(beTrue())
                    expect(dataProviderSpy.invokedGetAllTypes).toEventually(beTrue())

                    expect(dataProviderSpy.invokedGetAllSetsCount).toEventually(equal(1))
                    expect(dataProviderSpy.invokedGetAllTypesCount).toEventually(equal(1))
                }
            }

            context("when call loadSetsAndTypes") {
                it("has load all the next set cards from DataProvider") {
                    let types = ["1", "2", "3"]

                    dataProviderSpy.stubbedGetCardsResult = Future<Cards, APIError> {
                        $0.resolve(value: Cards(cards: []))
                    }

                    dataProviderSpy.stubbedGetAllSetsResult = Future<CardSets, APIError> {
                        $0.resolve(value: CardSets(sets: [CardSet(code: "", name: "", releaseDate: "")]))
                    }

                    dataProviderSpy.stubbedGetAllTypesResult = Future<CardTypes, APIError> {
                        $0.resolve(value: CardTypes(types: types))
                    }

                    _ = presenter.loadSetsAndTypes().then {
                        _ = presenter.loadAllCardsOfNextSet()
                    }

                    expect(dataProviderSpy.invokedGetCards).toEventually(beTrue())
                    expect(dataProviderSpy.invokedGetCardsCount).toEventually(equal(types.count))
                }
            }
        }
    }
}
