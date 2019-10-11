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
}

class RecommendedCardsPresenter: RecommendedCardsPresenterProtocol {

    private var provider: DataProviderProtocol
    private var semaphore = DispatchSemaphore(value: 0)
    private var sets: [CardSet] = []
    private var types: [String] = []

    private var viewModel = RecommendedCardsViewModel(sets: [])
    private var lastLoadedSetIndex = 0
    private var isSetsAndTypesLoaded = false

    init(provider: DataProviderProtocol) {
        self.provider = provider
    }

    func loadSetsAndTypes() -> Future<Void, APIError> {
        return Future.on(.global(qos: .userInitiated)) { [unowned self] future in

            self.provider.getAllTypes().then { (result) in
                self.types = result.types
                self.types.removeAll(where: { (type) -> Bool in
                    return type.first?.isLowercase ?? true
                })

                self.semaphore.signal()
            }

            self.provider.getAllSets().then { (result) in
                self.sets = result.sets
                self.semaphore.signal()
            }

            _ = self.semaphore.wait()
            _ = self.semaphore.wait()

            self.isSetsAndTypesLoaded = true
            future.resolve()
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
                let queue = DispatchQueue(label: "com.magic.\(type)", attributes: .concurrent)
                queue.async {
                    var typeAux = CardTypeHelper(name: type, cards: [])
                    var pageCount = 0
                    let queueSemaphore = DispatchSemaphore(value: 0)
                    while pageCount != -1 {
                        self.provider
                            .getCards(of: type, in: helper.set, at: pageCount)
                            .then({(cardsResult) in
                                print(" :: \(type) loaded")
                                typeAux.cards.append(contentsOf: cardsResult.cards)

                                if cardsResult.cards.count < 100 {
                                    pageCount = -1
                                    queueSemaphore.signal()
                                    return
                                }

                                pageCount += 1
                                queueSemaphore.signal()
                        })
                        queueSemaphore.wait()
                    }

                    if typeAux.cards.count != 0 {
                        helper.types.append(typeAux)
                    }

                    self.semaphore.signal()
                }
            }
            lastLoadedSetIndex += 1

            for _ in self.types {
                _ = semaphore.wait(wallTimeout: .distantFuture)
            }

            helper.types = helper.types.sorted(by: { (type1, type2) -> Bool in
                return type1.name < type2.name
            })

            print(" :: All was loaded")
            future.resolve(value: helper)
        }
    }
}
