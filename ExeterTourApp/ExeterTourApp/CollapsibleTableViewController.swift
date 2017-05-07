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
            Section(name: "Student Life", items: [loc(name: "Elm Street Dining Hall",latitude: 42.9788262,longitude: -70.9488048,photo: ["hi","hi"],explain: "Renovated in 2014 and designed by Louis I. Kahn, Elm Street Dining hall has a diverse array of offerings include hot-food options, salad bar, sandwich bar, pasta bar, soup, and cereals as well as vegan, gluten-free and other foods to meet specific dietary needs, be they religious or medical.  There are efforts to keep foods local whenever possible. Dining Hall is a place where the Exeter community comes together: students, faculty and staff. It's open throughout the day for quick snacks."),loc(name: "Wetherell Dining Hall",latitude:42.981228 ,longitude: -70.950189,photo: ["hi","hi"],explain: "Wetherell serves as one of two main buffet-style dining halls on campus."),loc(name: "Exeter Bookstore",latitude: 42.980805,longitude: -70.9490064,photo: ["hi","hi"],explain: "The Phillips Exeter Academy bookstore provides books, textbooks, apparel and gifts for PEA students and the community.  Shop the bookstore online at www.exeter.edu/bookstore."),loc(name: "Lamont Health and Wellness Center",latitude: 42.980102,longitude: -70.952828,photo: ["hi","hi"],explain: "Renovations completed in 2013, devoted to supporting students and their well being.  The Health Center is open 24/7 with a nurse on duty, 3 psychologists on staff, a physician on-call, and a registered dietitian.  14 beds are available throughout the day and night for medical care.  In cases of emergency, Exeter Hospital is 5 minutes off campu.  The health center staff coordinate and provide transportation to off-campus appointments and work closely with our Athletic Trainers. \n\nA mandatory health class for 9th and 10th graders addresses adolescent health issues.  There is also a required, one term, course for all seniors that addresses health and wellness issues encountered in college."),loc(name: "Phelps Academy Center",latitude: 42.980535,longitude: -70.951897,photo: ["hi","hi"],explain: "The Phelps Academy Center is a hub of student life. It's home to Grill (a café and convenience store), the post office, student organizations and club offices, the school newspaper, radio station and yearbook office. There are plenty of multi-purpose spaces in the building, too, including a game room, a TV room, a student kitchen, the day student lounge and more."),loc(name: "Phillips Church",latitude: 42.979078,longitude: -70.951648,photo: ["hi","hi"],explain: "A multi-denominational space to support the faiths of our community members, overseen by Interim Campus Minister, Reverend Heidilee Heath. \n\nPhillips Church serves as a worship space for many different faiths throughout the week and is home to a diverse array of religious organizations.  This is a safe space to learn more about your own faith and those of other community members.  Yoga studio and Buddhist meditation space upstairs; kitchen and lounge below create community.  The chapel is home to Meditation: an opportunity for adult community members to share a meaningful experience.  All students write meditations in their senior English classes and a small number of seniors are selected to read their Meditations in the Spring.")]),
            Section(name: "Athletics", items: [loc(name: "Amos Alonzo Stagg Baseball Diamond",latitude: 42.975578,longitude: -70.945943,photo: ["hi","hi"],explain: "Used for varsity baseball, the field is situated between the tennis courts and Lovshin Track. The JV baseball diamond is located directly across the field."),loc(name: "Thompson Gym",latitude: 42.976094,longitude: -70.948236,photo: ["hi","hi"],explain: "Thompson Gym houses a basketball court and the Downer Family Fitness Center. It's connected to Love Gym."),loc(name: "Love Gym",latitude: 42.975682,longitude: -70.948585,photo: ["hi","hi"],explain: "The George H. Love Gymnasium serves as the main athletic facility in combination with the adjoining Thompson Gym. \n\nTogether, the connected buildings house two indoor hockey rinks, 14 squash courts, two indoor swimming pools, five basketball courts, locker rooms, and a fully equipped training room and fitness center."),loc(name: "Outdoor Tennis Courts",latitude: 42.976481,longitude: -70.947214,photo: ["hi","hi"],explain: "An outdoor facility that features 14 all-weather tennis courts."),loc(name: "Lovshin Track, Soccer Field",latitude: 42.975363,longitude: -70.944827,photo: ["hi","hi"],explain: "The Ralph Lovshin Track is an all-weather, eight-lane, 400-meter track with three long jump pits and areas for shot put, discus, javelin, high jump and pole vault. Exeter's main grass soccer pitch is located on the track infield."),loc(name: "Softball Diamond",latitude: 42.976159,longitude: -70.943963,photo: ["hi","hi"],explain: "Used for both varsity and JV softball, this field is situated next to Lovshin Track."),loc(name: "Phelps Stadium",latitude: 42.976348,longitude: -70.9406948,photo: ["hi","hi"],explain: "Phelps Stadium's turf field hosts football, lacrosse, soccer and field hockey games."),loc(name: "Hatch Field",latitude: 42.975877,longitude: -70.9396434,photo: ["hi","hi"],explain: "The newly constructed Norman Hatch Field has a multi-purpose turf surface and serves Exeter's field hockey and lacrosse teams."),loc(name: "Saltonstall Boathouse",latitude: 42.982501,longitude: -70.949167,photo: ["hi","hi"],explain: "Saltonstall Boathouse is home to PEA’s boys and girls crew teams. Its dock sits on the Squamscott River where PEA teams practice. The boathouse itself holds 20+ eight-oared shells and has locker room space for more than 100 rowers.")]),
            Section(name: "Admissions and Administration", items: [
                loc(name: "HARRIS FAMILY CHILDREN'S CENTER",latitude: 42.9809969,longitude: -70.9533048,photo: [],explain: "The Harris Family Children's Center offers child care for Exeter employees and families in the local community with classes for infants and toddlers, preschool and kindergarten programs and after-school care options."),
                loc(name: "ITS DATA CENTER",latitude: 42.9809969,longitude: -70.9533048,photo: [],explain: "Home of the Office of Information Technology Services."),
                loc(name: "EXETER SUMMER",latitude: 42.9811183,longitude: -70.9524853,photo: [],explain: "This is the administrative home of Exeter Summer, PEA's five-week summer study program."),
                loc(name: "VEAZEY HOUSE",latitude: 42.9811183,longitude: -70.9524853,photo: [],explain: "Home of the Communications Office."),
                loc(name: "JEREMIAH SMITH HALL",latitude: 42.9811183,longitude: -70.9524853,photo: [],explain: "This is Exeter's main administration building. Here you’ll find the Principal’s Office, Dean of Students Office, Dean of Faculty Office, Office of Multicultural Student Affairs, Human Resources and the Finance Office."),
                loc(name: "ADMISSIONS: BISSELL HOUSE",latitude: 42.9811183,longitude: -70.9489832,photo: [],explain: "If you"+"'"+"re applying to Exeter, this is your first stop on campus. You"+"'"+"ll have your admissions interview here and all student-led tours depart from Bissell House, too. There are a couple parking spots in the lot behind Bissell House or you can easily find nearby street parking on Front Street."),
                loc(name: "NATHANIEL GILMAN HOUSE",latitude: 42.9811183,longitude: -70.9489832,photo: [],explain: "Home to the Office of Institutional Advancement."),
                loc(name: "40 FRONT STREET (GILMAN EAST, SS)",latitude: 42.9811183,longitude: -70.9489832,photo: [],explain: "Houses the Office of Major Gifts, which is part of Institutional Advancement."),
                ]),
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
