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
    var filter = ""
    var viewModel: RecommendedCardsViewModel?

    public weak var delegate: RecommendedCardsDelegate?

    init(presenter: RecommendedCardsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        self.view = self.mainView
        self.mainView.delegate = self
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bringData()
    }

    private func bringData() {
        self.mainView.loadingIndicator.startAnimating()
        DispatchQueue.main.async {
            self.presenter.loadSetsAndTypes().then(on: .main) { _ in
                self.presenter.loadAllCardsOfNextSet().then(on: .main) { helper in
                    self.mainView.loadingIndicator.stopAnimating()
                    self.viewModel = RecommendedCardsViewModel(sets: [helper])
                    self.applyViewModel()
                }
            }.catch(on: .main) { error in
                self.mainView.loadingIndicator.stopAnimating()
                self.mainView.errorState.errorView.isUserInteractionEnabled = true
                self.mainView.errorState.errorView.isHidden = false
                self.mainView.errorState.messageLabel.text = error.localizedDescription
                if let button = self.mainView.errorState.buttonRetry {
                    button.addTarget(self, action: #selector(self.retryButtonAction), for: .touchUpInside)
                }
            }
        }
    }

    @objc func retryButtonAction(sender: UIButton!) {
        self.bringData()
        self.mainView.errorState.errorView.isUserInteractionEnabled = false
        self.mainView.errorState.errorView.isHidden = true
    }

    func applyViewModel() {
        self.mainView.viewModel = self.viewModel
    }

    func filterWithViewModel() {
        let filteredViewModel = mainView.viewModel

        var setsAux = [CardSetHelper]()
        for set in filteredViewModel!.sets {
            var typesAux = [CardTypeHelper]()
            for type in set.types {
                let filteredCards = type.cards.filter { (card) -> Bool in
                    return card.name.contains(self.filter)
                }

                if filteredCards.count > 0 {
                    typesAux.append(CardTypeHelper(name: type.name, cards: filteredCards))
                }
            }
            setsAux.append(CardSetHelper(set: set.set, types: typesAux))
        }

        self.mainView.viewModel = RecommendedCardsViewModel(sets: setsAux)
    }
}

extension RecommendedCardsViewController: RecommendedCardsViewDelegate {
    func didScroll(_ scrollView: UIScrollView) {}

    func didTap(card: Card) {
        self.delegate?.didTapCard(card: card)
    }

    func didSearch(with text: String) {
        self.filter = text
        if filter == "" {
            applyViewModel()
        } else {
            filterWithViewModel()
        }
    }
}
