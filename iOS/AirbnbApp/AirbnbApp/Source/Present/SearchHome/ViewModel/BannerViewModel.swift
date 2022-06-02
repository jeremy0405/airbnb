//
//  BannerViewModel.swift
//  AirbnbApp
//
//  Created by dale on 2022/05/30.
//

import Foundation

final class BannerViewModel: ViewModelBindable {
    typealias actionType = Void
    typealias stateType = [CellViewModelable]
    
    let loadAction = PublishRelay<actionType>()
    private(set) var loadedState = PublishRelay<stateType>()
    
    @NetworkInject(keypath: \.searchHomeRepositoryImplement)
    private var repository: SearchHomeRepositoryImpl
    
    init() {
        loadAction.bind(onNext: { [weak self] in
            self?.repository.requestHeroBanner { result in
                switch result {
                case .success(let heroBanner):
                    let viewModels = heroBanner
                        .banners
                        .map { BannerCellViewModel(banner: $0) }
                    self?.loadedState.accept(viewModels)
                case .failure(let error):
                    print(error.localizedDescription) // TODO: Error 처리
                }
            }
        })
    }
}

// MARK: - Providing Function

extension BannerViewModel {
    
    func accept(_ value: actionType) {
        loadAction.accept(value)
    }
    
    func bind(_ completion: @escaping (stateType) -> Void) {
        loadedState.bind(onNext: completion)
    }
    
}
