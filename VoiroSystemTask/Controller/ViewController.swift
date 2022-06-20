//
//  ViewController.swift
//  VoiroSystemTask
//
//  Created by Senthil Kumar T on 20/06/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var cancelBttn: UIButton!
    @IBOutlet weak var cancelImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var movieListTableView: UITableView!
    
    let homeObject = WebService()
    var movieListResponse = [MovieResponseEntity]()
    var updatedArr = [MovieResponseEntity]()
    var isOnline = true
    var offlineDatas: [NSManagedObject] = [NSManagedObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
    }
    
    
    private func initialLoad() {
        self.movieListTableView.delegate = self
        self.movieListTableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Movies"
        self.searchTextField.placeholder = "Search by Name"
        self.searchView.layer.cornerRadius = 8
        self.movieListTableView.register(UINib(nibName: XibName.nibName.MovieListTableViewCell, bundle: nil), forCellReuseIdentifier: XibName.nibName.MovieListTableViewCell)
        self.searchTextField.addTarget(self, action: #selector(textFiledDidChange(_:)), for: .editingChanged)
        self.cancelBttn.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        self.cancelImage.isHidden = searchTextField.text == "" ? true:false
        self.cancelBttn.isHidden = searchTextField.text == "" ? true:false
        let checkNetwork = Reachability()
        self.isOnline = checkNetwork.isConnectedToNetwork()
        if self.isOnline  {
            self.callApi()
        }else {
            self.fetchDatas()
        }
        
        
    }
    
    
    //MARK:- API CALLING
    func callApi() {
        
        self.homeObject.getResponse(urlString: urlConstants.movieListApi, oncompletion: { (response) in
            print("response--->>",response)
            DispatchQueue.main.async{
                self.movieListResponse = response
                self.movieListTableView.reloadData()
                for responseData in self.movieListResponse {
                    self.dataSave(responseData)
                }
                
            }
            
        }){ (error) in
            print(error)
        }
        
    }
    
    @objc func textFiledDidChange(_ textFiled : UITextField){
        self.cancelImage.isHidden = searchTextField.text == "" ? true:false
        self.cancelBttn.isHidden = searchTextField.text == "" ? true:false
        let filteredArr = movieListResponse.filter({($0.title ?? "").uppercased().contains((searchTextField.text ?? "ni").uppercased())})
        self.updatedArr = filteredArr
        self.movieListTableView.reloadData()
    }
    
    @objc func cancelAction(_ sender:UIButton) {
        searchTextField.text = ""
        self.cancelImage.isHidden = searchTextField.text == "" ? true:false
        self.cancelBttn.isHidden = searchTextField.text == "" ? true:false
        self.movieListTableView.reloadData()
    }
    
}



extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isOnline {
            return searchTextField.text == "" ? movieListResponse.count : updatedArr.count
        }else{
            return offlineDatas.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XibName.nibName.MovieListTableViewCell, for: indexPath) as! MovieListTableViewCell
        self.searchTextField.tag = indexPath.row
        if self.isOnline {
            cell.movieNameLbl.text = searchTextField.text == "" ? self.movieListResponse[indexPath.row].title ?? "" : self.updatedArr[indexPath.row].title ?? ""
            
            cell.ratingLbl.text = searchTextField.text == "" ? "\(self.movieListResponse[indexPath.row].rating ?? 0.00)" : "\(self.updatedArr[indexPath.row].rating ?? 0.00)"
            
            cell.movieImageView.setImage(with: searchTextField.text == "" ? "\(self.movieListResponse[indexPath.row].image ?? "")" : "\(self.updatedArr[indexPath.row].image ?? "")", placeHolder: UIImage(named: "movie_placeholer"))
        }else {
            let datas = offlineDatas[indexPath.row]
            if let titleName = datas.value(forKeyPath: "tittle") as? String {
                cell.movieNameLbl?.text = titleName
                
            }
            if let ratings = datas.value(forKeyPath: "rating") as? String {
                cell.ratingLbl?.text = ratings
                
            }
            if let image = datas.value(forKeyPath: "image") as? String {
                cell.movieImageView.setImage(with: image, placeHolder: UIImage(named: "movie_placeholer"))
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerName.Identifier.MovieDetailsViewController) as! MovieDetailsViewController
        if self.isOnline {
            vc.tittle = searchTextField.text == "" ? self.movieListResponse[indexPath.row].title ?? "" : self.updatedArr[indexPath.row].title ?? ""
            vc.releaseDate = searchTextField.text == "" ? "\(self.movieListResponse[indexPath.row].releaseYear ?? 0)" : "\(self.updatedArr[indexPath.row].releaseYear ?? 0)"
            vc.rating = searchTextField.text == "" ? "\(self.movieListResponse[indexPath.row].rating ?? 0.00)" : "\(self.movieListResponse[indexPath.row].rating ?? 0.00)"
            
            let genreString = searchTextField.text == "" ? (self.movieListResponse[indexPath.row].genre ?? []).joined(separator: ",") : ((self.movieListResponse[indexPath.row].genre ?? []).joined(separator: ","))
            vc.genres = genreString
            vc.imageLink = searchTextField.text == "" ? self.movieListResponse[indexPath.row].image ?? "" : self.movieListResponse[indexPath.row].image ?? ""
        }else {
            let datas = offlineDatas[indexPath.row]
            if let titleName = datas.value(forKeyPath: "tittle") as? String {
                vc.tittle = titleName
            }
            if let ratings = datas.value(forKeyPath: "rating") as? String {
                vc.rating = ratings
            }
            if let image = datas.value(forKeyPath: "image") as? String {
                vc.imageLink = image
            }
            if let genre = datas.value(forKeyPath: "genres") as? String {
                vc.genres = genre
            }
            if let releaseDate = datas.value(forKeyPath: "releaseDate") as? String {
                vc.releaseDate = releaseDate
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//MARK:- SAVING DATA LOCALLY
extension ViewController{
    //MARK:- NSMANAGED OBJECT CONTEXT
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return  appDelegate.persistentContainer.viewContext
    }
    
    //MARK:-TRANSACTION DETAILS
    func dataSave(_ response:MovieResponseEntity?) {
        
        
        let managedContext = getContext()
        let entity =
        NSEntityDescription.entity(forEntityName: "MovieDetails",
                                   in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(response?.title, forKey: "tittle")
        person.setValue("\(response?.rating ?? 0.00)", forKey: "rating")
        person.setValue("\(response?.releaseYear ?? 0)", forKey: "releaseDate")
        person.setValue(response?.image, forKey: "image")
        person.setValue(response?.genre?.joined(separator: ","), forKey: "genres")
        
        do {
            try managedContext.save()
            
            print("save")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK:- FETCHING DATA
    func fetchDatas () {
        let managedObjectContext = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> ( entityName: "MovieDetails")
        do {
            offlineDatas = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            movieListTableView.reloadData()
            
        } catch  let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}
