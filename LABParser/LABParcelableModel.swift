//
//  LABParcelableModel.swift
//  LABParser
//
//  Created by Leonardo Armero Barbosa on 12/5/17.
//  Copyright © 2017 Leonardo Armero Barbosa. All rights reserved.
//

import Foundation

@objcMembers
open class ParcelableModel: NSObject {
    
    required override public init(){
        super.init()
    }
    
    // MARK: Commons
    /**
     Get a dictionary with label-value of properties of the current NSObject
     
     - returns: Dictionary with label-value of properties.
     */
    func getPropertiesAndType() -> [String : String] {
        var propertiesAndType = [String: String]()
        let aMirror = Mirror(reflecting: self)
        
        for case let (label?, value) in aMirror.children {
            propertiesAndType[label] = "\(Mirror(reflecting: value).subjectType)".components(separatedBy: "<").last!.components(separatedBy: ">").first
        }
        
        return propertiesAndType
    }
    
    /**
     Get type of a class from their class name.
     
     - parameter className: String with class name.
     - returns: Class type ready to initializing.
     */
    func swiftClassFromString(_ className: String) -> ParcelableModel.Type {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        var path = appName + "." + className
        if path.contains(" ") {
            path = path.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)
        }
        let anyClass: AnyClass = NSClassFromString(path)!
        return anyClass as! ParcelableModel.Type
    }
    
    public func customKeysName() -> [String : String]? {
        return nil
    }
    
    // MARK: From
    /**
     Fills the current NSObject with JSON data.
     
     - Parameter json: String with JSON data.
     
     - Throws: If an internal error occurs, upon throws contains an NSError object that describes the problem.
     */
    public func fromJSON(_ json: String) throws {
        var dictionary: [String: AnyObject]?
        if let data = json.data(using: String.Encoding.utf8) {
            do {
                dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                fromDictionary(dictionary!)
            } catch let error as NSError {
                throw error
            }
        }
    }
    
    /**
     Fills the current NSObject with a Dictionary data.
     
     - parameter json: Dictionary with data.
     */
    public func fromDictionary(_ json: [String: AnyObject]) {
        
        let propertyAndTypes = self.getPropertiesAndType()
        
        let customKeys: [String : String]? = self.customKeysName()
        
        for (label, type) in propertyAndTypes {
            var customKey = label
            
            if let custom = customKeys?[label] {
                customKey = custom
            }
            
            guard let propertyValue = json[customKey] else {
                continue
            }
            
            if let stringValue = propertyValue as? String {
                self.setValue(stringValue, forKey: label)
                continue
            }
            
            if let intValue = propertyValue as? NSNumber {
                if type == "String" {
                    self.setValue(String(describing: intValue), forKey: label)
                } else {
                    self.setValue(intValue, forKey: label)
                }
            }
            
            // Array
            
            if let arrayValue = propertyValue as? [String] {
                self.setValue(arrayValue, forKey: label)
                continue
            }
            
            if let arrayValue = propertyValue as? [NSNumber] {
                self.setValue(arrayValue, forKey: label)
                continue
            }
            
            if let arrayValue = propertyValue as? [[String : AnyObject]] {
                var arrayObjects = [AnyObject]()
                for item in arrayValue {
                    let modelType : ParcelableModel.Type = swiftClassFromString(type)
                    let modelObject = modelType.init()
                    modelObject.fromDictionary(item)
                    arrayObjects.append(modelObject)
                }
                self.setValue(arrayObjects, forKey: label)
                continue
            }
            
            // Dictionary
            
            if type == "String, String" || type == "String, Int" || type == "String, Bool"
                || type == "Int, String" {
                self.setValue(propertyValue, forKey: label)
                continue
            }
            
            if let modelValue = propertyValue as? [String:AnyObject] {
                let modelType : ParcelableModel.Type = swiftClassFromString(type)
                let modelObject = modelType.init()
                modelObject.fromDictionary(modelValue)
                self.setValue(modelObject, forKey: label)
            }
        }
    }
    
    public class func fromJsonArray<T : ParcelableModel>(_ array: [[String: AnyObject]]) -> [T] {
        var arrayObjects = [T]()
        
        for item in array {
            let object = T()
            object.fromDictionary(item)
            arrayObjects.append(object)
        }
        
        return arrayObjects
    }
    
    // MARK: To
    /**
     Transform the current NSObject to JSON.
     
     - Returns: JSON String with data.
     - Throws: If an internal error occurs, upon throws contains an NSError object that describes the problem.
     */
    public func toJSON() throws -> String? {
        let dictionary: [String: AnyObject] = toDictionary()
        //        if !JSONSerialization.isValidJSONObject(dictionary) {
        //            return nil
        //        }
        let data = try JSONSerialization.data(withJSONObject: dictionary , options: [])
        let jsonString = NSString(data: data, encoding: String.Encoding.ascii.rawValue)
        return jsonString as String?
    }
    
    /**
     Transforms the current NSObject to Dictionary.
     
     - returns: Dictionary with data.
     */
    public func toDictionary() -> [String: AnyObject] {
        var dictionary = Dictionary<String, AnyObject>()
        
        let propertyAndTypes = self.getPropertiesAndType()
        
        for (label, _) in propertyAndTypes {
            
            guard let propertyValue = self.value(forKey: label) else {
                continue
            }
            
            if propertyValue is String
            {
                dictionary[label] = propertyValue as! String as AnyObject?
            }
                
            else if propertyValue is NSNumber
            {
                dictionary[label] = propertyValue as! NSNumber
            }
                
            else if propertyValue is Array<String>
            {
                dictionary[label] = propertyValue as AnyObject?
            }
                
            else if propertyValue is Array<AnyObject>
            {
                var array = Array<[String: AnyObject]>()
                
                for item in (propertyValue as! Array<ParcelableModel>) {
                    array.append(item.toDictionary())
                }
                
                dictionary[label] = array as AnyObject?
            }
                // AnyObject
            else
            {
                dictionary[label] = (propertyValue as! ParcelableModel).toDictionary() as AnyObject
            }
        }
        return dictionary
    }
}

