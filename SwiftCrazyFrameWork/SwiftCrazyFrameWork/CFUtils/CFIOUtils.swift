//
//  CFIOUtils.swift
//  SwiftCrazyFrameWork
//  IO相关工具集
//  Created by mxlai on 2020/3/2.
//  Copyright © 2020 mxlai. All rights reserved.
//

import Foundation

open class CFIOUtils {
    
    /// 单个文件的大小
    /// - Parameter filePath: 文件路径
  public static func cf_fileSizeAtPath(_ filePath:String) -> UInt64 {
        let manager = FileManager.default
        var fileSize : UInt64 = 0
        if manager.fileExists(atPath: filePath) {
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: filePath)
                fileSize = attr[FileAttributeKey.size] as! UInt64
                let dict = attr as NSDictionary
                fileSize = dict.fileSize()
            } catch {
                print("Error: \(error)")
                
            }
        }
        return fileSize
    }
    
    /// 单个文件的修改时间
    /// - Parameter filePath: 文件路径
    public static func cf_fileTimeAtPath(_ filePath:String) -> Int {
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath) {
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: filePath)
                if let modificationDate = attr[FileAttributeKey.modificationDate] as? Date {
                    return  Int(modificationDate.timeIntervalSince1970)
                }
            } catch {
                print("Error: \(error)")
                
            }
        }
        return 0
    }

    
    /// 存data到文件
    /// - Parameters:
    ///   - data: ,data 数据
    ///   - fileName: 文件名称
    public static func cf_dataWriteToFile(_ data:Data,_ fileName:String){
        let filePath = kPATH_OF_DOCUMENT + "/" + fileName
        do {
            try data.write(to: URL(string: filePath)!)
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    /// 获取json文件数据
    /// - Parameter fileName: 文件名称
    public static func cf_dataWriteToFile(_ fileName:String) -> Any? {
        let filePath = kPATH_OF_DOCUMENT + "/" + fileName
        do {
            
            let jsonData =  try Data(contentsOf: URL(string: filePath)!)
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            return jsonObject
        } catch  {
            print("Error: \(error)")
            return nil
        }
    }
   
    
    /// 本地文件存放目录
    /// - Parameter type: 文件夹类型
    public static func cf_dataCacheFilePath(_ type:String) -> String {
        var documentsDirectory = kPATH_OF_DOCUMENT
        switch type {
        case "image":
            documentsDirectory = documentsDirectory + "/images"
            case "video":
            documentsDirectory = documentsDirectory + "/video"
            case "audio":
            documentsDirectory = documentsDirectory + "/audio"
        default:
            documentsDirectory = documentsDirectory + "/images"
        }
        var isDir = ObjCBool.init(false)
        let fileManager = FileManager.default
        let existed = fileManager.fileExists(atPath: documentsDirectory, isDirectory: &isDir)
        
        if !(isDir.boolValue&&existed) {
           try? fileManager.createDirectory(atPath: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        return documentsDirectory;
    }
    
    /// 删除文件夹或者文件
    /// - Parameter folderPath: 路径
    public static func cf_folderRemoveAtPath(_ folderPath:String) -> Bool {
        let fileManager = FileManager.default
        
        var isDir = ObjCBool.init(false)
        let existed = fileManager.fileExists(atPath: folderPath, isDirectory: &isDir)
        if !isDir.boolValue && existed {
            try? fileManager.removeItem(atPath: folderPath)
        }else{
        let contents = try? fileManager.contentsOfDirectory(atPath: folderPath) as Array
        contents?.forEach({ (filename) in
            try? fileManager.removeItem(atPath: filename)
        })
        }
        return true
    }
}
