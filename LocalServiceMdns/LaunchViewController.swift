//
//  ViewController.swift
//  LocalServiceMdns
//
//  Created by Dilyana Yankova on 21.10.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NetServiceBrowserDelegate {
    
    let myBonjourServiceBrowser = NetServiceBrowser()
    var services: [NetService] = []
    let serviceQuery = "_services._dns-sd._udp."
    var domain: String = "local."
    let myBonjourDomainBrowser = NetServiceBrowser()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
        private lazy var titleLable : UILabel = {
        let lbl = UILabel()
        lbl.text = "Click on an item for more information :)"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addConstraints()
        
        myBonjourServiceBrowser.delegate = self
        myBonjourServiceBrowser.searchForServices(ofType: serviceQuery, inDomain: domain)
    }
   
   private func addConstraints() {
          titleLable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
          titleLable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
          titleLable.heightAnchor.constraint(equalToConstant: 50).isActive = true
          titleLable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
          
          collectionView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 20).isActive = true
          collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
          collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
          collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
      }

      private func setupViews() {
          view.addSubview(collectionView)
          view.addSubview(titleLable)
          view.backgroundColor = .white
          
          collectionView.backgroundColor = .clear
          collectionView.dataSource = self
          collectionView.delegate = self
          collectionView.register(DeviceCell.self, forCellWithReuseIdentifier: "DeviceCell")
          collectionView.reloadData()
      }
    
    override func viewDidDisappear(_ animated: Bool) {
        myBonjourDomainBrowser.stop()
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
        cell.nameLabel.text = selectedService.name + "" + selectedService.type
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewControler: DetailsViewController = DetailsViewController()
        detailsViewControler.name = services[indexPath.row].name
        detailsViewControler.type = services[indexPath.row].type
        detailsViewControler.modalPresentationStyle = .fullScreen
        self.present(detailsViewControler, animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
         myBonjourServiceBrowser.stop()
    }
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("Starting to search services in BonjourServiceTableViewController")
    }
         
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Did not search for services")
    }
         
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
         let newIndexPath = IndexPath(row: services.count, section: 0)
         services += [service]
         print("Found service Name = \(service.name)\n\tDescription = \(service.description)\n")
     
         collectionView.insertItems(at: [newIndexPath])
     }
         
     func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
         // The search has stopped for the current search.  If we have more searches to perform then start them.
         print("Got Service Search stop in BonjourServiceTableViewController")
     }

}
