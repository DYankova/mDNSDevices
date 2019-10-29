//
//  DetailsViewController.swift
//  LocalServiceMdns
//
//  Created by Dilyana Yankova on 21.10.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, NetServiceBrowserDelegate {
    
    var domain: String = ""
    var serviceName: String = ""
    var serviceType: String = ""
    var browseForService: String = ""
    var services: [NetService] = []
    let myBonjourServiceBrowser = NetServiceBrowser()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    let navBar = UINavigationBar(frame: CGRect(x: 20, y: 50, width: 120, height: 50))
    let navItem = UINavigationItem(title: "Back")
    let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.rewind, target: nil, action: #selector(close))
    
    var name: String = ""
    var type: String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupViews()
        addConstraints()
        
        browseForService  = name + "." + type[...(type.index(of: ".")!)]
        print("Search for providers of service - \(browseForService)")
        myBonjourServiceBrowser.delegate = self
        myBonjourServiceBrowser.searchForServices(ofType: browseForService, inDomain: domain)
    }
    
    private func addConstraints() {
       collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
       collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
       collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
   }
       
   private func setupViews() {
       view.addSubview(navBar)
       view.addSubview(collectionView)
       navItem.rightBarButtonItem = doneItem
       navBar.setItems([navItem], animated: false)
       
       view.backgroundColor = .white
       
       collectionView.backgroundColor = .clear
       collectionView.dataSource = self
       collectionView.delegate = self
       collectionView.register(DeviceCell.self, forCellWithReuseIdentifier: "DeviceCell")
       collectionView.reloadData()
   }
    
    @objc func close(button : UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        myBonjourServiceBrowser.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        let selectedService = services[indexPath.row]
        
        cell.nameLabel.text = selectedService.name + " " + selectedService.type
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        myBonjourServiceBrowser.stop()
    }
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("Starting to search services in DiscoveredServicesTableViewControler")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Did not search for service in DiscoveredServicesTableViewController")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        
        let newIndexPath = IndexPath(row: services.count, section: 0)
        services += [service]
        print("Found provider - \(service.name)")
        collectionView.insertItems(at: [newIndexPath])
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("Got service browse stop in DiscoveredServicesTableViewController")
    }
 
}
