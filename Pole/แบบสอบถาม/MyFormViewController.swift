//
//  MyFormViewController.swift
//  Pole
//
//  Created by Apple Macintosh on 10/16/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import Eureka

class MyFormViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ช่องทาง = ["โทรทัศน์", "อินเทอร์เน็ต / E-mail", "กิจกรรม (Event)", "หนังสือพิมพ์/นิตยสาร/หนังสือ", "ป้ายตามห้างสรรพสินค้า/สื่อ ณ จุดขาย"]
        
        form +++ SelectableSection<ImageCheckRow<String>>("1. ท่านรู้จักกิจกรรม วื่ง มาจากช่องทางใด", selectionType: .multipleSelection)
        for option in ช่องทาง {
            form.last! <<< ImageCheckRow<String>(option){ lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
                }.cellSetup { cell, _ in
                    cell.trueImage = UIImage(named: "selectedRectangle")!
                    cell.falseImage = UIImage(named: "unselectedRectangle")!
                    cell.accessoryType = .checkmark
            }
        }
        
        let continents = ["เห็นด้วย และ เข้าร่วมกิจกรรม", "เห็นด้วย แต่ ไม่เข้าร่วม", "ไม่เห็นด้วย"]
        
        form +++ SelectableSection<ImageCheckRow<String>>() { section in
            section.header = HeaderFooterView(title: "2. หากในอนาคตปีต่อๆไป จะจัดกิจกรรม วิ่งฮาร์ฟมาราธอน (Half Marathon) ท่านเห็นด้วยและจะเข้าร่วมหรือไม่")
        }
        
        for option in continents {
            form.last! <<< ImageCheckRow<String>(option){ lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
            }
        }
        
        let สาเหตุ = ["เสื้อนักวิ่งมีความสวยงาม", "เหรียญรางวัลมีความสวยงาม", "ถูกชักชวนโดยคนรู้จัก"]
        
        form +++ SelectableSection<ImageCheckRow<String>>("3. ท่านเลือกสมัครเข้าร่วมวิ่ง เพราะเหตุใด", selectionType: .multipleSelection)
        for option in สาเหตุ {
            form.last! <<< ImageCheckRow<String>(option){ lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
                }.cellSetup { cell, _ in
                    cell.trueImage = UIImage(named: "selectedRectangle")!
                    cell.falseImage = UIImage(named: "unselectedRectangle")!
                    cell.accessoryType = .checkmark
            }
        }
        
        form +++ Section("ความคิดเห็นเพิ่มเติม")
            
            <<< TextAreaRow() {
                $0.placeholder = "TextAreaRow"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
            }
        
    }
    
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[1] {
            print("Single Selection:\((row.section as! SelectableSection<ImageCheckRow<String>>).selectedRow()?.baseValue ?? "No row selected")")
        }
        else if row.section === form[0] {
            print("Mutiple Selection:\((row.section as! SelectableSection<ImageCheckRow<String>>).selectedRows().map({$0.baseValue}))")
        }
        else if row.section === form[2] {
            print("Mutiple Selection:\((row.section as! SelectableSection<ImageCheckRow<String>>).selectedRows().map({$0.baseValue}))")
        }
        else if row.section === form[3] {
            print("Value:\(row.baseValue ?? "No Information")")
        }
    }
        
}

