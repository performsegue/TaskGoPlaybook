//
//  ViewController.swift
//  TaskGoPlayBook
//
//  Created by Bharath  Raj kumar on 21/02/19.
//  Copyright © 2019 Bharath Raj Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var LocationDisplayLabel: UILabel!
    @IBOutlet weak var changeLocationButton: UIButton!
    @IBOutlet weak var searchScopeCollectionView: UICollectionView!
    
    
    //Local Variables
    let searchScopeVariables = ["Tournaments","Grounds","Teams","Players"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchScopeCollectionView.delegate = self
        searchScopeCollectionView.dataSource = self
        
        
       self.searchScopeCollectionView.register(UINib(nibName: "SearchScopeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
    //self.searchScopeCollectionView.register(SearchScopeCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")

    }


}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let CollectionType = self.searchScopeVariables[indexPath.row]
        let textfield = UITextField()
        textfield.font?.withSize(18)
        textfield.text = "\(CollectionType)"
        var  myTextViewSize = CGSize()
        myTextViewSize = textfield.sizeThatFits(CGSize(width: textfield.frame.width,height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: myTextViewSize.width+20,height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchScopeCollectionView
        {
            let cell: SearchScopeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! SearchScopeCollectionViewCell
            
            cell.backgoundSelectionView.layer.cornerRadius = 20
            cell.backgoundSelectionView.layer.masksToBounds = true
            cell.scopeNameLabel.text = searchScopeVariables[indexPath.row]
            
          return cell
            
        }
        else
        {
            return UICollectionViewCell()
        }
        
        
       
        
        
    }
    
   
}
