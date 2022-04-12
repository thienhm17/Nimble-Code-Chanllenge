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
    
    @IBOutlet weak var indicatorClv: UICollectionView!
    
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
        // hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        // setup indicator collection view
        indicatorClv.dataSource = self
        indicatorClv.delegate = self
        // setup date label
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
           let url = URL(string: coverImage + "l") {
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
        
        // update indicator
        indicatorClv.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) { [weak self] in
            guard let self = self,
                  self.viewModel.numberOfSurveys > 0 else {
                      return
                  }
            // scroll to current index
            self.indicatorClv.scrollToItem(at: IndexPath(item: self.viewModel.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            
        }
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfSurveys
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DotIndicatorCell else {
            return UICollectionViewCell()
        }
        
        cell.updateCell(isFocused: indexPath.item == viewModel.currentIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 8, height: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
