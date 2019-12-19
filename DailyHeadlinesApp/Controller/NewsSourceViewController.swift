//
//  NewsSourceViewController.swift
// DailyHeadlinesApp
//

import UIKit
import CNPPopupController

class NewsSourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, CNPPopupControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var sourceTableView: UITableView!
    @IBOutlet var categoryTableView: UITableView!
    @IBOutlet weak var categoryButton: UIBarButtonItem!
  
    // MARK: - Variable declaration
    var sourceItems = [Source]()
    
    var filteredSourceItems = [Source]()
    
    var selectedItem: Source?
    
    var categories: [String] = []
    
    var popupController:CNPPopupController?

    var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = "Search Sources..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .black
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    let spinningActivityIndicator = TSActivityIndicator()
    
    //Activity Indicator Container View
    let container = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup UI
        setupUI()
        
        //Populate TableView Data
        loadSourceData("")
        //setup TableView
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultsSearchController.delegate = nil
        resultsSearchController.searchBar.delegate = nil
    }
    
    // MARK: - Setup UI
    func setupUI() {
        setupSearch()
    }
    
    // MARK: - Setup SearchBar
    func setupSearch() {
        resultsSearchController.searchResultsUpdater = self
        navigationItem.titleView = resultsSearchController.searchBar
        definesPresentationContext = true
    }
    
    // MARK: - Setup TableView
    func setupTableView() {
        sourceTableView.register(UINib(nibName: "DailySourceItemCell",
                                       bundle: nil),
                                 forCellReuseIdentifier: "DailySourceItemCell")
        sourceTableView.tableFooterView = UIView()
    }
    
    // MARK: - Setup Spinner
    func setupSpinner(hidden: Bool) {
        container.isHidden = hidden
        if !hidden {
            spinningActivityIndicator.setupTSActivityIndicator(container)
        }
    }
    
    // MARK: - Show News Categories
    @IBAction func presentCategories(_ sender: Any)
    {
        categoryTableView.frame = CGRect(x: 0, y: self.view.frame.size.height / 2 - 175, width: self.view.frame.size.width - 50, height: 350)
        let popupController = CNPPopupController(contents:[categoryTableView])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.centered
        popupController.delegate = self
        self.popupController = popupController
        popupController.present(animated: true)
    }
    
    // MARK: - Load data from network
    func loadSourceData(_ category: String?) {
        setupSpinner(hidden: false)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        NetworkManager.makeRequest(DailyNewsHttpRouter.source(category: category!))
            .onSuccess { (response: SourceResponse) in
                print(response)
                
                DispatchQueue.main.async(execute: {
                    self.spinningActivityIndicator.stopAnimating()
                    self.setupSpinner(hidden: true)
                    UIApplication.shared.endIgnoringInteractionEvents()
                })
                self.sourceItems = response.source
                
                if category == "" {
                    self.categories = Array(Set(self.sourceItems.map { $0.category }))
                }
                DispatchQueue.main.async(execute: {
                    self.sourceTableView.reloadData()
                    self.spinningActivityIndicator.stopAnimating()
                    self.setupSpinner(hidden: true)
                    UIApplication.shared.endIgnoringInteractionEvents()
                })
            } .onFailure { error in
                switch error {
                default:
                    self.spinningActivityIndicator.stopAnimating()
                    self.container.removeFromSuperview()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.showError("Something went wrong. Please try again.", message: "") { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } .onComplete { _ in
                self.spinningActivityIndicator.stopAnimating()
                self.container.removeFromSuperview()
        }
    }
    
    // MARK: - Status Bar Color and swutching actions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden ?? false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == sourceTableView) {
            if self.resultsSearchController.isActive {
                return self.filteredSourceItems.count + 1
            } else {
                return self.sourceItems.count + 1
            }
        }
        else {
            return categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == sourceTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailySourceItemCell",
                                                     for: indexPath) as? DailySourceItemCell
            
            if indexPath.row == 0 { return DailySourceItemCell() }
            if self.resultsSearchController.isActive {
                cell?.sourceImageView.downloadedFromLink(filteredSourceItems[indexPath.row - 1].urlsToLogos)
            } else {
                cell?.sourceImageView.downloadedFromLink(sourceItems[indexPath.row - 1].urlsToLogos)
            }
            
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",
                                                    for: indexPath) as? CategoryTableViewCell
            cell?.categoryNameLabel.text = categories[indexPath.row]
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == sourceTableView){
            if self.resultsSearchController.isActive {
                self.selectedItem = filteredSourceItems[indexPath.row - 1]
            } else {
                self.selectedItem = sourceItems[indexPath.row - 1]
            }
            
            self.performSegue(withIdentifier: "sourceUnwindSegue", sender: self)
        }
        else {
            popupController?.dismiss(animated: true)
            self.loadSourceData(categories[indexPath.row])
        }
    }
    
    // MARK: - SearchBar Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredSourceItems.removeAll(keepingCapacity: false)
        
        if let searchString = searchController.searchBar.text {
            let searchResults = sourceItems.filter { $0.name.lowercased().contains(searchString.lowercased()) }
            filteredSourceItems = searchResults
            self.sourceTableView.reloadData()
        }
    }
}
