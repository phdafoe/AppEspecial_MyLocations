//
//  HudView.swift
//  App_MyLocations
//
//  Created by User on 7/11/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit

class HudView: UIView {
    
    // Fase 1
    var text = ""
    
    
    class func hudInView(view: UIView, animated: Bool) -> HudView { // Definimos un constructor de conveniencia
        
        let hudView = HudView(frame: view.bounds)
        hudView.opaque = false
        
        view.addSubview(hudView)
        view.userInteractionEnabled = false
        
        //hudView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        
        // FAse 3 animacion llamada al metodo auxiliar
        hudView.showAnimated(animated)

        return hudView
    }
    
    // Fase 2
    override func drawRect(rect: CGRect) {
        // 1 -> declaramos dos constantes que se usaran para calcular lo siguiente, una descripcion de un objeto
        let boxWidth : CGFloat = 96
        let boxHeight : CGFloat = 96
        
        // 2 -> al delcrar boxRect equivalente a CGRect obligamos al compilador a trabajar en decimales
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2),
            y: round((bounds.size.height - boxHeight) / 2),
            width: boxWidth,
            height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        
        // 3 -> Colocando la imagen del etiquetado
        if let image = UIImage(named: "Checkmark"){
            
            let imagePoint = CGPoint(x: center.x - round(image.size.width / 2),
                y: center.y - round(image.size.height / 2) - boxHeight / 8)
            
            image.drawAtPoint(imagePoint)
            
        }
        // 4 -> Colocando el tamaño del texto y su color y su ubicacion
        
        let atributos = [NSFontAttributeName: UIFont.systemFontOfSize(16),
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // COnfiguramos cual es su posicion
        let textSize = text.sizeWithAttributes(atributos)
        let textPoint = CGPoint(x: center.x - round(textSize.width / 2),
            y: center.y - round(textSize.height / 2) + boxHeight / 4)
        
        text.drawAtPoint(textPoint, withAttributes: atributos)
  
    }
    
    //Fase 3 Animacion
    
    
    
    func showAnimated(animated: Bool){
        
        if animated{
            // 1 -> Configuramos el estado inicial de la vista antes de comenzar la animacion
            alpha = 0
            transform = CGAffineTransformMakeScale(1.3, 1.3)
            
            
            /*// opcion 1
            // 2 -> llamamos a un metodo de clausura o bloque para reconfigurar la animacion y su duracion o demora, este clausura describe la animacion
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                //3 -> dentro de la clausura o bloque configuramos el nuevo estado de los objetos
                self.alpha = 1
                self.transform = CGAffineTransformIdentity
            })*/
            
            // opcion 2 OOOOJJJJJOOOO de aqui nos vamos a LocationController
            
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: [],
                animations: { () -> Void in
                    
                    self.alpha = 1
                    self.transform = CGAffineTransformIdentity
                    
                },
                completion: nil)
        }
        
        
        
    }
    
    
    
}
