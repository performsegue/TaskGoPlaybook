//
//  ViewController.swift
//  TaskGoPlayBook
//
//  Created by Bharath  Raj kumar on 21/02/19.
//  Copyright © 2019 Bharath Raj Kumar. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    //@IBOutlet weak var searchBar: UISearchBar!
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
    var searchScope = SearchScopeVal.Tournament
    var searchScopeTwo = SearchScopeVal.Tournament.rawValue
    var city = ""
    var GroundPageNo = 1
    var lastPage = 1
    var tournamentPageNo = 1
    var tournamentLastPage = 1
    var teamPageNo = 1
    var teamLastPage = 1
    var playerPageNo = 1
    var playerLastPage = 1
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchScopeCollectionView.delegate = self
        searchScopeCollectionView.dataSource = self
        //to select the tournament search scope by default
        let indexPath = IndexPath.init(item: 0, section: 0)
        searchScopeCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        displayTableView.delegate = self
        displayTableView.dataSource = self
        // Request Location permissions
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
       
       
        
        
        self.searchScopeCollectionView.register(UINib(nibName: "SearchScopeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
        self.displayTableView.register(UINib(nibName: "TournamentTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        self.displayTableView.register(UINib(nibName: "GroundTableViewCell", bundle: nil), forCellReuseIdentifier: "customCellOne")
        self.displayTableView.register(UINib(nibName: "TeamTableViewCell", bundle: nil), forCellReuseIdentifier: "customCellTwo")
        self.displayTableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "customCellThree")
        
        // Setting the delegates
       
        //adding the searchBar
        searchBar.placeholder = "Start Searching"
        searchBar.tintColor = .white
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        self.tableHeader(title: SearchScopeVal.Tournament.rawValue, description: SearchScopeVal.Tournament.Description())
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchBarCenterInit()
    }
    
    
    func addSearchBar()
    {
        
    }
    
    // Get the latitude and Longitude of User
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude), \(locValue.longitude)")
       getAddressFromLatLon(pdblLatitude: "\(locValue.latitude)", withLongitude: "\(locValue.longitude)")
    }
    
    
    //Reverse Geocoding the lat and Log to get the area (Test with location of Indira Gandhi Internation Airport)
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
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
                    print(pm.administrativeArea ?? "")
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
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " | "
                    }
                    
                    
                    if pm.administrativeArea != nil {
                        addressString = addressString + pm.locality! + ". "
                        self.LocationDisplayLabel.text = pm.administrativeArea ?? "nil"
                        self.city = "\(pm.administrativeArea ?? "")"
                    
                          self.serverTournamentData()
                        
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
        
        print("Tournament Page: \(tournamentPageNo)")
        let baseUrl = "http://52.66.194.65/api/search/v1/globalsearch/?arg=tournament&city=\(city)&query=&page=\(tournamentPageNo)"
        
       
        if tournamentPageNo == 1
        {
            self.tournamentArray = nil
            self.filteredTournamentArray.removeAll()
        }
        
        if self.tournamentPageNo <= self.tournamentLastPage
        {
            Service.shared.fetchContacts(TournamentData.self, urlString: baseUrl, completion: {
                (downloadedData, err) in
                
                self.tournamentArray = downloadedData
                self.tournamentLastPage = downloadedData?.last_page ?? 1
                print("Last Page \(self.tournamentLastPage)")
                
                if self.tournamentPageNo <= downloadedData?.last_page ?? 1
                {
                    for value in downloadedData?.data ?? []
                    {
                        self.filteredTournamentArray.append(value)
                    }
                    self.toFilteredTournamentArray = self.filteredTournamentArray
                    
                }
                self.displayTableView.reloadData()
                print("Count: \(self.toFilteredTournamentArray.count)")
            })
            
        }
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
        if self.GroundPageNo <= self.lastPage
        {
            Service.shared.fetchContacts(GroundData.self, urlString: baseUrl, completion: {
                (downloadedData, err) in
                
               self.groundArray = downloadedData
                self.lastPage = downloadedData?.last_page ?? 1
                print("Last Page \(self.lastPage)")
                
                if self.GroundPageNo <= downloadedData?.last_page ?? 1
                {
                    for value in downloadedData?.data ?? []
                    {
                        // print(value)
                        self.filteredGroundArray.append(value)
                        
                    }
                self.toFilteredGroundArray = self.filteredGroundArray
                }
                print("Count: \(self.toFilteredGroundArray.count)")
                self.displayTableView.reloadData()
            })
        }
    }
    
    func serverTeamData()
    {
        
        
        let baseUrl = "http://52.66.194.65/api/search/v1/globalsearch/?arg=team&city=\(city)&query=&page=\(teamPageNo)"
        if teamPageNo == 1
        {
            self.TeamArray = nil
            self.toFilteredTeamArray.removeAll()
        }
    
        if self.teamPageNo <= self.teamLastPage
        {
            Service.shared.fetchContacts(TeamData.self, urlString: baseUrl, completion: {
                (downloadedData, err) in
                
                self.TeamArray = downloadedData
                self.teamLastPage = downloadedData?.last_page ?? 1
                print("Last Page \(self.teamLastPage)")
                
                if self.teamPageNo <= downloadedData?.last_page ?? 1
                {
                    for value in downloadedData?.data ?? []
                    {
                        // print(value)
                        self.filteredTeamArray.append(value)
                        
                    }
                    self.toFilteredTeamArray = self.filteredTeamArray
                }
                print("Count: \(self.filteredTeamArray.count)")
                self.displayTableView.reloadData()
            })
        }
            
    }
    
    func serverPlayerData()
    {
        print(playerPageNo)
        
        let baseUrl = "http://52.66.194.65/api/search/v1/globalsearch/?arg=player&city=\(city)&query=&page=\(playerPageNo)"
        if playerPageNo == 1
        {
            self.TeamArray = nil
            self.toFilteredTeamArray.removeAll()
        }

        print(groundArray?.last_page as Any)
        if self.playerPageNo <= self.playerLastPage
        {
            Service.shared.fetchContacts(PlayerData.self, urlString: baseUrl, completion: {
                (downloadedData, err) in
                
                self.playerArray = downloadedData
                self.playerLastPage = downloadedData?.last_page ?? 1
                print("Last Page \(self.playerLastPage)")
                
                if self.playerPageNo <= downloadedData?.last_page ?? 1
                {
                    for value in downloadedData?.data ?? []
                    {
                        // print(value)
                        self.filteredPlayerArray.append(value)
                        
                    }
                    self.toFilteredPlayerArray = self.filteredPlayerArray
                }
                print("Count: \(self.filteredPlayerArray.count)")
                self.displayTableView.reloadData()
            })
        }
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
        self.searchScopeCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        if indexPath.item == 0
        {
          self.searchScopeTwo = SearchScopeVal.Tournament.rawValue
          self.tableHeader(title: SearchScopeVal.Tournament.rawValue, description: SearchScopeVal.Tournament.Description())
            self.tournamentPageNo = 1
            self.filteredTournamentArray.removeAll()
            self.tournamentArray = nil
            self.toFilteredTournamentArray.removeAll()
            self.serverTournamentData()
        }
        else if indexPath.item == 1
        {
            self.searchScopeTwo = SearchScopeVal.Ground.rawValue
             self.tableHeader(title: SearchScopeVal.Ground.rawValue, description: SearchScopeVal.Ground.Description())
                self.GroundPageNo = 1
                self.filteredGroundArray.removeAll()
                self.groundArray = nil
                self.toFilteredGroundArray.removeAll()
                self.serverGroundData()
        }
        else if indexPath.item == 2
        {
            
            self.searchScopeTwo = SearchScopeVal.Team.rawValue
            self.tableHeader(title: SearchScopeVal.Team.rawValue, description: SearchScopeVal.Team.Description())
            self.teamPageNo = 1
            self.filteredTeamArray.removeAll()
            self.TeamArray = nil
            self.toFilteredTeamArray.removeAll()
            self.serverTeamData()
            self.displayTableView.reloadData()
        }
        else if indexPath.item == 3
        {
            self.searchScopeTwo = SearchScopeVal.Players.rawValue
             self.tableHeader(title: SearchScopeVal.Players.rawValue, description: SearchScopeVal.Players.Description())
            self.playerPageNo = 1
            self.filteredPlayerArray.removeAll()
            self.playerArray = nil
            self.toFilteredPlayerArray.removeAll()
            self.serverPlayerData()
            self.displayTableView.reloadData()
        }
        
       print(indexPath.item)
    }
   
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchScopeTwo == SearchScopeVal.Tournament.rawValue
        {
            print("row count : \(self.filteredTournamentArray.count)")
            return self.filteredTournamentArray.count
        }
        else if self.searchScopeTwo == SearchScopeVal.Ground.rawValue
        {
            return self.filteredGroundArray.count
        }
        else if self.searchScopeTwo == SearchScopeVal.Team.rawValue
        {
            return self.filteredTeamArray.count
        }
        else if self.searchScopeTwo == SearchScopeVal.Players.rawValue
        {
            return self.filteredPlayerArray.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.searchScopeTwo == SearchScopeVal.Tournament.rawValue
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
            cell.logoImageView.setCustomImage(filteredTournamentArray[indexPath.row].logo)
            cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.size.width / 2
            cell.logoImageView.layer.masksToBounds = true
            return cell
        }
        if self.searchScopeTwo == SearchScopeVal.Ground.rawValue
        {
            let cell: GroundTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCellOne", for: indexPath) as! GroundTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.titleLabel.text = filteredGroundArray[indexPath.row].name
            cell.locationLabel.text = filteredGroundArray[indexPath.row].city
            cell.statusLabel.text = filteredGroundArray[indexPath.row].status
            cell.logoImageView.setCustomImage(filteredGroundArray[indexPath.row].image)
            cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.size.width / 2
            cell.logoImageView.layer.masksToBounds = true
 
            return cell
        }
        if self.searchScopeTwo == SearchScopeVal.Team.rawValue
        {
            let cell: TeamTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCellTwo", for: indexPath) as! TeamTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.titleLabel.text = filteredTeamArray[indexPath.row].name
            cell.locationLabel.text = filteredTeamArray[indexPath.row].city
            cell.sportLabel.text = filteredTeamArray[indexPath.row].sport ?? "-"
            cell.logoImageView.setCustomImage(filteredTeamArray[indexPath.row].team_pic)
            cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.size.width / 2
            cell.logoImageView.layer.masksToBounds = true
            return cell
        }
        if self.searchScopeTwo == SearchScopeVal.Players.rawValue
        {
            let cell: PlayerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCellThree", for: indexPath) as! PlayerTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.titleLabel.text = filteredPlayerArray[indexPath.row].name
            cell.locationLabel.text = filteredPlayerArray[indexPath.row].city
            cell.logoImageView.setCustomImage(filteredPlayerArray[indexPath.row].player_pic)
            cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.size.width / 2
            cell.logoImageView.layer.masksToBounds = true
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
        if searchScopeTwo == SearchScopeVal.Tournament.rawValue
        {
            let lastElement = filteredTournamentArray.count - 1
            if indexPath.row == lastElement && self.tournamentPageNo <= self.tournamentLastPage {
                self.tournamentPageNo += 1
                print(tournamentPageNo)
                self.serverTournamentData()
            }
        }
        if searchScopeTwo == SearchScopeVal.Ground.rawValue
        {
            let lastElement = toFilteredGroundArray.count - 1
            if indexPath.row == lastElement && self.GroundPageNo <= self.lastPage {
                self.GroundPageNo += 1
                print(GroundPageNo)
                self.serverGroundData()
            }
        }
        if searchScopeTwo == SearchScopeVal.Team.rawValue
        {
            let lastElement = toFilteredTeamArray.count - 1
            if indexPath.row == lastElement && self.teamPageNo <= self.teamLastPage {
                self.teamPageNo += 1
                print(teamPageNo)
                self.serverTeamData()
            }
        }
        if searchScopeTwo == SearchScopeVal.Players.rawValue
        {
            let lastElement = toFilteredPlayerArray.count - 1
            if indexPath.row == lastElement && self.playerPageNo <= self.playerLastPage {
                self.playerPageNo += 1
                print(playerPageNo)
                self.serverPlayerData()
            }
        }
    }
        
}
extension ViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchScopeTwo == SearchScopeVal.Tournament.rawValue
        {
            self.filteredTournamentArray = self.toFilteredTournamentArray.matching(searchBar.text)
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == SearchScopeVal.Ground.rawValue
        {
            self.filteredGroundArray = self.toFilteredGroundArray.matchingGround(searchBar.text)
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == SearchScopeVal.Team.rawValue
        {
            self.filteredTeamArray = self.toFilteredTeamArray.matchingTeam(searchBar.text)
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == SearchScopeVal.Players.rawValue
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
        if self.searchScopeTwo == SearchScopeVal.Tournament.rawValue
        {
            self.filteredTournamentArray = self.toFilteredTournamentArray
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == SearchScopeVal.Ground.rawValue
        {
            self.filteredGroundArray = self.toFilteredGroundArray
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == SearchScopeVal.Team.rawValue
        {
            self.toFilteredTeamArray = self.filteredTeamArray
            self.displayTableView.reloadData()
        }
        if self.searchScopeTwo == SearchScopeVal.Players.rawValue
        {
            self.filteredPlayerArray = self.toFilteredPlayerArray
            self.displayTableView.reloadData()
        }
    }
    
}

