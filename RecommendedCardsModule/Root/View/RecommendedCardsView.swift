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
        return tableView
    }()

    private(set) var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
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
        self.addSubview(decksTableView)

        self.sendSubviewToBack(backgroundView)
    }

    func buildConstraints() {
        self.backgroundView.snp.makeConstraints { (maker) in
            maker.height.width.equalToSuperview()
            maker.center.equalToSuperview()
        }

        self.decksTableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top)
            maker.left.equalTo(self.snp.left)
            maker.right.equalTo(self.snp.right)
            maker.bottom.equalTo(self.snp.bottom)
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
