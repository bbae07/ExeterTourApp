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
            Section(name: "Academic Buildings", items: [loc(name: "Academy Building",latitude: 42.9811003,longitude: -70.9539292,photo: ["hi","hi"],explain: "It hosts classrooms for mathematics, history, philosophy, religion, classical languages and anthropology. \n The entire student body meets in the building's Assembly Hall twice each week for all-school programs. Recent presenters include author and journalist Nicolas Kristof, economist Gregory Mankiw, singer Rhiannon Giddens, and Natasha Trethewey, 19th Poet Laureate of the United States. \n In the evenings, Assembly Hall becomes a venue for speakers, performers and concerts, some of which are open to the public."), loc(name: "Phelphs Science Center",latitude: 42.9801363,longitude: -70.9545467,photo: ["hi","hi"],explain: "The Phelps Science Center provides classroom and lab space for courses in biology, physics, chemistry, astronomy, computer science, robotics and more. \n The center features 20 Harkness classroom/labs, four common labs, a marine biology table, a 900-gallon tropical aquarium, a teaching garden and outdoor classroom, the 300-seat Grainger Auditorium, the Peter Durham '85 Computer Science Lab, and a humpback whale skeleton."), loc(name:"Forrestal-Bowld Music Building", latitude: 42.979462,longitude: -70.951991, photo: ["lion","goicon","dummy"], explain: "Designed to support classroom learning, practice and performance, the Forrestal-Bowld Music Building has 24 practice rooms, two media/technology suites, four teaching/ensemble rooms, three rehearsal halls, one recital hall, a recording/mixing lab, and a music library."),loc(name:"Fisher Theater",latitude: 42.979250,longitude: -70.952860,photo:["hi","hi"],explain:"View performances in the flexible main stage venue or the 100-seat black box theater. Fisher Theater also includes areas for classes, makeup, costume design, lighting and scene building."),loc(name:"Frederick R. Mayer Art Center",latitude:42.980058,longitude:-70.951637,photo:["hi","hi"],explain:"The Mayer Art Center is home to the Lamont Gallery and provides facilities for painting, drawing, photography, ceramics, printmaking, design and other visual media."),loc(name:"Lamont Gallery",latitude:42.98005,longitude:-70.95163,photo:["hi","hi"],explain:"Located in the Frederick R. Mayer Art Center, the Lamont Gallery is an active exhibition and teaching space. Through its rotating installations and programs, the gallery helps visitors deepen their appreciation of the visual arts."), loc(name:"Phillips Hall",latitude:42.980851,longitude:-70.951036,photo:["hi","hi"],explain:"Named for the school’s founders, Phillips Hall is home to the English and Modern Language departments. Recently renovated, Phillips Hall classrooms have modern AV equipment and new Harkness tables and study spaces"),loc(name:"David Center",latitude:42.979120,longitude:-70.948915,photo:["hi","hi"],explain:"The Davis Center houses the dance studio and the Office of Financial Aid. \n The 1,700-square-foot studio, with generous natural light, sound system and sprung floor, offers a large studio for dance courses and dance company."), loc(name:"Goel Center for Theater and Dance",latitude:42.977229,longitude: -70.948161,photo:["hi","hi"],explain:"(Currently under construction.) \n The David E. Goel & Stacey L. Goel Center for Theater and Dance will become the Academy’s main venue for the performing arts. The new facility will feature two theater stages and two dance studios, along with technical studios and classroom space. Once opened, the center will also provide Exeter with a scene shop, costume studio and technical galleries -- spaces for creative exploration and artistic expression."), loc(name:"Grainger Observatory",latitude:42.979901,longitude: -70.941906,photo:["hi","hi"],explain:"The Phillips Exeter Academy Grainger Observatory is a state-of-the-art facility for astronomical research. \n The facility includes three domed observatories and a classroom building (The Chart House) that contains an astronomy-specific library and numerous instruments to assist students with research."), loc(name:"Class of 1945 Library",latitude:42.978834,longitude:-70.949405,photo:["hi","hi"],explain:"Completed in 1971 by renowned architect Louis I. Kahn, the Class of 1945 Library is as unique on the outside as it is within. With more than 200 study carrels, two seminar rooms, a ground-level common area, and numerous reading lounges and discussion tables, the library is well-equipped for group collaboration and personal study sessions. \n The library contains nearly 300,000 volumes, thousands of digital resources, and the Academy archives, which contain records from Phillips Exeter's founders, trustees, faculty and students.")]),
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
