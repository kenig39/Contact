

import UIKit
import Contacts



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var showIndexPathOnSide = false
  
    
    private var table: UITableView = {
        let table = UITableView()
        table.register(ContactCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    
    
    func someMethodToCallCell(cell: UITableViewCell){
        
        //
        guard let indexPathTaped = table.indexPath(for: cell) else {return}
        let contact = names[indexPathTaped.section].nameContact[indexPathTaped.row]
        var hasFavorited = contact.Favorite
        
        names[indexPathTaped.section].nameContact[indexPathTaped.row].Favorite = !hasFavorited
        
    //   table.reloadRows(at: [indexPathTaped], with: .fade)
        
        cell.accessoryView?.tintColor = hasFavorited ? .lightGray : .red
        
    }
    
    var names = [Expandable]()
    
    
//    var names = [
//        Expandable(isExpanded: true, nameContact: ["any" , "Bill", "sasha", "david", "igor", "gala"] .map{ FavotitedContact(name: $0, Favorite: false) }),
//        Expandable(isExpanded: true, nameContact: [FavotitedContact(name: "Tod", Favorite: true)]),
//    ]
//
    private func fetchContacts(){
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if let error = error {
                print("Faled to request", error)
                return
            }
            if granted {
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactJobTitleKey, CNContactMiddleNameKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    
                    var faviritableContact = [FavotitedContact]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointIfYouWantToStopEnumeratin) in
                        
                        print(contact.givenName)
                        
                        faviritableContact.append(FavotitedContact(contact: contact, Favorite: false))
                        
//                        faviritableContact.append(FavotitedContact(name: contact.givenName + "  " + contact.familyName, Favorite: false ))
//
                    })
                    
                    let namesContacts = Expandable(isExpanded: true, nameContact: faviritableContact)
                    self.names = [namesContacts]
                    
                } catch let error {
                    print("Faled enumerated contacts ", error)
                }
                
            } else {
                
            }
        }
    }
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()

        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Index Path", style: .plain, target: self, action: #selector(showIndexPath))
        
    }
    
    
    @objc func showIndexPath(){
        
        // Build all the IndexPath we want to reload
        var indexNames = [IndexPath]()
        
        for section in names.indices{
            for row in names[section].nameContact.indices{
                let indexPath = IndexPath(row: row, section: section)
                indexNames.append(indexPath)
            }
        }
//
//        for index in names[0].indices {
//            let indexPath = IndexPath(row: index, section: 0)
//            indexNames.append(indexPath)
//        }
//
       showIndexPathOnSide = !showIndexPathOnSide
        
        let animationStyle = showIndexPathOnSide ?
        UITableView.RowAnimation.right : .left
        
        table.reloadRows(at: indexNames, with: animationStyle)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handelOpenAndClose), for: .touchUpInside)
        
        button.tag = section
        
        return button
        
    }
    
    @objc func handelOpenAndClose(button: UIButton){
        
        let section = button.tag
        
        var indexPathToReload = [IndexPath]()
        
        
        for row in names[section].nameContact.indices{
         let indexPath = IndexPath(row: row, section: section)
                indexPathToReload.append(indexPath)
            
            }
        
        
            let isExpanded = names[section].isExpanded
            names[section].isExpanded = !isExpanded
        
        
        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
            
            if isExpanded {
                table.deleteRows(at: indexPathToReload, with: .fade)
            } else {
                table.insertRows(at: indexPathToReload, with: .fade)
            }
        }
        
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return names.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if !names[section].isExpanded {
            return 0
         }
         return names[section].nameContact.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactCell
//         cell.link = self
         
         let cell = ContactCell(style: .subtitle, reuseIdentifier: "Cell")
         
        
         let favoritableCont = names[indexPath.section].nameContact[indexPath.row]
         
         cell.accessoryView?.tintColor = favoritableCont.Favorite ? .blue : .green
                   
         cell.textLabel?.text = favoritableCont.contact.givenName + "  " + favoritableCont.contact.familyName
         cell.textLabel?.font = .boldSystemFont(ofSize: 15)
         
         cell.detailTextLabel?.text = favoritableCont.contact.phoneNumbers.first?.value.stringValue
         
         
       //  if showIndexPathOnSide {
//             cell.textLabel?.text = "\(favoritableCont.name)            Section\(indexPath.section)    Row:\(indexPath.row)"
//         }
//
            
        return cell
    }
    
}
