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
    private var decreasingAlpha = CGFloat()
    private var timeSinceDOB = DateComponents()
    private var alwaysRed = false
    
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeSinceDOB = Calendar.current.dateComponents([.year, .weekOfYear], from: UserDefaults.standard.value(forKey: "DOB") as! Date, to: Date())
        
        print(timeSinceDOB)
        
        print(UserDefaults.standard.value(forKey: "DOB") as! Date)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 52
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        decreasingAlpha = CGFloat(90 - (indexPath.section/2))/90
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        if alwaysRed {
            
            cell.backgroundColor = randomColor()
        } else {
            cell.backgroundColor = UIColor.green.withAlphaComponent(decreasingAlpha)
        }

        
        
        if indexPath[0] > timeSinceDOB.year! && indexPath[1] > timeSinceDOB.weekOfYear! {
            alwaysRed = true
        }
        
        if indexPath[0] == 89 || indexPath[1] == 51 {
            cell.backgroundColor = .red
        }
        

//        print("row \(indexPath[0]), column \(indexPath[1])")
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 90
    }
    
    
    
    // custom function to generate a random UIColor
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
