//
//  PurithmProfileView.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreCommonKit
import Then
import SnapKit
import Kingfisher

public final class PurithmProfileView: BaseView {
    let container = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.backgroundColor = .gray100
    }
    
    let userContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 10
    }
    let userProfileImageView = UIImageView().then {
        $0.layer.cornerRadius = 40 / 2
        $0.clipsToBounds = true
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let userNameLabel = PurithmLabel(typography: Constants.nameTypo)
        .then {
            $0.text = "dummy"
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
    
    let shopContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 4
    }
    let shopImageView = UIImageView().then {
        $0.image = .icHome
    }
    let shopLabel = PurithmLabel(typography: Constants.shopTypo)
    
    let satisfactionContainer = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .trailing
    }
    let satisfactionDescriptionLabel = PurithmLabel(typography: Constants.satisfactionDescriptionTypo).then {
        $0.text = "필터 만족도"
    }
    let satisfactionTextContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    let satisfactionImageView = UIImageView()
    let satisfactionLabel = PurithmLabel(typography: Constants.satisfactionTypo)
    
    
    override public func setupSubviews() {
        addSubview(container)
        
        container.addArrangedSubview(userContainer)
        userContainer.addArrangedSubview(userProfileImageView)
        userContainer.addArrangedSubview(userNameLabel)
        
        container.addArrangedSubview(shopContainer)
        shopContainer.addArrangedSubview(shopImageView)
        shopContainer.addArrangedSubview(shopLabel)
        
        container.addArrangedSubview(satisfactionContainer)
        satisfactionContainer.addArrangedSubview(satisfactionDescriptionLabel)
        satisfactionContainer.addArrangedSubview(satisfactionTextContainer)
        
        satisfactionTextContainer.addArrangedSubview(satisfactionImageView)
        satisfactionTextContainer.addArrangedSubview(satisfactionLabel)
    }
    
    override public func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        userProfileImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        shopImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        satisfactionImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    public func configure(with profileType: PurithmProfileType, satisfactionLevel: SatisfactionLevel , name: String, profileURLString: String) {
        switch profileType {
        case .user:
            shopContainer.isHidden = true
            satisfactionContainer.isHidden = false
        case .artist:
            shopContainer.isHidden = false
            satisfactionContainer.isHidden = true
        }
        
        satisfactionImageView.image = satisfactionLevel.starImage.withTintColor(satisfactionLevel.color)
        satisfactionLabel.text = "\(satisfactionLevel.rawValue) %"
        satisfactionLabel.textColor = satisfactionLevel.color
        
        userNameLabel.text = name
        
        if let url = URL(string: profileURLString) {
            userProfileImageView.kf.setImage(with: url)
        }
    }
}

extension PurithmProfileView {
    private enum Constants {
        static let nameTypo = Typography(size: .size24, weight: .medium, color: .gray500, applyLineHeight: true)
        static let shopTypo = Typography(size: .size18, weight: .semibold, color: .blue400, applyLineHeight: true)
        static let satisfactionTypo = Typography(size: .size18, weight: .semibold, color: .purple500, applyLineHeight: true)
        static let satisfactionDescriptionTypo = Typography(size: .size12, weight: .medium, color: .gray300, applyLineHeight: true)
    }
}