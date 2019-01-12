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
    
    private var decreasingAlpha = CGFloat()
    private var ageModel = AgeModel()
    private var ageReached = false
    
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 52,
        minimumInteritemSpacing: 2,
        minimumLineSpacing: 2,
        sectionInset: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    )
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        if ageModel.current() != AgeModel().current() {
            ageModel = AgeModel()
            refresh()
        }
        
//        // Remove, for testing splash screen
//        UserDefaults(suiteName: "group.com.calebElson.Weeker")?.removeObject(forKey: "DOB")
    }
    
    func refresh() {
        livedAndLeftLabel.isHidden = true
        collectionView.isHidden = true

        DispatchQueue.main.async {
            self.ageReached = false
            
            let weeksLivedString = "Weeks Lived: \(self.ageModel.weeksLivedAndLeft().weeksLived), \(self.ageModel.weeksLivedAndLeft().percentLived)%"
            let weeksLeftString = "Weeks Left: \(self.ageModel.weeksLivedAndLeft().weeksLeft), \(self.ageModel.weeksLivedAndLeft().percentLeft)%"
            
            let labelString = "\(weeksLivedString)\n\(weeksLeftString)"
            
            let range = (labelString as NSString).range(of: weeksLeftString)
            let attributedString = NSMutableAttributedString.init(string: labelString)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.6979569793, green: 0.8412405849, blue: 0.9987565875, alpha: 1), range: range)
            
            self.livedAndLeftLabel.attributedText = attributedString
            
            self.collectionView.reloadData()
        }
        
        DispatchQueue.main.async {
            self.collectionView.isHidden = false
            self.livedAndLeftLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes clear that going back from DOBViewController cancels DOB change
        let backItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        refresh()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 52
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        decreasingAlpha = CGFloat(90 - Double(indexPath.section)/1.3)/90
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        if indexPath[0] == ageModel.current().year && indexPath[1] == ageModel.current().weekOfYear {
            ageReached = true
        }
        
        if ageReached {
            cell.backgroundColor = #colorLiteral(red: 0.6979569793, green: 0.8412405849, blue: 0.9987565875, alpha: 1).withAlphaComponent(decreasingAlpha)

        } else {
            cell.backgroundColor = #colorLiteral(red: 0.9998636842, green: 0.597361505, blue: 0.5580425858, alpha: 1).withAlphaComponent(decreasingAlpha)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 90
    }
}




class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    let cellsPerRow: Int
    
    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
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
        
        let verticalMarginsAndInsets = sectionInset.top + sectionInset.bottom + collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom + minimumLineSpacing * CGFloat(90 - 1)
        let itemHeight = ((collectionView.bounds.size.height - verticalMarginsAndInsets) / CGFloat(90))
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        
        return context
    }
    
}
