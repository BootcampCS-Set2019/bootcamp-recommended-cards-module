//
//  CardCollectionCell.swift
//  Sample
//
//  Created by matheus.filipe.bispo on 04/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Components
import Entities
import Kingfisher
import Resources

class CardCollectionCell: UICollectionViewCell {
    static var identifier: String = "DeckTableCell"

    let semaphore = DispatchSemaphore(value: 0)

    public var viewModel: Card? {
        didSet {
            self.applyViewModel()
        }
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
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

    func applyViewModel() {
        guard let viewModelAux = viewModel else {
            return
        }
        guard let imageUrl = viewModelAux.imageUrl else {
            return
        }

        guard let url = URL(string: imageUrl) else {
            return
        }

        self.imageView.downloaded(from: url)

        self.accessibilityIdentifier = MagicDesignSystem
            .AccessibilityIdentifiers(componentType: .collectionViewCell,
                                      additionalName: nil,
                                      module: .recommendedCards,
                                      number: viewModelAux.id)
            .constructedName

        self.isAccessibilityElement = true
    }
}

extension CardCollectionCell: ViewCodable {
    func buildHierarchy() {
        self.addSubview(self.imageView)
    }

    func buildConstraints() {
        self.imageView.snp.makeConstraints { maker in
            maker.top.bottom.left.right.equalToSuperview()
        }
    }

    func configureAdditional() {
        self.backgroundColor = .clear
        self.imageView.image = MagicDesignSystem.Assets.defaultCardArtboard
        self.imageView.backgroundColor = .clear
        self.imageView.layer.cornerRadius = 8
    }
}
