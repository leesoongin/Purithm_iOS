//
//  FilterDetailView.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import UIKit
import CoreUIKit
import Combine

final class FilterDetailView: BaseView {
    var cancellables = Set<AnyCancellable>()
    
    //MARK: View
    let container = UIView()
    let headerView = FilterDetailHeaderView()
    var optionViews: [FilterMoreOptionView] = {
        FilterDetailOptionType.allCases.map { type in
            let optionView = FilterMoreOptionView()
            optionView.configure(with: type)
            return optionView
        }
    }()
    let moreOptionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.isScrollEnabled = false
    }
    let bottomView = FilterDetailBottomView()
    
    //MARK: Properties
    private let optionTapEventSubject = PassthroughSubject<FilterDetailOptionType?, Never>()
    var backButtonTapEvent: AnyPublisher<Void, Never> {
        headerView.backButton.tap
    }
    var likeButtonTapEvent: AnyPublisher<Void, Never> {
        headerView.likeButton.tap
    }
    var optionTapEvent: AnyPublisher<FilterDetailOptionType?, Never> {
        optionTapEventSubject.eraseToAnyPublisher()
    }
    
    var originalTapEvent: AnyPublisher<Void, Never> {
        bottomView.originalImageButton.tap
    }
    
    var textHideTapEvent: AnyPublisher<Void, Never> {
        bottomView.textHideButton.tap
    }
    
    var textHidePressedEvent: AnyPublisher<Void, Never> {
        bottomView.textHideButton.pressed
    }
    
    var conformTapEvent: AnyPublisher<Void, Never> {
        bottomView.conformButton.tap
    }

    //MARK: Life Cycle
    override func setup() {
        super.setup()
        
        bindAction()
    }
    
    override func setupSubviews() {
        [container, collectionView, bottomView].forEach {
            addSubview($0)
        }
        
        [headerView, moreOptionStackView].forEach {
            container.addSubview($0)
        }
        
        optionViews.forEach {
            moreOptionStackView.addArrangedSubview($0)
        }
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        moreOptionStackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bindAction() {
        optionViews.forEach { optionView in
            optionView.tapEvent
                .sink { [weak self] optionType in
                    self?.optionTapEventSubject.send(optionType)
                }
                .store(in: &cancellables)
        }
    }
    
    func configure(title: String, likeCount: Int, isLike: Bool) {
        headerView.configure(title: title, likeCount: likeCount, isLike: isLike)
    }
}