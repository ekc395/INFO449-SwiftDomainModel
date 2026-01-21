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
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}
