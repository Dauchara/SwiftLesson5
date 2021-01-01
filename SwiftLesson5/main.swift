//
//  main.swift
//  SwiftLesson5
//
//  Created by Ниязов Ринат Раимжанович on 12/31/20.
//

import Foundation

enum CarType: String {
    case passenger = "Легковой трнаспорт"
    case trunk = "Грузовой транспорт"
}
enum FuelType {
    case electro, petrol, diesel
}
enum WindowsState {
    case open, close
}
enum GeneralState {
    case enabled, disabled
}

protocol Printable: CustomStringConvertible {
    func printDescription()
}

extension Printable {
    func printDescription() {
        print(description)
    }
}

protocol Car: class {
    var carType: CarType { get set }
    var yearProd: Int { get set }
    var brand: String { get set }
    var model: String { get set }
    var windowsState: WindowsState { get set }
    var engineState: GeneralState { get set }
    
    func openWindows()
    func closeWindows()
    func enableEngine()
    func disableEngine()
}

extension Car {
    
    func openWindows() {
        if windowsState == .close {
            windowsState = .open
        } else {
            print("\(carType.rawValue) - \(brand) \(model): окна уже открыты!")
        }
    }
    func closeWindows() {
        if windowsState == .open {
            windowsState = .close
        } else {
            print("\(carType.rawValue) - \(brand) \(model): окна уже закрыты!")
        }
    }
    
    func enableEngine() {
        if engineState == .disabled {
            engineState = .enabled
        } else {
            print("\(carType.rawValue) - \(brand) \(model): двигатель уже запущен!")
        }
    }
    
    func disableEngine() {
        if engineState == .enabled {
            engineState = .disabled
        } else {
            print("\(carType.rawValue) - \(brand) \(model): двигатель уже заглушен!")
        }
    }
}



class SportCar: Car, Printable {
    
    var carType: CarType
    var yearProd: Int
    var brand: String
    var model: String
    
    let turbocharging: Bool
    
    var windowsState: WindowsState {
        willSet {
            if newValue == .open {
                print("\(carType.rawValue) - \(brand) \(model): окна открылись!")
            } else {
                print("\(carType.rawValue) - \(brand) \(model): окна закрылись!")
            }
        }
    }
    var engineState: GeneralState {
        willSet {
            if newValue == .enabled {
                print("\(carType.rawValue) - \(brand) \(model): двигатель будет запущен!")
            } else {
                print("\(carType.rawValue) - \(brand) \(model): двигатель будет заглушен!")
            }
        }
    }


    init(turbocharging: Bool, yearProd: Int, brand: String, model: String, trunkVolume: Float) {
        
        self.carType = .passenger
        self.yearProd = yearProd
        self.brand = brand
        self.model = model
        windowsState = .close
        engineState = .disabled
        
        self.turbocharging = turbocharging
    }
    
    func turbochargingOn() {
        if turbocharging == true {
            if engineState == .enabled {
                print("\(brand)-\(model): турбонаддув активирован")
            }
            else {
                print("\(brand)-\(model): двигатель выключен, не возможно включить турбонаддув")
            }
        } else {
            print("\(brand)-\(model): В автомобиле нет функции турбонаддува")
        }
    }
    
    var description: String {
        return String("У автомобиля нет цистерны")
    }
}

class TrunkCar: Car, Printable {
    var carType: CarType
    var yearProd: Int
    var brand: String
    var model: String
    
    var trunkVolume: Float
    var filledTrunkVolume: Float
    
    var windowsState: WindowsState {
        willSet {
            if newValue == .open {
                print("\(carType.rawValue) - \(brand) \(model): окна открылись!")
            } else {
                print("\(carType.rawValue) - \(brand) \(model): окна закрылись!")
            }
        }
    }
    var engineState: GeneralState {
        willSet {
            if newValue == .enabled {
                print("\(carType.rawValue) - \(brand) \(model): двигатель будет запущен!")
            } else {
                print("\(carType.rawValue) - \(brand) \(model): двигатель будет заглушен!")
            }
        }
    }
    
    var cargoLoading: Float {
        willSet {
            if newValue + filledTrunkVolume <= trunkVolume {
                filledTrunkVolume += newValue
                print("\(carType.rawValue) - \(brand) \(model): будет погружен новый груз объемом \(newValue)кг, после останется \(trunkVolume - filledTrunkVolume)кг ")
            } else {
                print("\(carType.rawValue) - \(brand) \(model): недостаточно места, осталось \(trunkVolume - filledTrunkVolume)кг ")
            }
        }
    }
    
    let trailer : Bool
    var trailerConnection : GeneralState {
        willSet {
            if newValue == .enabled {
                print("\(carType.rawValue) - \(brand) \(model): прицеп будет присоединен")
            }
            else {
                print("\(carType.rawValue) - \(brand) \(model): прицеп будет отсоединен")
            }
        }
    }

    init(trailer: Bool, yearProd: Int, brand: String, model: String, trunkVolume: Float) {
        self.carType = .trunk
        self.yearProd = yearProd
        self.brand = brand
        self.model = model
        windowsState = .close
        engineState = .disabled
        
        self.trailer = trailer
        trailerConnection = .disabled
        cargoLoading = 0
        self.trunkVolume = trunkVolume
        filledTrunkVolume = 0
    }

    func connectTrailer(trunkVolume: Float) {
        if trailer == true {
            if trailerConnection == .disabled {
                trailerConnection = .enabled
                self.trunkVolume = trunkVolume
            } else {
                print("\(carType.rawValue) - \(brand) \(model): прицеп уже подключен!")
            }
        } else {
            print("\(carType.rawValue) - \(brand) \(model) не предзназначем для присоединения прицепа!")
        }
    }

    func disconnectTrailer() {
        if trailer == true {
            if trailerConnection == .enabled {
                trailerConnection = .disabled
            } else {
                print("\(carType.rawValue) - \(brand) \(model): в данный момент прицеп отсутствует!")
            }
        } else {
            print("\(carType.rawValue) - \(brand) \(model) не предзназначем для присоединения прицепа!")
        }
    }

    var description: String {
        return String("Грузовой автомобиль \(brand)-\(model) загружен на \(filledTrunkVolume) кг")
    }
}




var porsche = SportCar(turbocharging: true, yearProd: 2019, brand: "Porsche", model: "911", trunkVolume: 120)
var astonMartin = SportCar(turbocharging: false,yearProd: 2012, brand: "Aston Martin", model: "DB9", trunkVolume: 145)

var volkswagen = TrunkCar(trailer: true, yearProd: 2010, brand: "Volkswagen", model: "Tractor Trunk", trunkVolume: 0)
var man = TrunkCar(trailer: false, yearProd: 2014, brand: "MAN", model: "Titan", trunkVolume: 4200)


porsche.openWindows()
porsche.printDescription()
porsche.turbochargingOn()

astonMartin.enableEngine()
astonMartin.turbochargingOn()

volkswagen.enableEngine()
volkswagen.cargoLoading = 3000
volkswagen.connectTrailer(trunkVolume: 3750)
volkswagen.cargoLoading = 3000

man.closeWindows()
man.cargoLoading = 400
man.cargoLoading = 800
man.cargoLoading = 2000
man.cargoLoading = 800
man.printDescription()


print(porsche.brand, porsche.carType.rawValue, porsche.model)
print(astonMartin.brand, astonMartin.engineState, astonMartin.turbocharging)
print(volkswagen.brand, volkswagen.carType.rawValue, volkswagen.trailer, volkswagen.trailerConnection)
print(man.trunkVolume, man.trailer, man.carType.rawValue, man.trunkVolume)

