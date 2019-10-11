//
//  RecommendedCardsViewController.swift
//  RecommendedCardsModule
//
//  Created by matheus.filipe.bispo on 06/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//
import Entities

public protocol RecommendedCardsDelegate: class {
    func didTapCard(card: Card)
}

public class RecommendedCardsViewController: UIViewController {

    var presenter: RecommendedCardsPresenterProtocol
    let mainView = RecommendedCardsView()
    let semaphore = DispatchSemaphore(value: 0)

    public weak var delegate: RecommendedCardsDelegate?

    init(presenter: RecommendedCardsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        self.view = mainView
        mainView.delegate = self
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.presenter.loadSetsAndTypes().then({ _ in
                self.semaphore.signal()
            })

            self.semaphore.wait()

            self.presenter.loadAllCardsOfNextSet().then(on: .main) { (helper) in
                self.apply(viewModel: RecommendedCardsViewModel(sets: [helper]))
            }
        }
    }

    func apply(viewModel: RecommendedCardsViewModel) {
        self.mainView.viewModel = viewModel
    }
}

extension RecommendedCardsViewController: RecommendedCardsViewDelegate {
    func didTap(card: Card) {
        self.delegate?.didTapCard(card: card)
    }

    public func didScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > scrollView.contentSize.height/3 {
//            interactor.loadAllCardsOfNextSet()
//        }
    }
}
