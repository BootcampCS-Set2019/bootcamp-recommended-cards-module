//
//  RecommededCardsInteractorSpec.swift
//  RecommendedCardsModuleTests
//
//  Created by elton.faleta.santana on 04/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

@testable import RecommendedCardsModule
import Quick
import Nimble
import Repositories

class RecommededCardsInteractorSpec: QuickSpec {
    override func spec() {
        var interactor: RecommendedCardsInteractor!
        var dataProvider: MTGSDKDataProvider!

        describe("RecomendedCardsInteractor") {
            dataProvider = MTGSDKDataProvider()
            interactor = RecommendedCardsInteractor(withApiDataProvider: dataProvider)

            context("Requesting first set") {
                it("Should get first set") {
                    waitUntil(timeout: 10, action: { (done) in
                        interactor.fetchSets()
                        expect(interactor.cardsSets).toNot(beEmpty())
                        done()
                    })
                }

                it("Should get next set") {
                    waitUntil(timeout: 10, action: { (done) in
                        interactor.fetchSets()
                        expect(interactor.cardsSets.count).to(be(2))
                        done()
                    })
                }
            }
        }
    }
}
