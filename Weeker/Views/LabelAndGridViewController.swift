//
//  ViewController.swift
//  Weeker
//
//  Created by Caleb Elson on 11/26/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit

class LabelAndGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var infoLayerScrollView: UIScrollView!
    @IBOutlet weak var livedAndLeftLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var randomlyDecreasedAlpha = CGFloat()
    private var ageModel = AgeModel()
    // Used to keep track of whether the current value in the collectionView has passed the user's current age
    private var ageReached = false
    private var theme = ThemeManager.currentTheme()
    
    
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
    }
    
    // Refreshes in viewDidAppear due to differences in lifecycle between swiping back and hitting back button
    override func viewDidAppear(_ animated: Bool) {
        if ageModel.dateOfBirth != AgeModel().dateOfBirth || theme != ThemeManager.currentTheme() {
            theme = ThemeManager.currentTheme()
            ageModel = AgeModel()
            refreshLabel()
            refreshCollectionView()
        }
        
        //        // Remove, for testing splash screen
        //        UserDefaults(suiteName: "group.com.calebElson.Weeker")?.removeObject(forKey: "syncDOB")
    }
    
    
    // MARK: - Refresh and Interaction Methods
    @IBAction func infoButtonPressed(_ sender: Any) {
        infoLayerScrollView.isHidden = !infoLayerScrollView.isHidden
    }
    
    func refreshLabel() {
        ageReached = false
        
        let weeksLivedString = "Weeks Lived: \(ageModel.weeksLived), \(ageModel.percentLived)%"
        let weeksLeftString = "Weeks Left: \(ageModel.weeksLeft), \(ageModel.percentLeft)%"
        
        let labelString = "\(weeksLivedString)\n\(weeksLeftString)"
        
        let range = (labelString as NSString).range(of: weeksLeftString)
        let attributedString = NSMutableAttributedString.init(string: labelString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: theme.primaryColor, range: range)
        
        livedAndLeftLabel.attributedText = attributedString
    }
    
    func refreshCollectionView() {
        collectionView.isHidden = true
        livedAndLeftLabel.isHidden = true
        activityIndicator.color = theme.primaryColor
        activityIndicator.isHidden = false
        infoLayerScrollView.isHidden = true
        activityIndicator.startAnimating()
        
        refreshLabel()

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        DispatchQueue.main.async {
            self.collectionView.isHidden = false
            self.livedAndLeftLabel.isHidden = false
            self.activityIndicator.isHidden = true
            self.infoLayerScrollView.isHidden = false
            self.activityIndicator.stopAnimating()
        }
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
        
        randomlyDecreasedAlpha = CGFloat(Double.random(in: 0.25...0.5))
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        if indexPath[0] == ageModel.timeSinceDOB.year && indexPath[1] == ageModel.timeSinceDOB.weekOfYear {
            ageReached = true
        }
        
        if ageReached {
            cell.backgroundColor = theme.secondaryColor.withAlphaComponent(randomlyDecreasedAlpha)
            cell.layer.borderWidth = 0.75
            cell.layer.borderColor = theme.primaryColor.withAlphaComponent(randomlyDecreasedAlpha).cgColor
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
