//posicion, velocidad y acceleracion de la bola
PVector p = new PVector();
PVector v = new PVector();
PVector a = new PVector();

//posicion actual y siguiente
PVector p1, p2;

//vector donde almacenar los puntos por donde pasa la bola
ArrayList<PVector> points = new ArrayList<PVector>();

//tramos de la montaña rusa
int stretches = 22;

//pendiente de un tramo
float slope;

//diferencial de tiempo
float dt = 1/60.0;

//variable para el muestreo de la funcion sin()
float sampling = PI * 6.9;

//tramo actual
int actualStretche = -1;

void setup(){
  size(600, 600);
  
  p1 = new PVector(width / 10, 0);
  p2 = new PVector();
 
  //recorremos todos los tramos almacenando la posicion de cada punto
  for (int i = 0; i < stretches; i++)
  {
    p1 = new PVector(p1.x, p1.y);
    p2 = new PVector(p2.x, p2.y);
     
    if (i != 0)
    {
      p1.x += sampling;
      p1.y = sin(p1.x);
    }
     
    p2.x = p1.x + sampling + 2;
    p2.y = sin(p2.x);
     
    p1.y *= 100;
    p2.y *= 100;
     
    //guardamos los puntos en el vector
    points.add(p1);
  }
  points.add(p2);
   
  //añadimos el punto inicial al inicio del vector
  p = points.get(0);
}
 
void draw() {
  //color de fondo y borrado de la escena
  background(150);
  
  //color de la bola
  fill(255, 255, 255);
  
  translate(0, height/2);
   
  //dibujamos la linea
  for (int i = 0; i < stretches; i++)
    line(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y);
   
  //una vez llega al final, volvemos a empezar
  if (p.x > points.get(stretches).x)
  {
    p = points.get(0);
    actualStretche = -1;
  }
   
  //calculamos el tramo actual
  for (int i = 0; i < stretches; i++)
  {
    if (p.x < points.get(i + 1).x)
    {
      // Si estamos cambiando de tramo
      if (actualStretche != i)
      {
        actualStretche = i;
        
        //a partir de los datos almacenados en el vector, calculamos la posicion actual y la siguiente
        p1 = points.get(actualStretche);
        p2 = points.get(actualStretche + 1);
        
        //a partir de los dos puntos calculados, calculamos la velocidad
        v = PVector.sub(p2, p1);
        v.normalize();
        v.mult(100);
        
        //calculamos la acceleracion y la pendiente
        a = PVector.div(v, 1);
        slope = v.y / v.x;
      }
      
      textSize(18);
      text("Numero de tramos: "+ stretches, width / 10, height/4);
      text("Pendiente: "+ slope + "º", width / 10, height/4 + 30);
      text("Velocidad en X: " + v.x, width / 10, height / 4 + 60);
      text("Velocidad en Y: " + v.y, width / 10, height / 4 + 90); 
      
      break;
    }
  }
   
  v = PVector.add(PVector.mult(a, dt), v);
   
  //cuando la pendiente es negativa, aumentamos la velocidad
  if (slope < 0)
    v = PVector.div(v, 1.05);
   
  p = PVector.add(PVector.mult(v, dt), p);
   
  ellipse(p.x, p.y, 15, 15);
}
