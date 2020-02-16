//
//  CFBaseListViewController.swift
//  SwiftCrazyFrameWork
//  BaseListViewController tableview列表
//  Created by mxlai on 2020/2/12.
//  Copyright © 2020 mxlai. All rights reserved.
//

import UIKit
import RxSwift

public class CFBaseListViewController: CFBaseViewController {
    private var dataList: [CFEntityModel]?
    let vm = CFViewModel()
    private let dispose = DisposeBag()
    
    private lazy var mainTableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.register(cellType: CFBaseTableViewCell.self)
        tableView.rowHeight = 100
        tableView.backgroundColor = kWHITE_COLOR
        self?.contentView = tableView
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
}
extension CFBaseListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CFBaseTableViewCell.self)
        let model = dataList?[indexPath.row]
        cell.entityModel = model
        return cell
    }
    
    
}
