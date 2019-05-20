//
//  MainView.swift
//  Checklist
//
//  Created by Celiña Hiyas Javier on 17/05/2019.
//  Copyright © 2019 Celiña Hiyas Javier. All rights reserved.
//

import UIKit
import SnapKit

public final class MainView: UIView {

    // MARK: - Subviews
    public let tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        view.backgroundColor = UIColor.white
        view.showsVerticalScrollIndicator = true
        view.allowsSelection = false
        view.estimatedRowHeight = 100.0
        view.rowHeight = UITableView.automaticDimension
        view.separatorColor = UIColor.clear
        return view
    }()
    
    // MARK: - Stored Properties
    private var sectionInfoList: [SectionInfo] = [SectionInfo]()
    
    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.subviews(forAutoLayout: [self.tableView])
        
        self.tableView.register(
            ItemWithTextInputCell.self,
            forCellReuseIdentifier: ItemWithTextInputCell.identifier)
        
       self.tableView.register(
            ChecklistItemHeaderView.self,
            forHeaderFooterViewReuseIdentifier: ChecklistItemHeaderView.identifier)
        
        self.tableView.snp.remakeConstraints { (make: ConstraintMaker) in
            make.top.equalTo(safeAreaLayoutGuide.snp.topMargin)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Sample Data
        let sectionInfoA: SectionInfo = SectionInfo(section: 0, title: "Section 0", items: ["A", "B", "C"])
        let sectionInfoB: SectionInfo = SectionInfo(section: 1, title: "Section 1", items: ["A", "B", "C"])
        let sectionInfoC: SectionInfo = SectionInfo(section: 2, title: "Section 2", items: ["A", "B", "C"])
        sectionInfoList = [sectionInfoA, sectionInfoB, sectionInfoC]
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionInfoList.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.sectionInfoList[section]
        switch sectionInfo.isExpanded {
        case true:
            return sectionInfo.items.count
        case false:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell: ItemWithTextInputCell = tableView.dequeueReusableCell(withIdentifier: ItemWithTextInputCell.identifier,
                for: indexPath
                ) as? ItemWithTextInputCell
        else { return UITableViewCell() }

        return cell
    }
    
    
}

extension MainView: UITableViewDelegate {
   
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let checklistItemHeaderView: ChecklistItemHeaderView = self.tableView.dequeueReusableHeaderFooterView(
                withIdentifier: ChecklistItemHeaderView.identifier
            ) as? ChecklistItemHeaderView
            
        else { return UIView() }

        let sectionInfo: SectionInfo = self.sectionInfoList[section]
        
        
        checklistItemHeaderView.setTitle(sectionInfo.title ?? "")
        checklistItemHeaderView.setSection(section)
        checklistItemHeaderView.delegate = self
        checklistItemHeaderView.checkboxButton.isSelected = sectionInfo.isExpanded
        
        checklistItemHeaderView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        
        let expandedSection: [SectionInfo] = self.sectionInfoList.filter({ $0.isExpanded} )
        
        switch expandedSection.count > 0 && sectionInfo.isExpanded == false {
        case true:
            checklistItemHeaderView.hasMasked()
        case false:
            checklistItemHeaderView.removeMasking()
        }

        return checklistItemHeaderView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }

}

extension MainView: ChecklistItemHeaderViewDelegate {
    
    public func didToggleCheckbox(_ section: Int) {
        let sectionInfo: SectionInfo = self.sectionInfoList[section]
        sectionInfo.isExpanded.toggle()
        self.tableView.reloadData()
    }
    
    
}
