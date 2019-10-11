//
//  RecommendedCardsPresenter.swift
//  RecommendedCardsModule
//
//  Created by matheus.filipe.bispo on 06/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Entities
import Repositories

protocol RecommendedCardsPresenterProtocol {
    func loadSetsAndTypes() -> Future<Void, APIError>
    func loadAllCardsOfNextSet() -> Future<CardSetHelper, RecommendedCardsPresenterError>
}

enum RecommendedCardsPresenterError: Error {
    case setsAndTypesNotLoaded
    case notExistMoreSets
    case cardsNotLoaded
}

class RecommendedCardsPresenter: RecommendedCardsPresenterProtocol {
    private var provider: DataProviderProtocol
    private var semaphore = DispatchSemaphore(value: 0)
    private var sets: [CardSet] = []
    private var types: [String] = []

    private var viewModel = RecommendedCardsViewModel(sets: [])
    private(set) var lastLoadedSetIndex = 0
    private var isSetsAndTypesLoaded = false

    init(provider: DataProviderProtocol) {
        self.provider = provider
    }

    func loadSetsAndTypes() -> Future<Void, APIError> {
        return Future.on(.global(qos: .userInitiated)) { [unowned self] future in

            self.provider.getAllTypes().then { result in
                self.types = result.types
                self.types.removeAll(where: { (type) -> Bool in
                    type.first?.isLowercase ?? true
                })

                self.semaphore.signal()
            }.catch { error in
                future.reject(error: error)
                self.semaphore.signal()
            }

            self.provider.getAllSets().then { result in
                self.sets = result.sets
                self.semaphore.signal()
            }.catch { error in
                future.reject(error: error)
                self.semaphore.signal()
            }

            _ = self.semaphore.wait()
            _ = self.semaphore.wait()

            self.isSetsAndTypesLoaded = true
            future.resolve()
        }
    }

    fileprivate func loadCard(with type: String, and set: CardSet) -> Future<CardTypeHelper, RecommendedCardsPresenterError> {
        let queue = DispatchQueue(label: "com.magic.\(type)", attributes: .concurrent)

        return Future.on(queue) { future in
            var typeAux = CardTypeHelper(name: type, cards: [])
            var pageCount = 0
            let queueSemaphore = DispatchSemaphore(value: 0)

            while pageCount != -1 {
                self.provider
                    .getCards(of: type, in: set, at: pageCount)
                    .then { cardsResult in
                        print(" :: \(type) loaded")
                        typeAux.cards.append(contentsOf: cardsResult.cards)

                        if cardsResult.cards.count < 100 {
                            pageCount = -1
                            queueSemaphore.signal()
                            return
                        }

                        pageCount += 1
                        queueSemaphore.signal()
                    }.catch(on: .init(label: "catch")) { _ in
                        queueSemaphore.signal()
                        future.reject(error: .cardsNotLoaded)
                    }
                queueSemaphore.wait()
            }

            if typeAux.cards.count != 0 {
                future.resolve(value: typeAux)
            }
        }
    }

    func loadAllCardsOfNextSet() -> Future<CardSetHelper, RecommendedCardsPresenterError> {
        return Future { [unowned self] future in

            if !self.isSetsAndTypesLoaded {
                future.reject(error: .setsAndTypesNotLoaded)
            }
            let set: CardSet

            if sets.count <= lastLoadedSetIndex {
                future.reject(error: .notExistMoreSets)
            }

            set = sets[lastLoadedSetIndex]

            var helper = CardSetHelper(set: set, types: [])

            for type in self.types {
                loadCard(with: type, and: set).then {
                    helper.types.append($0)
                    self.semaphore.signal()
                }.catch {
                    future.reject(error: $0)
                }
            }
            lastLoadedSetIndex += 1

            for _ in self.types {
                _ = semaphore.wait(wallTimeout: .distantFuture)
            }

            helper.types = helper.types.sorted(by: { (type1, type2) -> Bool in
                type1.name < type2.name
            })

            print(" :: All was loaded")
            future.resolve(value: helper)
        }
    }
}
