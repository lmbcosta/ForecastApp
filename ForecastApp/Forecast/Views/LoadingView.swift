//
//  LoadingView.swift
//  ForecastApp
//
//  Created by Luis Costa on 14/02/2021.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.color = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubsviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubsviews() {
        addSubview(activityIndicator)
    }
    
    private func addConstraints() {
        activityIndicator.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
}
