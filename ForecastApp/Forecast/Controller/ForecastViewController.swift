//
//  ForecastViewController.swift
//  ForecastApp
//
//  Created by Luis Costa on 11/02/2021.
//

import UIKit
import RxSwift

final class ForecastViewController: UIViewController {
    // MARK: - Properties
    
    private let viewModel: ForecastViewModelProtocol
    private let disposeBag = DisposeBag()
    private let dataSource: CollectionViewConfigurable
    
    private let loadingView = LoadingView()
    
    private lazy var forecastView: ForecastView = {
        let view = ForecastView()
        view.collectionView.dataSource = dataSource
        view.collectionView.delegate = dataSource
        dataSource.registerReusableViews(in: view.collectionView)
        return view
    }()
    
    private lazy var refreshControll: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return control
    }()
    
    // MARK: - Initializer
    
    init(viewModel: ForecastViewModelProtocol,
         dataSource: CollectionViewConfigurable) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubsviews()
        addConstraints()
        fetchData()
    }
    
    // MARK: - Private Functions
    
    private func addSubsviews() {
        forecastView.collectionView.addSubview(refreshControll)
        view.addSubview(forecastView)
        view.addSubview(loadingView)
    }
    
    private func addConstraints() {
        forecastView.snp.makeConstraints({ $0.edges.equalToSuperview() })
        loadingView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
    
    private func prepareHeader(header: Forecast.HeaderViewModel) {
        let temperature = header.tempterature.rounded(.toNearestOrAwayFromZero)
        let rightText = String(format: "%.0f ºC", temperature)
        forecastView.configure(with: .init(leftText: header.weatherEmoji, rightText: rightText))
    }
    
    private func fetchData() {
        viewModel
            .fetchForecastData()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.loadingView.isHidden = true
                self?.refreshControll.endRefreshing()
                self?.dataSource.configure(with: $0)
                self?.prepareHeader(header: $0.header)
                self?.forecastView.collectionView.reloadData()
            }, onFailure: { [weak self] error in
                self?.refreshControll.endRefreshing()
                self?.presentAlertController()
            })
            .disposed(by: disposeBag)
    }
    
    private func presentAlertController() {
        loadingView.isHidden = true
        let alert = UIAlertController(title: "Sorry 😢", message: "Unable to present info", preferredStyle: .alert)
        alert.addAction(.init(title: "Try again", style: .default, handler: { [weak self] _ in
            self?.loadingView.isHidden = false
            self?.fetchData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func pullToRefresh() {
        refreshControll.beginRefreshing()
        fetchData()
    }
}
