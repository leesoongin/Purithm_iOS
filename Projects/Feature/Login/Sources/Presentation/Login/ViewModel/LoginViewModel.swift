//
//  LoginViewModel.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import Combine
import CorePurithmAuth


extension LoginViewModel {
    struct Input {
        let kakaoLoginButtonTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        
    }
}

final class LoginViewModel {
    weak var coordinator: LoginCoordinatorable?
    var cancellables = Set<AnyCancellable>()
    
    private let signInUseCase: SignInUseCase
    
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(coordinator: LoginCoordinatorable, useCase: SignInUseCase) {
        self.coordinator = coordinator
        self.signInUseCase = useCase
    }
    
    func transform(from input: Input) {
        input.kakaoLoginButtonTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.signInUseCase.loginWithKakao()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("::: complete")
                        case .failure(let error):
                            print("::: login failed > \(error)")
                            self.errorSubject.send(error)
                        }
                    } receiveValue: { _ in
                        self.coordinator?.pushTermsViewController()
                        print("::: 약관 선택화면으로 이동")
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
    
    func loginWithApple(with idToken: String, name: String) {
        signInUseCase.loginWithApple(with: idToken, name: name)
            .sink { completion in
                switch completion {
                case .finished:
                    print("::: apple login completed.")
                case .failure(let error):
                    print("::: apple login failed. > \(error)")
                }
            } receiveValue: { [weak self]_ in
                self?.coordinator?.pushTermsViewController()
            }
            .store(in: &cancellables)
    }
}

