//
//  RootView.swift
//  Sample
//
//  Created by matheus.filipe.bispo on 03/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Components
import Resources
import UIKit
import SnapKit
import Entities

struct RecommendedCardsViewModel {
    var sets: [CardSetHelper]
}

protocol RecommendedCardsViewDelegate: class {
    func didTap(card: Card)
    func didScroll(_ scrollView: UIScrollView)
}

class RecommendedCardsView: UIView {

    public var viewModel: RecommendedCardsViewModel? {
        didSet {
            applyViewModel()
        }
    }

    public weak var delegate: RecommendedCardsViewDelegate?

    private(set) lazy var loadingIndicator: UIActivityIndicatorView = {
        let loading = MagicDesignSystem.Loading.activityIndicator
        return loading
    }()

    private(set) lazy var errorState: MagicDesignSystem.ErrorState = {
        let error = MagicDesignSystem.ErrorState(message: "Could not load cards", buttonText: "Retry")
        error.errorView.isUserInteractionEnabled = false
        error.errorView.isHidden = true
        error.messageLabel.numberOfLines = 3
        if let button = error.buttonRetry {
            button.accessibilityIdentifier = MagicDesignSystem
                .AccessibilityIdentifiers(componentType: .button,
                                          additionalName: "Error",
                                          module: .recommendedCards,
                                          number: nil)
                .constructedName
        }
        return error
    }()

    private(set) lazy var cardsSearchBar: UISearchBar = {
        let searchBar = MagicDesignSystem.SearchBar.searchCardsHorizontalLarge
            .uiSearchBar(placeholder: "Search for cards")
        searchBar.delegate = self
        searchBar.accessibilityIdentifier = MagicDesignSystem
            .AccessibilityIdentifiers(componentType: .searchBar,
                                      additionalName: nil,
                                      module: .recommendedCards,
                                      number: nil)
            .constructedName
        return searchBar
    }()

    private(set) lazy var decksTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardSetTableCell.self,
                           forCellReuseIdentifier: CardSetTableCell.identifier)
        tableView.register(DeckTableHeader.self,
                           forHeaderFooterViewReuseIdentifier: DeckTableHeader.identifier)
        tableView.backgroundColor = .clear
        tableView.accessibilityIdentifier = MagicDesignSystem
            .AccessibilityIdentifiers(componentType: .tableView,
                                      additionalName: nil,
                                      module: .recommendedCards,
                                      number: nil)
            .constructedName
        return tableView
    }()

    private(set) var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIdentifier = MagicDesignSystem
            .AccessibilityIdentifiers(componentType: ComponentTypes.imageView,
                                      additionalName: "Background",
                                      module: ModuleNames.recommendedCards,
                                      number: nil)
            .constructedName
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applyViewModel() {
        decksTableView.reloadData()
    }
}

extension RecommendedCardsView: ViewCodable {
    func buildHierarchy() {
        self.addSubview(backgroundView)
        self.addSubview(loadingIndicator)
        self.addSubview(cardsSearchBar)
        self.addSubview(decksTableView)
        self.addSubview(errorState.errorView)

        self.sendSubviewToBack(backgroundView)
    }

    func buildConstraints() {
        self.backgroundView.snp.makeConstraints { (maker) in
            maker.height.width.equalToSuperview()
            maker.center.equalToSuperview()
        }

        self.loadingIndicator.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }

        self.errorState.errorView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY).offset(50)
            maker.height.equalTo(300)
            maker.left.equalTo(self.snp.left).offset(30)
            maker.right.equalTo(self.snp.right).offset(-30)
        }

        self.cardsSearchBar.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top).offset(30)
            maker.left.equalTo(self.snp.left).offset(15)
            maker.right.equalTo(self.snp.right).offset(-15)
        }

        self.decksTableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(cardsSearchBar.snp.bottom).offset(20)
            maker.left.right.bottom.equalToSuperview()
        }
    }

    func configureAdditional() {
        self.backgroundView.image = MagicDesignSystem.Assets.background
    }
}

extension RecommendedCardsView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sets.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardSetTableCell.identifier)
            as? CardSetTableCell else {
            fatalError()
        }

        if let viewModel = viewModel?.sets[indexPath.section] {
            cell.viewModel = viewModel
        }

        cell.delegate = self

        return cell
    }
}

extension RecommendedCardsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: DeckTableHeader.identifier) as? DeckTableHeader else {
            fatalError()
        }

        header.viewModel = viewModel?.sets[section].set.name
        return header
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(scrollView)
    }
}

extension RecommendedCardsView: CardSetTableCellDelegate {
    func didTapCard(card: Card) {
        delegate?.didTap(card: card)
    }
}

extension RecommendedCardsView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
}
