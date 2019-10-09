//
//  CardSetTableCell.swift
//  Sample
//
//  Created by matheus.filipe.bispo on 04/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Entities
import Components
import Resources

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
        let screenSize = UIScreen.main.bounds.size
        let cardSpacing: CGFloat = 17
        let cardsInLine: CGFloat = 3
        let cardWidth = (screenSize.width / cardsInLine) - (cardSpacing + cardsInLine) - 2
        let cardHeight = 118 * cardWidth / 85

        let layout = AlignedCollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cardWidth, height: cardHeight)
        layout.minimumInteritemSpacing = 17
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
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

        collectionView.accessibilityIdentifier = MagicDesignSystem
            .AccessibilityIdentifiers(componentType: .collectionView,
                                      additionalName: nil,
                                      module: .recommendedCards,
                                      number: nil)
            .constructedName
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
        guard let viewModelAux = viewModel else {
            return
        }

        self.collectionView.reloadData()
        self.accessibilityIdentifier = MagicDesignSystem
            .AccessibilityIdentifiers(componentType: .tableViewCell,
                                      additionalName: nil,
                                      module: .recommendedCards,
                                      number: viewModelAux.set.code)
            .constructedName
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

        if let card = viewModel?.types[indexPath.section].cards[indexPath.row] {
            cell.viewModel = card
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
