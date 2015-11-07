//
//  AppDelegate.swift
//  App_MyLocations
//
//  Created by User on 28/10/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    
    //MARK: - COREDATA
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        guard let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")else{
                
                fatalError("No se ha encontrado el modelo de datos dentro de la carpeta de la App")
        }
        
        
        guard let model = NSManagedObjectModel(contentsOfURL: modelURL)else{
                fatalError("Error al inicializar el modelo desde :\(modelURL)")
        }
        
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,
            inDomains: NSSearchPathDomainMask.UserDomainMask)
        let documentsDirectory = urls[0]
        let storeURL = documentsDirectory.URLByAppendingPathComponent("DataStore.sqlite")
        
        do{
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            let context = NSManagedObjectContext(concurrencyType:NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            return context
            
        }catch{
            
            fatalError("Error al añadir persistencia a la tienda de \(storeURL) : \(error)")
        }
        
        }() // DE AQUI NOS VAMOS A LOCATION DETAIL VIEW CONTROLLER


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // FASE DE COREDATA EN LA VISTA DE CURRENT LOCATION
        let tabBarController = window!.rootViewController as! UITabBarController
        if let tabBarController = tabBarController.viewControllers{
            let currentLocationViewController = tabBarController[0] as! CurrentLocationViewController
            currentLocationViewController.managedObjectContext = managedObjectContext
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}

