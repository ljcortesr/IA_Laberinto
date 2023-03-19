/*
 Desarrollada por: Laura Cortés-Rico
 Clase: AccionSucesor
 Atributos:
   acción: caracter que representa la acción del jugador: 'a' arriba, 'b' abajo, 'i' izquierda, 'd' derecha y 't' teletransporte. 
   sucesor: atributo de tipo Estado, que representa el estado siguiente, tras ejecutar la acción.    
 Métodos:
   Constructor AccionSucesor: recibe una acción (a) y un estado (e) y los asigna a los atributos accion y sucesor, respectivamente.  
*/
class AccionSucesor{
  char accion;
  Estado sucesor;
  
  AccionSucesor(char a, Estado e){
    accion=a;
    sucesor=e;
  }
}