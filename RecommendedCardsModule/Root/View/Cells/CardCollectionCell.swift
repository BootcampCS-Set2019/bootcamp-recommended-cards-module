//
//  CardCollectionCell.swift
//  Sample
//
//  Created by matheus.filipe.bispo on 04/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Components
import Kingfisher
import Resources

class CardCollectionCell: UICollectionViewCell {
    static var identifier: String = "DeckTableCell"

    public var viewModel: String? {
        didSet {
            applyViewModel()
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
        let url = URL(string: viewModel!)
        self.imageView.kf.setImage(with: url)
    }
}

extension CardCollectionCell: ViewCodable {
    func buildHierarchy() {
        self.addSubview(imageView)
    }

    func buildConstraints() {
        self.imageView.snp.makeConstraints { (maker) in
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
