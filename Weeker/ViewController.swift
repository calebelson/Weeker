//
//  ViewController.swift
//  Weeker
//
//  Created by Caleb Elson on 11/26/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    private var decreasingAlpha = CGFloat()
    private var timeSinceDOB = DateComponents()
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
        
        // Remove, for testing splash screen
//        UserDefaults.standard.removeObject(forKey: "DOB")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeSinceDOB = Calendar.current.dateComponents([.year, .weekOfYear], from: UserDefaults.standard.value(forKey: "DOB") as! Date, to: Date())
        
        let daysLived = Calendar.current.dateComponents([.day], from: UserDefaults.standard.value(forKey: "DOB") as! Date, to: Date())
        let ninetyYearsFromDOB = Calendar.current.date(byAdding: .year, value: 90, to: UserDefaults.standard.value(forKey: "DOB") as! Date)
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: ninetyYearsFromDOB!)
        leftLabel.text = "Weeks Lived:\n\(daysLived.day!/7)"
        middleLabel.text = "Weeks Left:\n\(daysLeft.day!/7)"
        rightLabel.text = "Life Lived: \n\(daysLived.day!*100/(daysLived.day!+daysLeft.day!))%"
        
        
        print(timeSinceDOB)
        
        print(UserDefaults.standard.value(forKey: "DOB") as! Date)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 52
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        decreasingAlpha = CGFloat(90 - Double(indexPath.section)/1.3)/90
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        if ageReached {
            cell.backgroundColor = #colorLiteral(red: 0.6979569793, green: 0.8412405849, blue: 0.9987565875, alpha: 1).withAlphaComponent(decreasingAlpha)

        } else {
            cell.backgroundColor = #colorLiteral(red: 0.9998636842, green: 0.597361505, blue: 0.5580425858, alpha: 1).withAlphaComponent(decreasingAlpha)
        }

        
        
        if indexPath[0] == timeSinceDOB.year! && indexPath[1] == timeSinceDOB.weekOfYear! {
            ageReached = true
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 90
    }
    
    
    
    // Generate a random UIColor
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: decreasingAlpha)
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
