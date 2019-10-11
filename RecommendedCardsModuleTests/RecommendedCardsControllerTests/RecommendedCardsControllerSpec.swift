//
import Entities
import Nimble
import Nimble_Snapshots
import Quick
@testable import RecommendedCardsModule
//  RecommendedCardsControllerTests.swift
//  RecommendedCardsModuleTests
//
//  Created by matheus.filipe.bispo on 08/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//
import Repositories

class RecommendedCardsControllerSpec: QuickSpec {
    override func spec() {
        describe("RecommendedCardsController") {
            var controller: RecommendedCardsViewController!
            var presenter: RecommendedCardsPresenterMock!

            beforeEach {
                presenter = RecommendedCardsPresenterMock()
                controller = RecommendedCardsViewController(presenter: presenter)
            }

            afterEach {
                presenter = nil
                controller = nil
            }

            context("when view load") {
                it("has change view") {
                    controller.loadView()

                    expect(controller.view).to(equal(controller.mainView))
                }
            }

            context("when card was tapped") {
                it("has call delegate method") {
                    controller.loadView()

                    let delegate = RecommendedCardsDelegateSpy()
                    controller.delegate = delegate

                    let card = Card(id: "", name: "", imageUrl: "")
                    controller.didTap(card: card)

                    expect(delegate.invokedDidTapCard).to(beTrue())
                    expect(delegate.invokedDidTapCardCount).to(equal(1))
                    expect(delegate.invokedDidTapCardParameters?.card).to(equal(card))
                }
            }

            context("when table scroll") {
                it("has call delegate method") {
                    controller.loadView()

                    let delegate = RecommendedCardsDelegateSpy()
                    controller.delegate = delegate

                    _ = Card(id: "", name: "", imageUrl: "")
                    controller.didScroll(UIScrollView())
                }
            }

            context("when retry button was tapped") {
                it("has reload data") {
                    controller.loadView()

                    controller.retryButtonAction(sender: nil)

                    presenter.stubbedLoadSetsAndTypesResult = Future<Void, APIError> { $0.resolve() }

                    let card = Card(id: "", name: "", imageUrl: "")
                    let set = CardSet(code: "", name: "", releaseDate: "")
                    let helper = CardSetHelper(set: set, types: [CardTypeHelper(name: "", cards: [card])])

                    presenter.stubbedLoadAllCardsOfNextSetResult =
                        Future<CardSetHelper, RecommendedCardsPresenterError> {
                            $0.resolve(value: helper)
                        }

                    expect(presenter.invokedLoadSetsAndTypes).toEventually(beTrue())
                    expect(presenter.invokedLoadSetsAndTypesCount).toEventually(equal(1))
                    expect(presenter.invokedLoadAllCardsOfNextSet).toEventually(beTrue())
                    expect(presenter.invokedLoadAllCardsOfNextSetCount).toEventually(equal(1))
                }
            }

            context("when view did load") {
                it("has load all types and sets and cards") {
                    presenter.stubbedLoadSetsAndTypesResult = Future<Void, APIError> { $0.resolve() }

                    let card = Card(id: "", name: "", imageUrl: "")
                    let set = CardSet(code: "", name: "", releaseDate: "")
                    let helper = CardSetHelper(set: set, types: [CardTypeHelper(name: "", cards: [card])])

                    presenter.stubbedLoadAllCardsOfNextSetResult = Future<CardSetHelper, RecommendedCardsPresenterError> {
                        $0.resolve(value: helper)
                    }
                    controller.viewDidLoad()

                    expect(presenter.invokedLoadSetsAndTypes).toEventually(beTrue())
                    expect(presenter.invokedLoadSetsAndTypesCount).toEventually(equal(1))
                    expect(presenter.invokedLoadAllCardsOfNextSet).toEventually(beTrue())
                    expect(presenter.invokedLoadAllCardsOfNextSetCount).toEventually(equal(1))
                }

                it("has stop load on sets and cards request error") {
                    presenter.stubbedLoadSetsAndTypesResult = Future<Void, APIError> { $0.reject(error: .unavailable) }

                    let card = Card(id: "", name: "", imageUrl: "")
                    let set = CardSet(code: "", name: "", releaseDate: "")
                    let helper = CardSetHelper(set: set, types: [CardTypeHelper(name: "", cards: [card])])

                    presenter.stubbedLoadAllCardsOfNextSetResult =
                        Future<CardSetHelper, RecommendedCardsPresenterError> {
                            $0.resolve(value: helper)
                        }

                    controller.viewDidLoad()

                    expect(presenter.invokedLoadSetsAndTypes).toEventually(beTrue())
                    expect(presenter.invokedLoadSetsAndTypesCount).toEventually(equal(1))
                    expect(presenter.invokedLoadAllCardsOfNextSet).toEventually(beFalse())
                    expect(presenter.invokedLoadAllCardsOfNextSetCount).toEventually(equal(0))
                }
            }

            context("when view will appear") {
                it("should be") {
                    let cards = [Card(id: "Card", name: "Card", imageUrl: "Card"),
                                 Card(id: "Card", name: "Card", imageUrl: "Card"),
                                 Card(id: "Card", name: "Card", imageUrl: "Card"),
                                 Card(id: "Card", name: "Card", imageUrl: "Card")]
                    let set = CardSet(code: "Set", name: "Set", releaseDate: "2019")
                    let helper = CardSetHelper(set: set, types: [CardTypeHelper(name: "Type", cards: cards)])

                    let view = RecommendedCardsView(frame: UIScreen.main.bounds)
                    view.viewModel = RecommendedCardsViewModel(sets: [helper])

                    expect(view).to(haveValidSnapshot())
                }
            }
        }
    }
}
