//
//  ImageListViewController.swift
//  Flickr
//
//  Created by murugan on 27/11/18.
//  Copyright © 2018 com.murugan.app. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController, UISearchBarDelegate {

    let kfAPI = APIRequestManager()
    let perPage = 15
    var pageNumber = 1
    var totalItems : Int = 0
    var searchString = "a"
    var isLoaded : Bool = false
    @IBOutlet var imageCollectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var viewNorecords: UIView!
    let indicator = UIActivityIndicatorView()
    var imageList : [PhotoListModel] = []
    {
        didSet{
            self.imageCollectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(viewNorecords)
        self.viewNorecords.isHidden = true
        self.setupActivityIndicator()
        self.loadImageList()
        // Do any additional setup after loading the view.
    }
    func setupActivityIndicator(){
        self.indicator.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.indicator.style = UIActivityIndicatorView.Style.whiteLarge
        self.indicator.color = UIColor.red
        self.indicator.center = view.center
        view.addSubview(indicator)
    }
    @objc func loadImageList(){
        if(searchString != ""){
            self.indicator.startAnimating()
            kfAPI.getDashboardList(url: "&per_page=\(perPage)&page=\(pageNumber)&text=\(searchString)", param: nil) { (success, imageModel) in
                if success
                {
                    self.totalItems = (imageModel?.photos?.pages)!
                    let items = (imageModel?.photos?.photo!)!
                    for item in items
                    {
                        self.imageList.append(item)
                    }
                    self.viewNorecords.isHidden = self.imageList.count>0 ? true:false
                }
                self.indicator.stopAnimating()
            }
        }else{
            self.pageNumber = 1
            self.imageList.removeAll()
            self.viewNorecords.isHidden = false
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString = searchText
        self.pageNumber = 1
        self.imageList.removeAll()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.loadImageList), object: nil)
        self.perform(#selector(self.loadImageList), with: nil, afterDelay: 0.4)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {}
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.searchString = searchBar.text!
        searchBar.resignFirstResponder()
    }
}

extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count>0 ? self.imageList.count: 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.imageList.count - 1 {
            if totalItems > (self.imageList.count){
                self.pageNumber = self.pageNumber + 1 // used pagination here
                self.loadImageList()
            }
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? imageCell else {
            fatalError("Error loading cell")
        }
        if self.imageList.count>0{
         cell.setObject(details: self.imageList[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: ((DeviceManager.deviceWidth/3)-10) , height: ((DeviceManager.deviceWidth/3)+20)) // 3 per row
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}


class imageCell: UICollectionViewCell{
    @IBOutlet var img: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    func setObject(details: PhotoListModel?){
        self.lblTitle.text = (details?.title)!
        let imageUrl = "http://farm\((details?.farm)!).static.flickr.com/\((details?.server)!)/\((details?.id)!)_\((details?.secret)!).jpg"
        self.img.gettingImageFromServer(urlString: imageUrl, defaultImage: "defaultImage")
    }
}



