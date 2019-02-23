//
//  ViewController.swift
//  TaskGoPlayBook
//
//  Created by Bharath  Raj kumar on 21/02/19.
//  Copyright © 2019 Bharath Raj Kumar. All rights reserved.
//

import UIKit
import CoreLocation

struct tableHeader
{
    var title: String
    var Desc: String
    
}

enum SearchScopeVal: String
{
    case Tournament = "Tournament"
    case Ground = "Ground"
    case Team = "Team"
    case Players = "Players"
    
    func Description() -> String
    {
        switch self
        {
        case .Tournament: return "Take part in exciting tournaments near you or follow them live"
        case .Ground: return "Discover Grounds nearby your location"
        case .Team: return "Create your own teams or join teams over goplaybook and grow"
        case .Players: return "Follow top players and fiends and keep yourself updated with their activities"
        }
    }
}


class ViewController: UIViewController, CLLocationManagerDelegate {

    //@IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var LocationDisplayLabel: UILabel!
    @IBOutlet weak var changeLocationButton: UIButton!
    @IBOutlet weak var searchScopeCollectionView: UICollectionView!
    @IBOutlet weak var displayTableView: UITableView!
    
    
    //Local Variables
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
    let searchScopeVariables = ["Tournaments","Grounds","Teams","Players"]
    var tournamentArray: TournamentData?
    lazy var filteredTournamentArray: [Tournament] = []
    lazy var toFilteredTournamentArray: [Tournament] = []
    var groundArray: GroundData?
    lazy var filteredGroundArray: [Ground] = []
    lazy var toFilteredGroundArray: [Ground] = []
    var TeamArray: TeamData?
    lazy var filteredTeamArray: [Team] = []
    lazy var toFilteredTeamArray: [Team] = []
    var playerArray: PlayerData?
    lazy var filteredPlayerArray: [Player] = []
    lazy var toFilteredPlayerArray: [Player] = []
    var tournament: [Tournament]?
    var searchScope = SearchScopeVal.Tournament
    var searchScopeTwo = "Tournament"
    var city = "delhi"
    var GroundPageNo = 1
    var lastPage = 0
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        searchScopeCollectionView.delegate = self
        searchScopeCollectionView.dataSource = self
        let indexPath = IndexPath.init(item: 0, section: 0)
        searchScopeCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        displayTableView.delegate = self
        displayTableView.dataSource = self
        
       self.searchScopeCollectionView.register(UINib(nibName: "SearchScopeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
        self.displayTableView.register(UINib(nibName: "TournamentTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        self.displayTableView.register(UINib(nibName: "GroundTableViewCell", bundle: nil), forCellReuseIdentifier: "customCellOne")
        self.displayTableView.register(UINib(nibName: "TeamTableViewCell", bundle: nil), forCellReuseIdentifier: "customCellTwo")
        self.displayTableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "customCellThree")
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        
        searchBar.placeholder = "Start Searching"
        searchBar.tintColor = .white
        self.navigationItem.titleView = searchBar

        
        
        self.tableHeader(title: SearchScopeVal.Tournament.rawValue, description: SearchScopeVal.Tournament.Description())
       // self.serverTournamentData()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchBarCenterInit()
    }
    // Get the latitude and Longitude of User
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations =  \(locValue.longitude)")
       getAddressFromLatLon(pdblLatitude: "\(locValue.latitude)", withLongitude: "\(locValue.longitude)")
    }
    //Reverse Geocoding the lat and Log to get the area (Test with location of Indira Gandhi Internation Airport)
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country as Any)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    print(pm.administrativeArea)
                    
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                       // self.LocationDisplayLabel.text = pm.thoroughfare ?? "nil"
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                      //  self.LocationDisplayLabel.text = pm.locality ?? "nil"
                       // self.city = "\(pm.locality ?? "error" )"
                     //   self.serverTournamentData()
                      //  print(self.toFilteredTeamArray.count)
                    }
                    if pm.administrativeArea != nil {
                       // addressString = addressString + pm.locality! + ", "
                        self.LocationDisplayLabel.text = pm.administrativeArea ?? "nil"
                        self.city = "\(pm.administrativeArea ?? "")"
                    
                          self.serverTournamentData()
                        
                    }
                    if pm.administrativeArea != nil {
                        // addressString = addressString + pm.locality! + ", "
                        //  self.LocationDisplayLabel.text = pm.locality ?? "nil"
                       // self.city = " Area \(pm.administrativeArea)"
                        //   self.serverTournamentData()
                        
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(addressString)
                }
        })
        locationManager.stopUpdatingLocation()
    }
    func searchBarCenterInit(){
        if let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField {
            
            //Center search text
            searchBarTextField.textAlignment = .center
            searchBarTextField.layer.cornerRadius = searchBarTextField.frame.width / 2
            searchBarTextField.layer.masksToBounds = true
            searchBarTextField.backgroundColor = UIColor(red:0.29, green:0.53, blue:0.21, alpha:1.0)
            searchBarTextField.textColor = .white
            searchBarTextField.contentMode = .center
            searchBarTextField.attributedPlaceholder = NSAttributedString(string: "Start Searching",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            //Center placeholder
            let width = searchBar.frame.width / 2 - (searchBarTextField.attributedPlaceholder?.size().width)!
          let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: searchBar.frame.height))
           searchBarTextField.leftView = paddingView
           searchBarTextField.leftViewMode = .unlessEditing
            if let backgroundview = searchBarTextField.subviews.first {
                // Background color
                backgroundview.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
                // Rounded corner
                backgroundview.layer.cornerRadius = 20
                backgroundview.clipsToBounds = true
            }
        }
    }
    func tableHeader(title:String, description: String)
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackground
        headerView.frame = CGRect(x: 0, y: 0, width: self.displayTableView.frame.size.width, height: 100)
        let TitleLabel = UILabel()
        TitleLabel.frame = CGRect(x: 16, y: 8, width: self.displayTableView.frame.size.width - 32, height: 35)
        TitleLabel.text = title
        TitleLabel.font = UIFont(name: "Futura", size: 30)
        headerView.addSubview(TitleLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(x: 16, y: 50, width: self.displayTableView.frame.size.width - 32, height: 50)
        descriptionLabel.text = description
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont(name: "Futura", size: 15)
        headerView.addSubview(descriptionLabel)
        
        self.displayTableView.tableHeaderView = headerView
    }
    
    func serverTournamentData()
    {
        let baseUrl = "http://52.66.194.65/api/search/v1/globalsearch/?arg=tournament&city=\(city)&query=&page=1"
       
        self.tournamentArray = nil
        self.filteredTournamentArray.removeAll()
        Service.shared.fetchContacts(TournamentData.self, urlString: baseUrl, completion: {
            (downloadedData, err) in
            self.tournamentArray = downloadedData
           // print(self.tournamentArray as Any)
           for value in self.tournamentArray?.data ?? []
           {
           // print(value)
            self.filteredTournamentArray.append(value)
            
            }
            
            self.toFilteredTournamentArray = self.filteredTournamentArray
            self.displayTableView.reloadData()
        })
    }
    
    func serverGroundData()
    {
        
        print(GroundPageNo)
        let baseUrl = "http://52.66.194.65/api/search/v1/globalsearch/?arg=ground&city=\(city)&query=&page=\(GroundPageNo)"
        
        if GroundPageNo == 1
        {
            self.groundArray = nil
            self.filteredGroundArray.removeAll()
        }
        else
        {
            
        }
       
       
        print(groundArray?.last_page as Any)
        
            Service.shared.fetchContacts(GroundData.self, urlString: baseUrl, completion: {
                (downloadedData, err) in
                
               self.groundArray = downloadedData
                self.lastPage = downloadedData?.last_page ?? 1
                print("Last Page \(self.lastPage)")
                
                if self.GroundPageNo <= self.lastPage
                {
                    for value in self.groundArray?.data ?? []
                    {
                        // print(value)
                        self.filteredGroundArray.append(value)
                        
                    }
                }
                
               
               
                self.toFilteredGroundArray = self.filteredGroundArray
               // print(self.groundArray)
                print("Count: \(self.toFilteredGroundArray.count)")
                self.displayTableView.reloadData()
            })
    }
    
    func serverTeamData()
    {
        
        
        let baseUrl = "http://52.66.194.65/api/search/v1/globalsearch/?arg=ground&city=\(city)&query=&page=1"
        
        print(TeamArray?.last_page as Any)
        self.filteredTeamArray.removeAll()
        Service.shared.fetchContacts(TeamData.self, urlString: baseUrl, completion: {
            (downloadedData, err) in
            
            self.TeamArray = downloadedData
            for value in self.TeamArray?.data ?? []
            {
                // print(value)
                self.filteredTeamArray.append(value)
                
            }
            self.toFilteredTeamArray = self.filteredTeamArray
             print(self.TeamArray)
            self.displayTableView.reloadData()
        })
    }
    
    func serverPlayerData()
    {
        print(GroundPageNo)
        
        let baseUrl = "http://52.66.194.65/api/search/v1/globalsearch/?arg=player&city=\(city)&query=&page=1"
        
        print(groundArray?.last_page as Any)
        
        Service.shared.fetchContacts(PlayerData.self, urlString: baseUrl, completion: {
            (downloadedData, err) in
            
            self.playerArray = downloadedData
            for value in self.playerArray?.data ?? []
            {
                // print(value)
                self.filteredPlayerArray.append(value)
                
            }
            self.toFilteredPlayerArray = self.filteredPlayerArray
             print(self.playerArray)
            self.displayTableView.reloadData()
        })
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
        return CGSize(width: myTextViewSize.width+25,height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchScopeCollectionView
        {
            let cell: SearchScopeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! SearchScopeCollectionViewCell
            
            cell.backgoundSelectionView.layer.cornerRadius = 15
            cell.backgoundSelectionView.layer.masksToBounds = true
            cell.scopeNameLabel.text = searchScopeVariables[indexPath.row]
         
            
          return cell
            
        }
        else
        {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // let cell: SearchScopeCollectionViewCell = collectionView.cellForItem(at: indexPath) as! SearchScopeCollectionViewCell
       // cell.backgoundSelectionView.backgroundColor = .green
        self.searchScopeCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        if indexPath.item == 0
        {
          self.searchScopeTwo = "Tournament"
          self.tableHeader(title: SearchScopeVal.Tournament.rawValue, description: SearchScopeVal.Tournament.Description())
          self.serverTournamentData()
        }
        else if indexPath.item == 1
        {
            self.searchScopeTwo = "Ground"
             self.tableHeader(title: SearchScopeVal.Ground.rawValue, description: SearchScopeVal.Ground.Description())
            self.serverGroundData()
        }
        else if indexPath.item == 2
        {
            
            self.searchScopeTwo = "Team"
            self.tableHeader(title: SearchScopeVal.Team.rawValue, description: SearchScopeVal.Team.Description())
            self.serverTeamData()
            self.displayTableView.reloadData()
        }
        else if indexPath.item == 3
        {
            self.searchScopeTwo = "Players"
             self.tableHeader(title: SearchScopeVal.Players.rawValue, description: SearchScopeVal.Players.Description())
            self.serverPlayerData()
            self.displayTableView.reloadData()
        }
        
       print(indexPath.item)
    }
   
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchScopeTwo == "Tournament"
        {
            return self.filteredTournamentArray.count
        }
        else if self.searchScopeTwo == "Ground"
        {
            return self.filteredGroundArray.count
        }
        else if self.searchScopeTwo == "Team"
        {
            return self.filteredTeamArray.count
        }
        else if self.searchScopeTwo == "Players"
        {
            return self.filteredPlayerArray.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.searchScopeTwo == "Tournament"
        {
            let cell: TournamentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TournamentTableViewCell
            
            cell.backgroundColor = .clear
            cell.titleLabel.text = filteredTournamentArray[indexPath.row].name
            cell.locationLabel.text = filteredTournamentArray[indexPath.row].city
            cell.statusLabel.text = filteredTournamentArray[indexPath.row].status
            if filteredTournamentArray[indexPath.row].status.lowercased() == "finished"
            {
                cell.statusLabel.textColor = UIColor.red
            }
            else if filteredTournamentArray[indexPath.row].status.lowercased() == "ongoing"
            {
                cell.statusLabel.textColor = UIColor.green
            }
            else
            {
                 cell.statusLabel.textColor = UIColor.black
            }
            cell.sportTypelabel.text = filteredTournamentArray[indexPath.row].sport
            print(tournamentArray?.data[indexPath.row].city ?? "-")
            cell.logoImageView.setCustomImage(filteredTournamentArray[indexPath.row].logo)
            cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.size.width / 2
            cell.logoImageView.layer.masksToBounds = true
            return cell
        }
        if self.searchScopeTwo == "Ground"
        {
            let cell: GroundTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCellOne", for: indexPath) as! GroundTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.titleLabel.text = filteredGroundArray[indexPath.row].name
            cell.locationLabel.text = filteredGroundArray[indexPath.row].city
            cell.statusLabel.text = filteredGroundArray[indexPath.row].status
            cell.logoImageView.setCustomImage(filteredGroundArray[indexPath.row].image)
 
            return cell
        }
        if self.searchScopeTwo == "Team"
        {
            let cell: TeamTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCellTwo", for: indexPath) as! TeamTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.titleLabel.text = toFilteredTeamArray[indexPath.row].name
            cell.locationLabel.text = toFilteredTeamArray[indexPath.row].city
            cell.sportLabel.text = toFilteredTeamArray[indexPath.row].sport ?? "-"
            cell.logoImageView.setCustomImage(toFilteredTeamArray[indexPath.row].team_pic)
            
            return cell
        }
        if self.searchScopeTwo == "Players"
        {
            let cell: PlayerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCellThree", for: indexPath) as! PlayerTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.titleLabel.text = filteredPlayerArray[indexPath.row].name
            cell.locationLabel.text = filteredPlayerArray[indexPath.row].city
            cell.logoImageView.setCustomImage(filteredPlayerArray[indexPath.row].player_pic)
            
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchScopeTwo == "Ground"
        {
            let lastElement = filteredTournamentArray.count - 1
            if indexPath.row == lastElement && self.GroundPageNo <= self.lastPage {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                self.GroundPageNo += 1
                print(GroundPageNo)
                self.serverGroundData()
            }
        }
    }
        
}
extension ViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchScopeTwo == "Tournament"
        {
            self.filteredTournamentArray = self.toFilteredTournamentArray.matching(searchBar.text)
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == "Ground"
        {
            self.filteredGroundArray = self.toFilteredGroundArray.matchingGround(searchBar.text)
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == "Team"
        {
            self.filteredTeamArray = self.toFilteredTeamArray.matchingTeam(searchBar.text)
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == "Players"
        {
            self.filteredPlayerArray = self.toFilteredPlayerArray.matchingPlayer(searchBar.text)
            self.displayTableView.reloadData()
        }
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
      
        searchBar.showsCancelButton = true
        return true
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.searchBar.text?.removeAll()
        if self.searchScopeTwo == "Tournament"
        {
            self.filteredTournamentArray = self.toFilteredTournamentArray
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == "Ground"
        {
            self.filteredGroundArray = self.toFilteredGroundArray
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == "Team"
        {
            self.filteredTeamArray = self.toFilteredTeamArray
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == "Players"
        {
            self.filteredPlayerArray = self.toFilteredPlayerArray
            self.displayTableView.reloadData()
        }
    }
    
}

