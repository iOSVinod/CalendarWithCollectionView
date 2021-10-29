//
//  ViewController.swift
//  CalendarApp
//
//  Created by Binod Mandal on 01/09/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
   
    private var activityDataSource: Array<Dictionary<String, String>> = Array<Dictionary<String, String>>(){
           didSet{
               self.tableView.reloadData()
           }
       }
    private var yearToDisplay: Int = 0
    private let headerHeight: CGFloat = 25.0
    private let edgeInset : CGFloat = 4.0
    
    var storedOffsets = [Int: CGFloat]()
    var calendarDataSource :[[String]] = [Array<String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calendar"
        initializeDataSource()
        configureTableView()
        
    }
}

private extension HomeViewController {
    
    func initializeDataSource() -> Void{
           //calendarDataSource
           guard let currentYear = Date().year() else{ debugPrint("========= Invalide date-Time ========="); return }
          yearToDisplay = currentYear
        
           for month in 0...11{
            let daysCount = Utils.numberOfDaysIn((month), AndYear: currentYear)
            let startDayOfMonth: Int = Utils.startDay(ofMonth: (month + 1), Year: currentYear)
               
               var daysInfo: [String] = [String]()
               for day in 1...(daysCount + startDayOfMonth){
                   let appentToElement : String = day > startDayOfMonth ? "\(day - startDayOfMonth)" : ""
                   daysInfo.append(appentToElement)
               }
               calendarDataSource.insert(daysInfo, at: month)
           }
       }
    
    func configureTableView() -> Void {
           
           //Register custom cell
           self.tableView.register(UINib(nibName: "CalendarTableViewCell", bundle: nil), forCellReuseIdentifier: "CalendarTableViewCell")

           self.tableView.dataSource = self
           self.tableView.delegate = self
           
       }
    
    
    func calendarCell(for indexPath: IndexPath) -> CalendarTableViewCell {
        
        let cell : CalendarTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
        
        //configure cell
        cell.selectionStyle = .none
        cell.yearDisplayLabel.text = "\(yearToDisplay)"
        
        return cell
    }
    
    
    //--------------------------------------
       //-- CollectionView Cell helper methods
       //--------------------------------------
       
       func collectionViewCellTitle(atIndexPath indexPath: IndexPath) -> String {
           
           let titleArray : [String] = self.calendarDataSource[indexPath.section]
           let rtnValue : String = titleArray[indexPath.row]
           
           return rtnValue
       }
    
}

extension HomeViewController {
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1{
            guard let tableViewCell = cell as? CalendarTableViewCell else { return }
            storedOffsets[indexPath.section] = tableViewCell.collectionViewOffset
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rtnValue = 1
        return rtnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return calendarCell(for: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

         guard let tableViewCell = cell as? CalendarTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath)
         tableViewCell.collectionViewOffset = storedOffsets[indexPath.section] ?? 0
         return
         
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        defer {
        //            tableView.deselectRow(at: indexPath, animated: true)
        //        }
    }
}

//MARK: UICollectionView DataSource and Delegate methods
extension HomeViewController: UICollectionViewDataSource ,HorizontalFloatingHeaderLayoutDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let rtnValue =  12
        return rtnValue
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let rtnValue = self.calendarDataSource[section].count
        return rtnValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        
        let titleText = collectionViewCellTitle(atIndexPath: indexPath)
        
        if titleText == ""{
            let cell : EmptyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCollectionViewCell", for: indexPath ) as! EmptyCollectionViewCell
            return cell
        }
        
        let cell : DayDisplayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayDisplayCollectionViewCell", for: indexPath ) as! DayDisplayCollectionViewCell
        
        //configure cell
        cell.dayDisplayLabel.text = titleText
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let _collectionViewCell = cell as? DayDisplayCollectionViewCell else{ return }
        _collectionViewCell.layer.cornerRadius = 1.0
        _collectionViewCell.cellBackgroundView?.layer.cornerRadius = 1.0
    }
    
    //Headers
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerReusableView: MonthDisplayHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MonthDisplayHeaderView", for: indexPath) as! MonthDisplayHeaderView
        
        headerReusableView.monthNameDisplayLabel.text = Utils.monthText(for: indexPath)
        return headerReusableView
    }
    
    //MARK: Delegate (HorizontalFloatingHeaderDelegate)
    //Item Size
    internal func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderItemSizeAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.height - headerHeight) / CGFloat(7.0)
        return CGSize(width: width   , height: (width - edgeInset) )
        
    }
    
    // Header Size
    func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderSizeAt section: Int) -> CGSize {
        
        let rtnValue =  CGSize(width: 100, height: 25)
        return rtnValue
    }
    
    //Item Spacing
    func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderItemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    //Line Spacing
    func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderColumnSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    //Section Insets
    func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderSectionInsetAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
    }
    
}

///////////////////////////////////////////
//// UICollectionView delegate
//////////////////////////////////////////
extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
