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
        self.bringData()
    }

    private func bringData() {
        mainView.loadingIndicator.startAnimating()
        DispatchQueue.main.async {
            self.presenter.loadSetsAndTypes().then(on: .main) { _ in

                self.presenter.loadAllCardsOfNextSet().then(on: .main) { (helper) in
                    self.mainView.loadingIndicator.stopAnimating()
                    self.apply(viewModel: RecommendedCardsViewModel(sets: [helper]))
                }
            }.catch(on: .main) { (error) in
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
