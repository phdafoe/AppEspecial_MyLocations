
//
//  FirstViewController.swift
//  App_MyLocations
//
//  Created by User on 28/10/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit


// FASE 1 -> Importacion de CoreLocation para poder invocar el protocolo DELEGADO de
// CLLocationManagerDelegate
import CoreLocation

import CoreData

// Fase 2 -> Importacion de CLLocationManagerDelegate
class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - VARIABLES LOCALES

    let locationManager : CLLocationManager = CLLocationManager() // El () es el alloc / init aqui construimos el objeto
    
    
    
     /*********************** FASE 5 **********************/
    
    
    // Fase 5 -> // esta variable es del tipo optional(puede que no tenga informacion) siempre que tengamos un dato mutable hay que confirmarlo como var pero apple quiere que uses todo como "let"
    var location : CLLocation?
    
    
    /*********************** FASE 5 **********************/
    
    
    /*********************** FASE 6 **********************/
    
    // Fase 6 -> Manejo de errores y nos vamos a trabajarlos en el metodo delegado de CLLocationManagerDelegate
    var updatingLocation = false
    var lastLocationError : NSError?
    

    /*********************** FASE 6 **********************/
    
    
    /*********************** FASE 11 **********************/
    
    // Fase 11 -> Geocodificacion inversa lo trabajaremos en el metodo delegado didUpdateLocations
    let geocoder = CLGeocoder() // Aqui le metemos ya el alloc init :)
    var placemark : CLPlacemark? // optional pues puede ser nil
    var performingReverseGeocoding = false
    var lasGeocodingError : NSError? // optionl puede ser nil
    
    /*********************** FASE 11 **********************/
    
    
    
    /*********************** FASE 13 **********************/
    
    // Fase 13 ->
    var timer: NSTimer?
    
    /*********************** FASE 13 **********************/
    
    // FASE DE COREDATA de aqui nos vamos al metodo segue
    var managedObjectContext : NSManagedObjectContext!
    
    
    
    
    
    //MARK: - VARIABLES IB
    // Variables IB
    
    @IBOutlet weak var messageLBL: UILabel!
    @IBOutlet weak var latitudeLBL: UILabel!
    @IBOutlet weak var longitudeLBL: UILabel!
    @IBOutlet weak var addressLBL: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    
    //MARK: - ACCIONES IB
    // Acciones IB
    
    // En este metodo del boton le damos justo en el instante de realizar la ppulsacion del boton o realizar la accion se llama al delegado de CLLocationManagerDelegate ademas de la precision deseada  que le pasamos una constante de 10 mt de distancia o de precision y que posteriormente inicie la actualizacion de la localizacion
    @IBAction func getMyLocation(sender: AnyObject) {
        
        
        /*********************** FASE 2 **********************/
        
        /*// Fase 2 -> Implementacion deel framework CLLocationManager con el objeto anteriormente creado como variable local
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()*/
        
        
        /*********************** FASE 2 **********************/
        
        
        /*********************** FASE 3 **********************/
        
        // Fase 3 -> Vamos a revisar el estado de autorizacion actual .NotDetermined es que aun no va a preguntar la App si tiene o no permiso //  debemos poner esto en el info.plist "NSLocationWhenInUseUsageDescription"/""
        
        let authStatus = CLLocationManager.authorizationStatus() // cronstruimos el objeto
        
        
        // Fase 3
        /*if authStatus == .NotDetermined{
            
            locationManager.requestWhenInUseAuthorization()
            return
            
        }*/
        
        
        
        /*********************** FASE 3 **********************/

        /*********************** FASE 4 **********************/

        // Fase 4 -> Implementacion de la Alerta comentando el if Anterior
        // si el estado de Autorizacion es denegado o restringido llama al metodo y este metodo tiene un popUp con alerta
        if authStatus == .Denied || authStatus == .Restricted{
         
            showLocationServicesDeniedAlert()
            return
            
        }
        
        
        /*********************** FASE 4 **********************/

        /*********************** FASE 7 **********************/
        
        // Fase 7 -> Gestion de errores //
        //startLocationManager() // METODO AUXILIAR
        
        
        /*********************** FASE 7 **********************/
        
        
        
        
        
        /*********************** FASE 10 **********************/
        
        
        // Fase 10 -> Modificamos la llamada a este metodo auxiliar es decir al starLocationManager()
        // LA fase 11 nos dedicaremos a "Geocodificacion inversa"
        if updatingLocation{
            stopLocationManager()
            
        }else{
            
            location = nil
            lastLocationError = nil
            
            /*********************** FASE 11 **********************/
            
            // Fase 11.2.6 ->
            placemark = nil
            lastLocationError = nil
            
            
            /*********************** FASE 11 **********************/
            
            
            
            startLocationManager()
            
        }
        
        
        /*********************** FASE 10 **********************/
        
        
        
        updateLabels() // METODO AUXILIAR
        
        /*********************** FASE 9 **********************/
        
        // Fase 9 -> METODO AUXILIAR
        configureGetButton() // METODO AUXILIAR
        
        /*********************** FASE 9 **********************/

    }

    /*********************** FASE 3 *****************************************************************************************************/
    
    
    
    //MARK: - CLLocationManagerDelegate
    // Vamos a imprir datos  // Fase 3
    

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        // Este error surge cuando el delegado no tiene acceso al GPS del dispositivo, por tanto no puede obtener su localizacion
        // siempre que le hayamos dicho que no al permiso, nos saltara este erro y hay que subsanarlo con un metodo especial una Alerta
        print("didFailWithError \(error)")
        
        
        
        /*********************** FASE 6 **********************/
        
        
        // Fase 6 -> el location manager puede reportar multiples errores para varios escenarios el ".code" encuentra que tipo de error tenemos ademas le consultamos si es igual si la localizacion es desconocida y le solicitamos que lo intente encontrar el valor del error
        if error.code == CLError.LocationUnknown.rawValue{
            
            return
        }
        
        
        /*********************** FASE 6 **********************/
        
        lastLocationError = error
        
        stopLocationManager() // METODO AUXILIAR STOP START
        updateLabels() // METODO AUXILIAR
        
        
        /*********************** FASE 9 **********************/

        // Fase 9 -> METODO AUXILIAR
        configureGetButton() // METODO AUXILIAR
        
        
        /*********************** FASE 9 **********************/
   
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")

        /*********************** FASE 5 **********************/
        
        /*// Fase 5 -> la variable local location le decimos que es igual a newLocation y que por tanto es la ultima dado el metodo .last!(not null)
        location = newLocation
        updateLabels() // Metodo Auxiliar*/
        
        
        /*********************** FASE 5 **********************/
        

        
        /*********************** FASE 7 **********************/
        
        // Fase 7 ->
        // esta linea limpia los errores de estado despues de recibir una coordenada valida
        lastLocationError = nil
        
        /*********************** FASE 7 **********************/
        

        /*********************** FASE 8 ***************************************************************/
        
        // Fase 8
        
        // Fase 8.1 -> si el tiempo en que cada objeto ha determinado es demasiado largo para ser 5 segundos en este caso retorna una llamada al cache
        
        if newLocation.timestamp.timeIntervalSinceNow < -5{
            return
            
        }
        
        // Fase 8.2 -> para determinari si las nuevas lecturas de la locaclizacion son mas precisas que las anteriores se usa horizontalAccurancy si son "0" las medidas son invalidas e ignoraremos eso
        
        if newLocation.horizontalAccuracy < 0{
            return
            
        }
        
        
        /*********************** FASE 8 ***************************************************************/
        

        /*********************** FASE 12 **********************/
        
        // Fase 12 -> este calculo de distancia puede ser una nueva lectura que mostraria el valor a traves de esa constante que representa elv alor maximo en un tipo float
        var distance = CLLocationDistance(DBL_MAX)
        if let location = location{
            
            distance = newLocation.distanceFromLocation(location)
            
        }
        
        /*********************** FASE 12 **********************/
        
        
        /*********************** FASE 8 ***************************************************************/
        
        
        // Fase 8.3 -> como location es un "optional" no tenemos acceso a las propiedades directamente, primero debemos desempaquetarlo 
        // tenemos opcion de if let pero si ademas sabemos que noes null pues en ese caso forzamos el desempaquetado con "!"
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy{
            
            lastLocationError = nil
            location = newLocation
            updateLabels()
            
            // Fase 8.4
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy{
                
                print("*** HEMOS TERMINADO :]")
                stopLocationManager()
                
                // Fase 9 -> METODO AUXILIAR
                configureGetButton() // METODO AUXILIAR
                
                // Fase 12 -> estas lineas finaliza la geolocalizacion inversa
                if distance > 0{
                    
                    performingReverseGeocoding = false
                }
                
            }
            
            /*********************** FASE 8 ***************************************************************/
            
            
            /*********************** FASE 11 **********************/
            
            
            
            // Fase 11 -> El nuevo codigo aparece aqui // Este nuevo codigo se le llama metodo de clausura en objc era un bloque y tiene ademas la posibilidad de tocar temas  de GCD Grand Central Dispatch Tareas multi Hilo
            
            if !performingReverseGeocoding{
                print("*** Vamos con la geocodificación")
                
                performingReverseGeocoding = true
                
                geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
                    (placemarks, error) -> Void in
                    
                    //print("*** Encontrando Lugares de marca: \(placemarks), error: \(error)")
                    
                    // Fase 11.1 ->
                    // programacion Defensiva
                    // es in if let aqui placemarks es un "optional" y necesitamos desempaquetarle antes con el riesgo que se nos caiga la app, puede haber un nil, el desempaquetado de array placemarks lo llevo de manera temporal a "let p" el where !p.isEmpty digo que dicha variable temporal no esta vacia con la propiedad .isEmpty
                    self.lastLocationError = error
                    
                    if error == nil, let p = placemarks where !p.isEmpty{
                        
                        /*if self.placemark == nil{
                            
                            print("PRIMERA VEZ!")
                            
                        }*/
                        
                        self.placemark = p.last!
                        
                    }else{
                        
                        self.placemark = nil
                        
                    }
                    
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                    
                })
                
                /*********************** FASE 11 **********************/
        }
            /*********************** FASE 12 **********************/
            // Fase 12 ->
        }else if distance < 1.0{
            
            let timeInterval = newLocation.timestamp.timeIntervalSinceDate(location!.timestamp)
            
            if timeInterval > 10{
                
                print("***Venga Chaval!")
                stopLocationManager()
                updateLabels()
                configureGetButton()
            }
        }/*********************** FASE 12 **********************/
    }
    
    
    /*********************** FASE 3 *************************************************************************************************/
    
    
    
    /*********************** FASE 4 **********************/
    
    
    
    //MARK: - AlertDeniedAccess
    // Fase 4 -> este es un PopUp que muestra una Alerta
    
    func showLocationServicesDeniedAlert(){
        
        let alert = UIAlertController(title: "Servicio de Localizacion Denegado",
            message: "Por favor active los servicios de localización de la app dentro de los ajustes",
            preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok!",
            style: UIAlertActionStyle.Default,
            handler: nil)
        
        alert.addAction(okAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
        
    }
    
    
    /*********************** FASE 4 **********************/
    
    
    
    //MARK: - UTILS - AUXILIARES
    
    func updateLabels(){
        
        // siempre que tengamos una variable del tipo "optional" debemos ralizar in "if let" con el mismo nombre de variable (OJJOOOOO)
        
        if let location = location{
            
            latitudeLBL.text = "\(location.coordinate.latitude)"
            longitudeLBL.text = "\(location.coordinate.longitude)"
            tagButton.hidden = false
            messageLBL.text = ""
            
            
            /*********************** FASE 11 **********************/
            
            // Fase 11.2 -> Nuevo codigo
            
            if let placemark = placemark{
                // Nuevo metodo Auxiliar
                addressLBL.text = stringFromPlacemark(placemark)
                
            }else if performingReverseGeocoding{
                
                addressLBL.text = "Buscando Dirección..."
                
            }else if lastLocationError != nil{
                
                addressLBL.text = "Error buscando la direccion"
                
            }else{
                addressLBL.text = "Direccion No encontrada"
                
            }
            
            /*********************** FASE 11 **********************/
            
   
        }else{
            
            latitudeLBL.text = ""
            longitudeLBL.text = ""
            addressLBL.text = ""
            tagButton.hidden = true
            messageLBL.text = "Haz Click en 'Get my Location' para Iniciar"
            
            
            /*********************** FASE 6 **********************/
            
            
            
            // Fase 6 -> Probocar el error
            // El codigo comienza aqui
            let statusMessage : String
            if let error = lastLocationError{ // Aqui realizamos una condicion if let para el optional "lastLocationError"
                
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue{
                    
                    statusMessage = "Servicio de Localizacion Deshabilitado"
                    
                }else{
                    
                    statusMessage = "Error de obtencion de Localizacion"
                }
                
            }else if !CLLocationManager.locationServicesEnabled(){
                
                statusMessage = "Servicio de Localizacion Deshabilitado"
                
            }else if updatingLocation{
                
                statusMessage = "Buscando Servicio ..."
                
            }else{
                
                statusMessage = "Haz Click en 'Get my Location' para Iniciar"
            }
            
            messageLBL.text = statusMessage
            
            
            /*********************** FASE 6 **********************/
            
            
            
        }
   
    }
    
    
    
    
    func startLocationManager(){
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            
            
              /*********************** FASE 13 **********************/
            
            
            // Fase 13 -> comienza el Nuevo codigo
            // en estas lineas programamos el objeto timer que envia un mensaje "didTimeOut" a el mismo despues de 60 segundos
            // este es un metodo auxiliar
            timer = NSTimer.scheduledTimerWithTimeInterval(60,
                target: self,
                selector: Selector("didTimeOut"),
                userInfo: nil,
                repeats: false)
            
            /*********************** FASE 13 **********************/
   
        }
    }
    
    func stopLocationManager(){
        
        if updatingLocation{
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        updatingLocation = false // Probocaremos un error para ver que pasa
            
            /*********************** FASE 13 **********************/

            // Fase 13 -> comienza el Nuevo codigo
            if let timer = timer{
                timer.invalidate()
            }
            /*********************** FASE 13 **********************/

        }

    }
    
    
     /*********************** FASE 9 **********************/
    
    // Fase 9 -> es normal tener el boton de obtener la localizacion en una vista que nos diga Stop y otra tira pa'lante compañero OJOOO
    
    func configureGetButton(){
        
        if updatingLocation{
            
            getButton.setTitle("Stop", forState: UIControlState.Normal)
            
        }else{
            
            getButton.setTitle("Obtener my Localización", forState: UIControlState.Normal)
        }
        
        
    }
    
    
      /*********************** FASE 9 **********************/
    
    
    
    
    
      /*********************** FASE 11 **********************/
    
    
    // Fase 11.2 ->
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String{
        // 11.2.1 ->
        var line1 = ""
        // 11.2.2 ->
        if let stringTitle = placemark.subThoroughfare{
            line1 += stringTitle + " "
        }
        // 11.2.3 ->
        if let stringTitle = placemark.thoroughfare{
             line1 += stringTitle
        }
        // 11.2.4 ->
        var line2 = " "
        if let stringTitle = placemark.locality{
            line2 += stringTitle + " "
        }
        if let stringTitle = placemark.administrativeArea{
            line2 += stringTitle + " "
        }
        if let stringTitle = placemark.postalCode{
            line2 += stringTitle
        }
        // 11.2.5 ->
        return line1 + "\n" + line2
    }
    

    /*********************** FASE 11 **********************/
    
    
    
    
    
    /*********************** FASE 13 **********************/
    
    
    // Fase 13 -> comienza el Nuevo codigo
    func didTimeOut(){
        print("*** Fuera del tiempo")
        if location == nil{
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationErrorDomain",
                code: 1,
                userInfo: nil)
            updateLabels()
            configureGetButton()
        }
   
    }
    
    
     /*********************** FASE 13 **********************/
    
    
    //MARK: - Metodos de Apple Life Cycle ViewController
    

    override func viewDidLoad() {
        super.viewDidLoad()
        /*********************** FASE 5 **********************/
        // Fase 5 -> Si llamamos este metodo cuando la vista se ha cargado, automaticamente entra en el "else" y asi obtenemos un nil seguro
        // pero vamos a trabajar los errores (A ELLO ICOSPARTANOS)
        updateLabels() // Metodo Auxiliar
        
        
         /*********************** FASE 5 **********************/
        

         /*********************** FASE 9 **********************/
        
        // Fase 9 -> METODO AUXILIAR
        configureGetButton()
        
        
        /*********************** FASE 9 **********************/

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Prepare for segue con LocationDetail
    // DE AQUI NOS VAMOS A LocationDetal Metodo ViewDidLoad OOOOOJJJOOOO
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            
            if segue.identifier == "TagLocation"{
                let navigationController = segue.destinationViewController as! UINavigationController
                let controller = navigationController.topViewController as! LocationDetailsController
                controller.coordinate = location!.coordinate
                controller.placemark = placemark
                
                // FAse DE COE DATA de aqui nos vamos al AppDelegate
                controller.managedObjectContext = managedObjectContext
            }
    }

}

