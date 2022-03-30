//
//  HomeVM.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/29/22.
//

import Foundation

class HomeVM {
    
    let loading = Observable<Bool>(false)
    let error = Observable<String?>(nil)
    let currentSurvey = Observable<Survey?>(nil)
    var numberOfSurveys = 0
    
    private var items = [Survey]()
    private var currentPage = 0
    private let pageSize = 5
    private var hasMorePages = true
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    private var isRefreshing = true
    
    private (set) var currentIndex: Int = 0 {
        didSet {
            if items.count > currentIndex {
                currentSurvey.value = items[currentIndex]
            } else {
                currentSurvey.value = nil
            }
        }
    }
    
    private func appendItems(_ items: [Survey], of page: Int) {
        self.currentPage = page
        self.items.append(contentsOf: items)
        // check if need display first survey
        if page == 1 {
            currentIndex = 0
        }
    }
    
    private func resetPages() {
        currentPage = 0
        hasMorePages = true
        items.removeAll()
    }
    
    private func load() {
        
        let nextPage = self.nextPage
        if nextPage == 1 {
            self.loading.value = true
        }
        
        APIService.shared.getSurveys(pageIndex: nextPage, pageSize: pageSize) { [weak self] result in
            
            guard let self = self else { return }
            if nextPage == 1 {
                self.loading.value = false
            }
            
            switch result {
            case .success(let response):
                // if has list response data
                if let surveys = response.data {
                    self.appendItems(surveys, of: nextPage)
                    self.hasMorePages = surveys.count >= self.pageSize

                } else {
                    self.hasMorePages = false
                }
                // set number of records
                self.numberOfSurveys = response.meta?.records ?? 0
                
            case .failure(let error):
                // if error is 404 not found
                if case .specifiedCode(let code) = error,
                    code == 404 {
                    self.hasMorePages = false
                } else {
                    self.error.value = error.errorMessage
                }
            }
        }
    }
}

// MARK: - View event methods
extension HomeVM {
    
    func loadNextPage() {
        guard hasMorePages, !loading.value else { return }
        load()
    }
    
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM dd"
        return dateFormatter.string(from: Date()).uppercased()
    }
    
    func getNextItem() {
        guard currentIndex + 1 < items.count else { return }
        currentIndex += 1
        if hasMorePages && currentIndex == items.count - 2 {
            loadNextPage()
        }
    }
    
    func getPreviousItem() {
        guard currentIndex - 1 >= 0 else { return }
        currentIndex -= 1
    }
    
    func refresh() {
        resetPages()
        loadNextPage()
    }
}
