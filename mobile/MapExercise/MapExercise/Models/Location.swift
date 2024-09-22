//
//  Location.swift
//  MapExercise
//
//  Created by Joe Sturzenegger on 9/22/24.
//

struct Location: Identifiable, Decodable {
    var id: Int
    var latitude: Double
    var longitude: Double
    var attributes: [Attribute]
    
    func getLocationType() -> String {
        return self.attributes.filter( { $0.type == "location_type" } ).first!.value.getString() ?? "Unknown"
    }
    
    func getName() -> String {
        return self.attributes.filter( { $0.type == "name" } ).first!.value.getString() ?? "Unknown"
    }
    
    func getDescription() -> String {
        return self.attributes.filter( { $0.type == "description" } ).first!.value.getString() ?? "Unknown"
    }
    
    func getRevenue() -> Double {
        return self.attributes.filter( { $0.type == "estimated_revenue_millions" } ).first!.value.getDouble() ?? 0.0
    }
}

struct Attribute: Decodable {
    var type: String
    var value: ValueType
}

enum ValueType:Decodable
{
    case string(String)
    case double(Double)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(ValueType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Type not supported"))
        }
    }
    
    func getString() -> String? {
        switch self {
        case .string(let string): return string
        case .double: return nil
        }
    }
    func getDouble() -> Double? {
        switch self {
        case .double(let double): return double
        case .string: return nil
        }
    }
}
