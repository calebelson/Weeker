//
//  ViewController.swift
//  Weeker
//
//  Created by Caleb Elson on 11/26/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit

class LabelAndGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    private var randomlyDecreasedAlpha = CGFloat()
    private var ageModel = AgeModel()
    // Used to keep track of whether the current value in the collectionView has passed the user's current age
    private var ageReached = false
    private var theme = ThemeManager.currentTheme()
    private var infoLayerData = InfoLayerModel(header: nil, content: [])
    private var onlyOneSegue = true

    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        navigationController?.navigationBar.tintColor = theme.primaryColor
        
        // If no DOB set, shows DOBVC with cancel/back button hidden
        if UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: "syncDOB") == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "HomeVCToDOBVC", sender: self)
            }
        }
        
        activityIndicator.isHidden = true
        refreshLabel()
        refreshTableView()
    }
    
    // Refreshes in viewDidAppear due to differences in lifecycle between swiping back and hitting back button
    override func viewDidAppear(_ animated: Bool) {
        if ageModel.dateOfBirth != AgeModel().dateOfBirth || theme != ThemeManager.currentTheme() {
            theme = ThemeManager.currentTheme()
            ageModel = AgeModel()
            refreshCollectionView()
            refreshTableView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        onlyOneSegue = true
        
        if ageModel.dateOfBirth != AgeModel().dateOfBirth || theme != ThemeManager.currentTheme() {
            settingsButton.isEnabled = false
            infoButton.isEnabled = false
            onlyOneSegue = false
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if onlyOneSegue {
            onlyOneSegue = false
            return true
        }
        
        return onlyOneSegue
    }
    
    
    // MARK: - Refresh and Interaction Methods
    @IBAction func infoButtonPressed(_ sender: Any) {
        infoTableView.isHidden = !infoTableView.isHidden
    }
    
    func refreshLabel() {
        ageReached = false
        
        let weeksLivedString = "Weeks Lived: \(ageModel.weeksLived), \(ageModel.percentLived)%"
        let weeksLeftString = "Weeks Left: \(ageModel.weeksLeft), \(ageModel.percentLeft)%"
        
        let labelString = "\(weeksLivedString)\n\(weeksLeftString)"
        
        let range = (labelString as NSString).range(of: weeksLeftString)
        let attributedString = NSMutableAttributedString.init(string: labelString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: theme.primaryColor, range: range)
    }
    
    func refreshCollectionView() {

        refreshCollectionViewHelper(beforeCollectionViewRefresh: true, completionHandler: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates(nil, completion: { _ in
                print("batch updates")
                
                self.refreshCollectionViewHelper(beforeCollectionViewRefresh: false, completionHandler: nil)
            })
        }
    }
    
    func refreshCollectionViewHelper(beforeCollectionViewRefresh: Bool, completionHandler: (() -> ())? = nil ) {
        collectionView.isHidden = beforeCollectionViewRefresh
        activityIndicator.isHidden = !beforeCollectionViewRefresh
        infoTableView.isHidden = beforeCollectionViewRefresh
        infoButton.isEnabled = !beforeCollectionViewRefresh
        settingsButton.isEnabled = !beforeCollectionViewRefresh
        activityIndicator.color = theme.primaryColor
        
        if beforeCollectionViewRefresh {
            activityIndicator.startAnimating()
            infoTableView.reloadData()
            refreshLabel()
        } else {
            activityIndicator.stopAnimating()
            onlyOneSegue = true
        }
        
        if let completionHandler = completionHandler {
            completionHandler()
        }
    }
    
    // MARK: - InfoTableView setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoLayerData.content.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =  UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.frame
            .width, height: headerView.frame.height))
        label.textAlignment = .left
        label.text = infoLayerData.header
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = theme.primaryColor
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "InfoContentCell")
        
        let cellData = infoLayerData.content[indexPath.row]
                
        if cellData.subheader {
            cell = tableView.dequeueReusableCell(withIdentifier: "InfoSubheaderCell")
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.shadowColor = theme.primaryColor
        } else {
            cell?.detailTextLabel?.text = cellData.detailText
            cell?.detailTextLabel?.textColor = theme.primaryColor
        }
        
        cell?.textLabel?.text = cellData.mainText
        cell?.textLabel?.textColor = theme.primaryColor
        
        return cell!
    }
    
    func refreshTableView() {
        let content: [(String, String?, Bool)] = [("Based on 90 year lifespan:", nil, true), ("Days Lived", "\(ageModel.daysLived)", false), ("Weeks Lived", "\(ageModel.weeksLived)", false), ("Weeks Left", "\(ageModel.weeksLeft)", false), ("Percent Lived", "\(ageModel.percentLived)",  false), ("Percent Left", "\(ageModel.percentLeft)",  false), ("Based on actuarial data:", nil, true), ("Life Span", "\(ageModel.actuarialLifeSpan)", false), ("Weeks Left", "\(ageModel.actuarialWeeksLeft)", false), ("Percent Lived", "\(ageModel.actuarialPercentLived)", false), ("Percent Left", "\(ageModel.actuarialPercentLeft)", false)]
        
        infoLayerData = InfoLayerModel(header: "Stats", content: content)
    }
    

    // MARK: - CollectionView Setup
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 52,
        numberOfRows: AgeModel().lifeSpan,
        minimumInteritemSpacing: 1,
        minimumLineSpacing: 2,
        sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
    )
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 52
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        randomlyDecreasedAlpha = CGFloat.random(in: 0.35...0.5)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        if indexPath[0] == ageModel.timeSinceDOB.year && indexPath[1] == ageModel.timeSinceDOB.weekOfYear {
            ageReached = true
        }
        
        if ageReached {
            cell.backgroundColor = theme.secondaryColor.withAlphaComponent(randomlyDecreasedAlpha)
            cell.layer.borderWidth = 0.75
                        
            if #available(iOS 13.0, *) {
                view.traitCollection.performAsCurrent {
                    cell.layer.borderColor = theme.primaryColor.withAlphaComponent(randomlyDecreasedAlpha).cgColor
                }
            } else {
                // Fallback on earlier versions
                cell.layer.borderColor = theme.primaryColor.withAlphaComponent(randomlyDecreasedAlpha).cgColor
            }
            
            

        } else {
            cell.layer.borderWidth = 0
            cell.backgroundColor = theme.primaryColor.withAlphaComponent(randomlyDecreasedAlpha)
        }
        
        return cell
    }
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ageModel.lifeSpan
    }
}




class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    let cellsPerRow: Int
    let numberOfRows: Int
    
    init(cellsPerRow: Int, numberOfRows: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        self.numberOfRows = numberOfRows
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow+1))
        
        let verticalMarginsAndInsets = sectionInset.top + sectionInset.bottom + collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom + minimumLineSpacing * CGFloat(numberOfRows - 1)
        let itemHeight = ((collectionView.bounds.size.height - verticalMarginsAndInsets) / CGFloat(numberOfRows+1))
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        
        return context
    }
}
