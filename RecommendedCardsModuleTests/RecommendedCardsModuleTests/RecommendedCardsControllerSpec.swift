//
//  RecommendedCardsControllerTests.swift
//  RecommendedCardsModuleTests
//
//  Created by matheus.filipe.bispo on 08/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

@testable import RecommendedCardsModule
import Quick
import Nimble
import Nimble_Snapshots

class RecommendedCardsControllerSpec: QuickSpec {
    override func spec() {
        describe("RecommendedCardsController") {
            var controller: RecommendedCardsViewController!
            var presenter: RecommendedCardsPresenterMock!

            beforeEach {
                presenter = RecommendedCardsPresenterMock()
                controller = RecommendedCardsViewController(presenter: presenter)
            }

            context("when view did load") {
                it("has load all types and sets and cards") {
                    controller.viewDidLoad()

                    expect(presenter.invokedLoadSetsAndTypes).to(beTrue())
                    expect(presenter.invokedLoadSetsAndTypesCount).to(equal(1))
                    expect(presenter.invokedLoadAllCardsOfNextSet).to(beTrue())
                    expect(presenter.invokedLoadAllCardsOfNextSetCount).to(equal(1))
                }
            }
        }
    }
}
