//
//  CalendarTableViewCell.swift
//  CalendarApp
//
//  Created by Binod Mandal on 01/09/21.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var yearDisplayLabel: UILabel!
    @IBOutlet weak private var calendarCollectionView: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
//MARK: Extensions
//--------------------------
// Private
//--------------------------
private extension CalendarTableViewCell {
    
    func setupCollectionView(){
        
        calendarCollectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
      
        calendarCollectionView?.register(UINib(nibName: "MonthDisplayHeaderView",bundle: nil) , forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MonthDisplayHeaderView")
        
        calendarCollectionView?.register(UINib(nibName: "DayDisplayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DayDisplayCollectionViewCell")
        calendarCollectionView.register(UINib(nibName: "EmptyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "emptyCollectionViewCell")
    }
}

//--------------------------
// Internal
//--------------------------
extension CalendarTableViewCell {
       
        func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow indexPath: IndexPath) {
            
            calendarCollectionView?.delegate = dataSourceDelegate
            calendarCollectionView?.dataSource = dataSourceDelegate
            calendarCollectionView?.tag = indexPath.section
            calendarCollectionView?.setContentOffset((calendarCollectionView?.contentOffset)!, animated:false) // Stops collection view if it was scrolling.
            //   collectionViewIdealMatch?.reloadItems(at: [indexPath])
            
        }
        
        var collectionViewOffset: CGFloat {
            set { calendarCollectionView?.contentOffset.x = newValue }
            get { return calendarCollectionView?.contentOffset.x ?? 0 }
        }
}
