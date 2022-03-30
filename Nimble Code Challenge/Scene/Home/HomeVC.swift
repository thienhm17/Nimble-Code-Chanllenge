//
//  HomeVC.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/28/22.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {

    @IBOutlet weak var surveyTitle: UILabel!
    @IBOutlet weak var surveyDescription: UILabel!
    @IBOutlet weak var surveyImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var viewModel = HomeVM()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestures()
        bind(to: viewModel)
        viewModel.loadNextPage()
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let date = viewModel.getDateString()
        dateLabel.text = date
    }
    
    private func setupGestures() {
        [UISwipeGestureRecognizer.Direction.left, .right, .down].forEach {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
            swipeGesture.direction = $0
            view.addGestureRecognizer(swipeGesture)
        }
    }
    
    private func bind(to viewModel: HomeVM) {
        viewModel.loading.observe(on: self) { [weak self] isLoading in
            self?.showLoading(isLoading: isLoading)
        }
        viewModel.error.observe(on: self) { [weak self] errorMessage in
            if let errorMessage = errorMessage {
                self?.showError(message: errorMessage)
            }
        }
        viewModel.currentSurvey.observe(on: self) { [weak self] survey in
            self?.update(survey: survey)
        }
    }
    
    // MARK: - Event Handler
    
    @objc func onSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            viewModel.getNextItem()
        case .right:
            viewModel.getPreviousItem()
        case .down:
            viewModel.refresh()
        default:
            break
        }
    }
    
    // MARK: - Private

    private func showLoading(isLoading: Bool) {
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    private func update(survey: Survey?) {
        // update survey image with fade animation
        if let coverImage = survey?.attributes?.coverImageURL,
           let url = URL(string: coverImage) {
            KF.url(url)
                .placeholder(surveyImage.image)
                .forceRefresh()
                .fade(duration: 0.5)
                .set(to: surveyImage)
        } else {
            surveyImage.image = nil
        }
        
        // update survey labels with fade animation
        UIView.transition(with: surveyTitle,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.surveyTitle?.text = survey?.attributes?.title ?? "" },
                          completion: nil)
        UIView.transition(with: surveyDescription,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.surveyDescription?.text = survey?.attributes?.attributesDescription ?? "" },
                          completion: nil)
    }
}
