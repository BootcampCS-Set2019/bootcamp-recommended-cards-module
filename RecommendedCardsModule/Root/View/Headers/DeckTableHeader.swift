//
//  DeckTableSection.swift
//  Sample
//
//  Created by matheus.filipe.bispo on 04/10/19.
//  Copyright © 2019 BootcampCS-Set2019. All rights reserved.
//

import Components
import Resources

class DeckTableHeader: UITableViewHeaderFooterView {

    static var identifier: String = "DeckTableSection"

    public var viewModel: String? {
        didSet {
            self.titleLabel.text = self.viewModel
        }
    }

    private let titleLabel: UILabel = {
        let label = MagicDesignSystem.Labels.titleLabel.uiLabel(frame: .zero)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DeckTableHeader: ViewCodable {
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
        let view = UIView()
        view.backgroundColor = .clear
        self.backgroundView = view

    }
}
