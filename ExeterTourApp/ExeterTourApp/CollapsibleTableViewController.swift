//
//  CollapsibleTableViewController.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

//
// MARK: - Section Data Structure
//
struct Section {
    var name: String!
    var items: [loc]!
    var collapsed: Bool!
    
    init(name: String, items: [loc], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
    mutating func addItem(item:loc){
        items.append(item)
    }
}

//
// MARK: - View Controller
//
class CollapsibleTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating  {
    
    var sections = [Section]()
    var searched_sections = [Section]()
    
    var searchController = UISearchController(searchResultsController: nil)

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !searchController.searchBar.showsCancelButton {
            return ;
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            self.tableView.reloadData()
        }
    }
    
    func filterContent(for searchText: String){
        searched_sections = []
        for section in sections{
            var current_section:Section = Section(name: section.name,items: [])
            for item in section.items{
                if item.name.localizedCaseInsensitiveContains(searchText){
                    current_section.addItem(item: item)
                }
            }
            if current_section.items.count > 0{
                searched_sections.append(current_section)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = "PEA Buildings"
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:0.64, green:0.12, blue:0.20, alpha:1.0)]
        
        // Initialize the sections array
        // Here we have three sections: Mac, iPad, iPhone
        sections = [
            Section(name: "Academic Buildings", items: [loc(name: "Academy Building",latitude: 42.9811003,longitude: -70.9539292,photo: ["hi","hi"],explain: "explanation dummy"), loc(name: "Phelphs Science Center",latitude: 42.9801363,longitude: -70.9545467,photo: ["hi","hi"],explain: "explanation dummy"), loc(name:"Dummy", latitude: 37.5269341,longitude: 127.0509413, photo: ["lion","goicon","dummy"], explain: "dummy explanation")]),
            Section(name: "Student Life", items: []),
            Section(name: "Athletics", items: []),
            Section(name: "Admissions and Administration", items: []),
            Section(name: "Dormitories", items: []),
            Section(name: "Parking", items: [])
        ]
    }
    
}

//
// MARK: - View Controller DataSource and Delegate
//
extension CollapsibleTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.searchController.isActive) ? self.searched_sections.count : self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.searchController.isActive) ? self.searched_sections[section].items.count : self.sections[section].items.count//sections[section].items.count
    }
    
    // Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item:String = (searchController.isActive) ? searched_sections[indexPath.section].items[indexPath.row].name : self.sections[indexPath.section].items[indexPath.row].name
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "cell")//tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = item//sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row]
        cell.accessoryType = UITableViewCellAccessoryType.detailButton
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[(indexPath as NSIndexPath).section].collapsed! ? 0 : 44.0
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //hi
        self.searchController.dismiss(animated: true, completion: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "info") as! InfoVC
        vc.currentlocation = self.sections[indexPath.section].items[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let map:MapViewController = MapViewController()
        map.selectedLocation = self.sections[indexPath.section].items[indexPath.row]
        self.navigationController?.pushViewController(map, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

}

//
// MARK: - Section Header Delegate
//
extension CollapsibleTableViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        // Adjust the height of the rows inside the section
        tableView.beginUpdates()
        for i in 0 ..< sections[section].items.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
}
