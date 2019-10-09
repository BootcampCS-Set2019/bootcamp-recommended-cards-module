//
//  CardSetTableCell.swift
//  Sample
//
//  Created by matheus.filipe.bispo on 04/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Entities
import Components

protocol CardSetTableCellDelegate: class {
    func didTapCard(card: Card)
}

class CardSetTableCell: UITableViewCell {
    static var identifier: String = "CardSetTableCell"

    public weak var delegate: CardSetTableCellDelegate?

    public var viewModel: CardSetHelper? {
        didSet {
            applyViewModel()
        }
    }

    private(set) lazy var collectionView: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 85, height: 118)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 17
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        layout.headerReferenceSize = CGSize(width: 0, height: 35)
        layout.horizontalAlignment = HorizontalAlignment.left

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CardCollectionCell.self, forCellWithReuseIdentifier: CardCollectionCell.identifier)
        collectionView.register(CardCollectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CardCollectionHeader.identifier)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyViewModel() {
        self.collectionView.reloadData()
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.layoutIfNeeded()

        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        return contentSize
    }
}

extension CardSetTableCell: ViewCodable {
    func buildHierarchy() {
        self.addSubview(collectionView)
    }

    func buildConstraints() {
        collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    func configureAdditional() {
        self.backgroundColor = .clear
    }
}

extension CardSetTableCell: UICollectionViewDelegate {
}

extension CardSetTableCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.types.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.types[section].cards.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionCell.identifier,
                                                            for: indexPath) as? CardCollectionCell else {
            fatalError()
        }

        if let cardUrl = viewModel?.types[indexPath.section].cards[indexPath.row].imageUrl {
            cell.viewModel = cardUrl
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind,
                                              withReuseIdentifier: CardCollectionHeader.identifier,
                                              for: indexPath) as? CardCollectionHeader else {
            fatalError()
        }

        section.viewModel = viewModel?.types[indexPath.section].name

        return section
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let card = viewModel?.types[indexPath.section].cards[indexPath.row] {
            delegate?.didTapCard(card: card)
        }
    }
}
