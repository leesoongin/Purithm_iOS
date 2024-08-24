//
//  ProfileEditViewController.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit
import CoreUIKit
import Combine

final class ProfileEditViewController: ViewController<ProfileEditView> {
    private let viewModel: ProfileEditViewModel
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProfileEditViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar(hideShadow: true)
        initNavigationTitleView(title: "프로필 편집")
        
        actionBind()
        bindViewModel()
    }
    
    private func actionBind() {
        contentView.tapGesture.tapPublisher
            .sink { [weak self] _  in
                self?.contentView.endEditing(true)
            }
            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        let input = ProfileEditViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.asPublisher(),
            adapterActionEvent: adapter.actionEventPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        output.galleryOpenEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                self?.present(imagePickerController, animated: true, completion: nil)
            }
            .store(in: &cancellables)
        
        viewModel.uploadInProgressErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentUploadInProgressErrorAlert()
            }
            .store(in: &cancellables)
        
        viewModel.editCompletPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentEditCompleteAlert()
            }
            .store(in: &cancellables)
    }
}

extension ProfileEditViewController {
    private func presentEditCompleteAlert() {
        let alert = PurithmAlert(with:
                .withOneButton(
                    title: "프로필 수정이 완료되었습니다.",
                    conformTitle: "확인"
                )
        )
        alert.conformTapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                alert.hide()
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        alert.cancelTapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                alert.hide()
            }
            .store(in: &cancellables)
        
        
        alert.show(animated: false)
    }
    
    private func presentUploadInProgressErrorAlert() {
        let alert = PurithmAlert(with:
                .withOneButton(
                    title: "프로필 사진이 업로드 중 입니다.",
                    conformTitle: "확인"
                )
        )
        alert.conformTapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                alert.hide()
            }
            .store(in: &cancellables)
        
        alert.cancelTapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                alert.hide()
            }
            .store(in: &cancellables)
        
        
        alert.show(animated: false)
    }
}

//MARK: - Image Picker
extension ProfileEditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.didFinishPickingImageSubject.send(selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Navigate
extension ProfileEditViewController: NavigationBarApplicable {
    func handleNavigationButtonAction(with identifier: String) {
        switch identifier {
        case "conform_button":
            contentView.endEditing(true)
            viewModel.requestEditProfile()
        default:
            break
        }
    }
    
    var leftButtonItems: [NavigationBarButtonItemType] {
        [
            .backImage(
                identifier: "back_button",
                image: .icArrowLeft,
                color: .gray500
            )
        ]
    }
    
    var rightButtonItems: [NavigationBarButtonItemType] {
        [
            .text(
                identifier: "conform_button",
                text: "등록",
                color: .blue400
            )
        ]
    }
}
