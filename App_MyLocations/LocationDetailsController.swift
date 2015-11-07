//
//  LocationDetailsController.swift
//  App_MyLocations
//
//  Created by User on 28/10/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit
import CoreLocation

// Importamos Dispatch GCD trabajo a bajo nivel a nivel de compilador multihilo
import Dispatch // y nos vamos al metodo doneAction

// Importamos CoreData
import CoreData



// ESTA ES UNA VARIABLE LLAMADA CLAUSURA NO ES MUY HABITUAL
private let dateFormater: NSDateFormatter = {
    
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter
    
    }()

class LocationDetailsController: UITableViewController {
    
    
    //MARK: - VARIABLES LOCALES FASE 1.1 ->
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark : CLPlacemark? // Antes hemos visto que este objeto contiene informacion de calles, ciudades, direcciones
    
    // Fase 3 desde La clase Category
    var categoryName = "No Category"
    
    // Fase 4 ->  CoreData ojo
    var managedObjectContext : NSManagedObjectContext!
    
    // Fase 5 -> Salvando Datos dentro del CoreData
    var date = NSDate()
    
    

    //MARK: FASE 1 -> IB
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLBL: UILabel!
    @IBOutlet weak var latitudeLBL: UILabel!
    @IBOutlet weak var longitudeLBL: UILabel!
    @IBOutlet weak var addressLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    

    
    
    //MARK: ACCIONES  FASE 1 ->
    
    @IBAction func doneAction(sender: AnyObject) {
        
        //dismissViewControllerAnimated(true, completion: nil)
        // Fase donde activamos la clase HudView
        let hudView = HudView.hudInView(navigationController!.view, animated: true)
        hudView.text = "Etiquetado"
        
        
        //Fase de CORE DATA SALVADO DE FICHEROS
        // 1 -> Creamos un objeto location este es diferente pues tira de CoreData
        
        let location = NSEntityDescription.insertNewObjectForEntityForName("Locations", inManagedObjectContext: managedObjectContext) as! Locations
        // 2 -> sincronizamos
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        
        // 3
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Error: \(error)")
        }
        
        
        //Fase CON DISPATCH
        /*let delayInSecond = 0.6
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSecond * Double(NSEC_PER_SEC))) // Aqui son segundos cuidado con microsegundos
        
        dispatch_after(when, dispatch_get_main_queue()) { () -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }*/ // Aqui remplazamos lo que hace la clase Function.swift
        afterDelay(0.6, clousure:{
            self.dismissViewControllerAnimated(true, completion: nil)
        })
  
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: - LIFE APP

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fase 2 ->
        descriptionTextView.text = ""
        categoryLBL.text = categoryName // fase 3 desde Category
        latitudeLBL.text = "\(coordinate.latitude)"
        longitudeLBL.text = "\(coordinate.longitude)"
        
        if let placemark = placemark{
            addressLBL.text = stringFromPlacemark(placemark) // Metodo Propio
        }else{
            
            addressLBL.text = "Direccion no encontrada"
        }
        
        //dateLBL.text = formatDate(NSDate()) // Metodo Propio
        dateLBL.text = formatDate(date) // aqui comenzamos a salvar en COREDATA
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,
            action: "hideKeyboard:")
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        
        loadCoreData()
        
        

    }
    
    
    //MARK -> UTILS METODOS PROPIOS Y AUXILIARES
    // LE damos formato al placemark
    func stringFromPlacemark(placemark: CLPlacemark) -> String{
       
        var text = ""
        if let stringA = placemark.subThoroughfare{
            text += stringA + " "
        }
        if let stringA = placemark.thoroughfare{
            text += stringA + ", "
        }
        if let stringA = placemark.locality{
            text += stringA + ", "
        }
        if let stringA = placemark.administrativeArea{
            text += stringA + " "
        }
        if let stringA = placemark.postalCode{
            text += stringA + ", "
        }
        if let stringA = placemark.country{
            text += stringA
        }
        return text
        
    }
    
    func formatDate(date: NSDate) -> String{
        
        return dateFormater.stringFromDate(date)
        
        
    }
    
    func hideKeyboard(gestureRecognizer : UIGestureRecognizer){
        
        let point = gestureRecognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        if indexPath != nil && indexPath?.section == 0 && indexPath?.row == 0{
            return
        }
        
        // OTRAS MANERAS DE ESCRIBIR EL IF ANTERIOR
        /*if indexPath == nil || !(indexPath?.section == 0 && indexPath?.row == 0){
            descriptionTextView.resignFirstResponder()
        }*/
        
        /*if let indexPath = indexPath where indexPath.section != 0 && indexPath.row != 0{
            descriptionTextView.resignFirstResponder()
        }*/
        
        descriptionTextView.resignFirstResponder()
    }
    



    //MARK: - UITABLEVIEWDELEGATE
    // Este metodo de delegado llama a la tabla y carga las celdas o filas, normalmente las filas o celdas tienen una altura similar entre ellas, pero con na simple asiganacion  de propiedades podemos cambiar la altura de las celdas o de una sola
    
    /*override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0{
            
            return 88
            
        }else if indexPath.section == 2 && indexPath.row == 2{
            
            //1 -> modificamos el ancho del LBL o la etiqueta  a 115
            addressLBL.frame.size = CGSize(width: view.bounds.size.width - 115, height: 10000)
            
            //2 -> ajustamos la etiqueta al tamaño predetermiando
            addressLBL.sizeToFit()
            
            //3 -> la llamada anterior remueve y procura espacio hacia la derecha del boton
            addressLBL.frame.origin.x = view.bounds.size.width - addressLBL.frame.size.width - 15
            
            //4 -> sabemos que la altura d la etiqueta, asi que podemos añadirle un margen  de 10 puntos arriba y abajo
            return addressLBL.frame.size.height + 20
            
        }else{
            
            return 44
        }
    }*/
    
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 0 || indexPath.section == 1{
            return indexPath
            
        }else{
            return nil
        }
        
    }
    
    // Fase de Modificacion de la celda de descripcion
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0{
            descriptionTextView.becomeFirstResponder()
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PickerCategory"{
            
            let controller = segue.destinationViewController as! CategoryPickerTableViewController
            controller.selectedCategoryName = categoryName
        }
    }
    
    @IBAction func categoryPickerDidPickCategory(segue: UIStoryboardSegue){
        
        let controller = segue.sourceViewController as! CategoryPickerTableViewController
        categoryName = controller.selectedCategoryName
        categoryLBL.text = categoryName
        
    }
    
    //MARK: - COREDATA
    // esto mismo hay que hacerlo en la clase CurrentLocation
    func loadCoreData(){
        
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
   
    }

    



}
