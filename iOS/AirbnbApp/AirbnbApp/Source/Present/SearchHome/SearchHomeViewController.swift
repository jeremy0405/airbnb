//
//  SearchHomeViewController.swift
//  AirbnbApp
//
//  Created by dale on 2022/05/23.
//

import UIKit
import SnapKit

final class SearchHomeViewController: UIViewController {
    
    private let viewModel: SearchHomeViewModel
    
    private lazy var searchBarDelegate = SearchHomeSearchBarDelegate()
    private lazy var searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.delegate = searchBarDelegate
        return searchBar
    }()
    
    private lazy var collectionViewDataSource = SearchHomeCollectionViewDataSource()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: SectionLayoutFactory.createCompositionalLayout())
        collectionView.register(BannerViewCell.self, forCellWithReuseIdentifier: BannerViewCell.identifier)
        collectionView.register(CityViewCell.self, forCellWithReuseIdentifier: CityViewCell.identifier)
        collectionView.register(ThemeViewCell.self, forCellWithReuseIdentifier: ThemeViewCell.identifier)
        collectionView.register(SearchHomeHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SearchHomeHeaderView.identifier)
        collectionView.dataSource = self.collectionViewDataSource
        return collectionView
    }()
    
    init(viewModel: SearchHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        layoutSearchBar()
        layoutNearCityCollectionView()
        configureNavigationItem()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func bind() {
        searchBarDelegate.tapTextField
            .bind { [weak self] in
                self?.navigationController?.pushViewController(SearchViewController(viewModel: CityViewModel()), animated: true)
            }
        
        viewModel.bindHeroBanner { [weak self] cellViewModels in
            self?.collectionViewDataSource
                .configure(sectionType: .banner, with: cellViewModels)
            self?.collectionView.reloadSections(SearchHomeCollectionViewSection.banner.indexSet)
        }
        
        viewModel.bindCities { [weak self] cellViewModels in
            self?.collectionViewDataSource
                .configure(sectionType: .nearCity, with: cellViewModels)
            self?.collectionView.reloadSections(SearchHomeCollectionViewSection.nearCity.indexSet)
        }
        
        viewModel.bindTheme { [weak self] cellViewModels in
            self?.collectionViewDataSource
                .configure(sectionType: .theme, with: cellViewModels)
            self?.collectionView.reloadSections(SearchHomeCollectionViewSection.theme.indexSet)
        }
        
        viewModel.acceptHeroBanner(value: ())
        viewModel.acceptNearCity(value: ())
        viewModel.acceptTheme(value: ())
    }
}

// MARK: - View Layout

private extension SearchHomeViewController {
    func configureNavigationItem() {
        self.navigationItem.backButtonTitle = "뒤로"
    }
    
    func layoutSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func layoutNearCityCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func appendCities() {
        
    }
    
}
