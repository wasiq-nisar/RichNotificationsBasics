//
//  AppDelegate.swift
//  EatMoreVegetable
//
//  Created by Brian Advent on 26/02/2017.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (authorized: Bool, error: Error?) in
            if !authorized {
                print("Notification Authorization Not Allowed")
            }
        }
        
        // Define Actions
        let fruitAction = UNNotificationAction(identifier: "addFruit", title: "Add a Piece of fruit")
        let vegetableAction = UNNotificationAction(identifier: "addVegetable", title: "Add a Piece of Vegetable")
        
        // Add Actions to Category
        let category = UNNotificationCategory(identifier: "foodCategory", actions: [fruitAction, vegetableAction], intentIdentifiers: [])
        
        // Add Category to NotificationFrameWork
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().delegate = self
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Stay Healthy"
        content.body  = "Reminder to eat your food"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "foodCategory"
        
        guard let path = Bundle.main.path(forResource: "Apple", ofType: "png") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "logo", url: url)
            content.attachments = [attachment]
        } catch {
            print("The attachment could not be loaded")
        }
        
        let request = UNNotificationRequest(identifier: "foodNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Datamodel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let foodItem = Food(context: persistentContainer.viewContext)
        foodItem.added = Date()
        
        if response.actionIdentifier == "addFruit" {
            foodItem.type = "Fruit"
        } else {
            foodItem.type = "Vegetable"
        }
        self.saveContext()
        scheduleNotification()
        
        completionHandler()     // We are done
    }
}

