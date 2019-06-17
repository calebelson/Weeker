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
    @IBOutlet weak var livedAndLeftLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var decreasingAlpha = CGFloat()
    private var ageModel = AgeModel()
    // Used to keep track of whether the current value in the collectionView has past the user's current age
    private var ageReached = false
    private let mainColor = UIColor(named: "mainColor") ?? .systemTeal
    private let secondaryColor = UIColor(named: "secondaryColor") ?? UIColor.systemOrange
    
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 52,
        numberOfRows: AgeModel().lifeSpan,
        minimumInteritemSpacing: 2,
        minimumLineSpacing: 2,
        sectionInset: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    )
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        if ageModel.dateOfBirth != AgeModel().dateOfBirth || ageModel.lifeSpanSwitchOn != AgeModel().lifeSpanSwitchOn {
            ageModel = AgeModel()
            refreshLabel()
            refreshCollectionView()
        }
        
//        // Remove, for testing splash screen
//        UserDefaults(suiteName: "group.com.calebElson.Weeker")?.removeObject(forKey: "DOB")
    }
    
    func refreshLabel() {
        ageReached = false
        
        let weeksLivedString = "Weeks Lived: \(ageModel.weeksLived), \(ageModel.percentLived)%"
        let weeksLeftString = "Weeks Left: \(ageModel.weeksLeft), \(ageModel.percentLeft)%"
        
        let labelString = "\(weeksLivedString)\n\(weeksLeftString)"
        
        let range = (labelString as NSString).range(of: weeksLeftString)
        let attributedString = NSMutableAttributedString.init(string: labelString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: mainColor, range: range)
        
        livedAndLeftLabel.attributedText = attributedString
    }
    
    func refreshCollectionView() {
        collectionView.isHidden = true
        // Label only needs to be hidden for collectionView refresh
        livedAndLeftLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        refreshLabel()

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        DispatchQueue.main.async {
            self.collectionView.isHidden = false
            self.livedAndLeftLabel.isHidden = false
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes clear that going back from DOBViewController cancels DOB change
        let backItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        refreshLabel()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 52
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //decreasingAlpha = CGFloat(Double(ageModel.lifeSpan) - Double(indexPath.section)/1.3)/CGFloat(ageModel.lifeSpan)
        
        decreasingAlpha = CGFloat(Double(ageModel.lifeSpan) - Double.random(in: 0...Double(ageModel.lifeSpan))*0.25)/CGFloat(ageModel.lifeSpan)
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        if indexPath[0] == ageModel.timeSinceDOB.year && indexPath[1] == ageModel.timeSinceDOB.weekOfYear {
            ageReached = true
        }
        
        cell.layer.cornerRadius = 2
        cell.layer.masksToBounds = true
        
        if ageReached {
            cell.backgroundColor = mainColor.withAlphaComponent(decreasingAlpha)

        } else {
            cell.backgroundColor = secondaryColor.withAlphaComponent(decreasingAlpha)
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
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow))
        
        let verticalMarginsAndInsets = sectionInset.top + sectionInset.bottom + collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom + minimumLineSpacing * CGFloat(numberOfRows - 1)
        let itemHeight = ((collectionView.bounds.size.height - verticalMarginsAndInsets) / CGFloat(numberOfRows))
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        
        return context
    }
}
