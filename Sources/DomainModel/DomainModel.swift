struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
    init(amount: Int, currency: String) {
        let validCurrencies = ["USD", "CAN", "EUR", "GBP"]
        guard validCurrencies.contains(currency) else {
            fatalError("Invalid currency: \(currency)")
        }
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ input: String) -> Money {
        var tempUSD = 0.0
        if (self.currency == "USD") {
            tempUSD = Double(self.amount)
        } else if (self.currency == "CAN") {
            tempUSD = Double(self.amount) / 1.25
        } else if (self.currency == "EUR") {
            tempUSD = Double(self.amount) / 1.5
        } else if (self.currency == "GBP") {
            tempUSD = Double(self.amount) / 0.5
        }
        
        var converted = 0.0
        if (input == "USD") {
            converted = tempUSD
        } else if (input == "CAN") {
            converted = tempUSD * 1.25
        } else if (input == "EUR") {
            converted = tempUSD * 1.5
        } else if (input == "GBP") {
            converted = tempUSD * 0.5
        }
        
        let rounded = Int(converted.rounded())
        
        return Money(amount: rounded, currency: input)
    }
    
    func add(_ other: Money) -> Money {
        let converted = self.convert(other.currency)
        return Money(amount: converted.amount + other.amount, currency: other.currency)
    }
    
    func subtract(_ other: Money) -> Money {
        let converted = self.convert(other.currency)
        return Money(amount: converted.amount - other.amount, currency: other.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    let title: String
    var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ input: Int) -> Int {
        switch self.type {
        case .Salary(let amount):
            return Int(amount)
        case .Hourly(let amount):
            return Int(amount * Double(input))
        }
    }
    
    func raise(byAmount: Double) {
        switch self.type {
        case .Salary(let amount):
            self.type = .Salary(amount + UInt(byAmount))
        case .Hourly(let amount):
            self.type = . Hourly(amount + byAmount)
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
        case .Salary(let amount):
            self.type = .Salary(amount + UInt(Double(amount) * byPercent))
        case .Hourly(let amount):
            self.type = .Hourly(amount + (amount * byPercent))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName : String
    let lastName : String
    let age : Int
    var job : Job? {
        didSet {
            if (age < 16) {
                self.job = nil
            }
        }
    }
    var spouse : Person? {
        didSet {
            if (age < 18) {
                self.spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String{
        var result = "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age)"
        if let job = self.job {
            result += " job:\(job)"
        } else {
            result += " job:nil"
        }
                
        if let spouse = self.spouse {
            result += " spouse:\(spouse.toString())"
        } else {
            result += " spouse:nil"
        }
                
        result += "]"
        return result
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members : [Person]
    
    init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse != nil || spouse2.spouse != nil) {
            fatalError("One or both persons is already married")
        }
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members = [spouse1, spouse2]
    }
    
    func haveChild(_ child : Person) -> Bool {
        if (members[0].age <= 21 && members[1].age <= 21) {
            return false
        }
        self.members.append(child)
        return true
    }
    
    func householdIncome() -> Int {
        var income = 0
        for member in members {
            if let job = member.job {
                switch job.type {
                case .Salary(let amount):
                    income += Int(amount)
                case .Hourly(let amount):
                    income += Int(amount * 2000)
                }
            }
        }
        return income
    }
}
