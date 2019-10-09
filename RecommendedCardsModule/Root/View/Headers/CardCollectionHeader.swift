//
//  CardCollectionSection.swift
//  Sample
//
//  Created by matheus.filipe.bispo on 04/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Components
import Resources

class CardCollectionHeader: UICollectionReusableView {

    static var identifier: String = "CardCollectionSection"

    public var viewModel: String? {
        didSet {
            let text = self.viewModel!
            self.titleLabel.text = text.prefix(1).uppercased() + text.lowercased().dropFirst()
        }
    }

    private let titleLabel: UILabel = {
        let label = MagicDesignSystem.Labels.subtitleLabel.uiLabel(frame: .zero)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardCollectionHeader: ViewCodable {
    func buildHierarchy() {
        self.addSubview(titleLabel)
    }

    func buildConstraints() {
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(20)
            maker.centerY.equalToSuperview()
        }
    }

    func configureAdditional() {
    }
}
