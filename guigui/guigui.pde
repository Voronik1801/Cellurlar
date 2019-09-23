import controlP5.*;
import javax.swing.*;

PrintWriter output;
PImage exclam;

int W, H;
int W1, H1;
int W2=0, H2=0;
PGraphics pg;
PGraphics pg1;
PFont f;
int fieldNum = 0;
int colorNum = 0;
int matrixSize = 64;
int[] particles;
boolean keyField = false;
boolean keyField0 = false;
boolean toggleValue = false;

int[][] a; //массив значений поля
int[][] a1; //массив после изменения
int[][] c;
int[][] v;
int[][] c1;
int[] k_x; // x координаты кнопок
int[] k_y; // y координаты кнопок

color[] destField;

int head=0;
int left=0;
int right=0;
int down=0;

int shape_size=50; //размер нарисованных фигур
int turn = 1; //показатель поворота фигуры
int shape = 1;  // 0 - круг, 1 - квадрат, 2 - прямоугольник, 3 - треугольни

color b = color(51); //текущий цвет
color b1 = color(255, 182, 193);
int color_shape = 2; // 0 - среда 1, 1 - зеркало, 2 - среда два, 3 - среда 3
int color_shape2 = 0; 
color color0 = color(100, 179, 64); //цвет среды 1
color color1 = color(255); //цвет зеркала
color color2 = color(51); //цвет среды 2
color color3 = color(77,89,214); //источник

ControlP5 cp0;
ControlP5 cp1;
ControlP5 cp2;

public void figure_0(int[][] c, int field_border, int k_x, int k_x_2, int k_y, int k_y_2, int color_shape)
{
  for(int i = k_x; i <= k_x_2; i++)
       for(int j = k_y; j <= k_y_2; j++)
          if(((mouseX-i)*(mouseX-i)+(mouseY-j)*(mouseY-j) )<= (shape_size/2)*(shape_size/2))
              c[i-(int)((width-W)/2)][j-field_border] = color_shape;
}

public void figure_1(int[][] c, int field_border, int k_x, int k_x_2, int k_y, int k_y_2, int color_shape)
{
  for(int i = k_x; i <= k_x_2; i++)
      for(int j = k_y; j <= k_y_2; j++)
          c[i-(int)((width-W)/2)][j-field_border] = color_shape;  
}

public void figure_2(int[][] c, int field_border, int k_x, int k_x_2, int k_y, int k_y_2, int color_shape)
{
  for(int i = k_x; i <= k_x_2; i++)
      for(int j = k_y; j <= k_y_2; j++)
         c[i-(int)((width-W)/2)][j-field_border] = color_shape; 
}

public void figure_3(int[][] c, int field_border, int k_x, int k_x_2, int k_y, int k_y_2, int color_shape)
{
   int xa = mouseX;
   int ya = mouseY - (int)sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2;
   int xb = mouseX - shape_size/2;
   int yb = mouseY + (int)sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2;
   int xc = mouseX + shape_size/2;
   int yc = mouseY + (int)sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2;
   for(int i = k_x; i <= k_x_2; i++)
     for(int j = k_y; j <= k_y_2; j++)
        if (f(xa,ya,xb,yb,xc,yc,i,j) && f(xb,yb,xc,yc,xa,ya,i,j) && f(xc,yc,xa,ya,xb,yb,i,j))
            c[i-(int)((width-W)/2)][j-field_border] = color_shape;
}

public void field_text(String k, int k_x, int k_y)
{
 cp0
    .addTextfield(k)
    .setPosition(k_x, k_y)
    .setSize(50, 20)
    .setAutoClear(false)
    .setInputFilter(2) 
    .setText("0");
}

public void mirror(String k, int k_x, int k_y)
{
  cp1.addToggle(k)
     .setPosition(k_x+22,k_y)
     .setSize(20,12)
     .setValue(true)
     .setMode(ControlP5.SWITCH);
}

double g(double xa, double ya, double xb, double yb, double xd, double yd) 
{
    return (xd - xa) * (yb - ya) - (yd - ya) * (xb - xa);
}
 
boolean f(double xa, double ya, double xb, double yb, double xc, double yc, double xd, double yd) 
{
    return g(xa, ya, xb, yb, xc, yc) * g(xa, ya, xb, yb, xd, yd) >= 0;
}

//проверка граничных условий
public boolean border(int field_border)
{
  return ((mouseX-shape_size/2) <= (int)((width-W)/2) || (mouseX-shape_size/4) <= (int)((width-W)/2) 
  || (mouseX+shape_size/2) >= ((int)((width-W)/2) + W) || (mouseX+shape_size/4) >= ((int)((width-W)/2) + W)
  ||(mouseY-shape_size/2)<=field_border || (mouseY+shape_size/2) >= (field_border+H) 
  || (mouseY - sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2) <=field_border && shape == 3 
  || ((mouseY+sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2) >= (field_border+H) && shape==3));
}

//создание кнопок второго типа(кнопки фигур)
public void second_type(int k_x, int k_y, int k, int type) //type - тип фигуры, которую будет изображать кнопка
{
  stroke(255); 
  fill(0);
  switch (type)
  {
   case 0:
          ellipse(k_x, k_y, k, k);
          break;
   case 1:
          rect(k_x, k_y, k, k);
          break;
   case 2:
          rect(k_x, k_y, k/2, k);
          break;
   case 3:
          triangle(k_x, k_y - sqrt(k*k-(k*k)/4)/2, k_x - k/2, k_y + sqrt(k*k-(k*k)/4)/2, k_x + k/2, k_y + sqrt(k*k-(k*k)/4)/2);
          break;
  }
}

void setup()
{
  size(670, 600);
  
  W = 600;
  H = 200;
  
  background(0);
  
  exclam = loadImage("exclam.png");
  
  frameRate(200);
  
  pg = createGraphics(W, H); //задаёт размер поля, по которому будут двигаться фигуры-курсоры (т.е. не определяет размер поля, на котором можно рисовать)
  pg1 = createGraphics(W, H);
  
  
  a = new int[W][H];
  c= new int[W][H];
  
  destField = new color[8];
  
  for (int i=0; i<(W); i++)
    for (int j =0; j<(H); j++)
      {
        a[i][j]=2;
        c[i][j]=0;
      }
      
  k_x = new int[8]; 
  k_y = new int[8]; 
  
  for(int i=0; i<3; i++)
    k_x[i] = (width-W)/2 + 20*i;
  
  k_x[3] = (width-W)/2 + 5;
  k_x[4] = (width-W)/2 + 25;
  k_x[5] = (width-W)/2 + 40;
  k_x[6] = (width-W)/2 + 62;
  k_x[7] = (width-W)/2 + 20*3;
  
  for(int i=0; i<3; i++)
    k_y[i] = (20);
  
   k_y[3] = (61 + H);
   k_y[4] = (60 + H);
   k_y[5] = (55 + H);
   k_y[6] = (55 + H);
   k_y[7] = 20;
   
   cp0 = new ControlP5(this);
   cp1 = new ControlP5(this);
   cp2 = new ControlP5(this);
   
   destField[0] = color(255, 182, 193);
   destField[1] = color(102, 205, 170);
   destField[2] = color(0, 255, 255);
   destField[3] = color(255, 255, 0);
   destField[4] = color(240, 230, 140);
   destField[5] = color(210, 105, 30);
   destField[6] = color(165, 42, 42);
   destField[7] = color(255, 228, 225);
   
   fill(51);
   noStroke();
   rect((int)((width-W)/2)+140, 50+10+10+H+5, 20, 10);
   
   fill(0);
   rect(0, 0, width, height);
   noStroke();
   
   stroke(255);
   fill(51);
   rect((int)((width-W)/2)+165, 50+10+10+H+5, 10, 19);
   
   /*stroke(255);
   fill(color0);
   rect((int)((width-W)/2)+355, 50+10+10+H+5, 10, 19);*/  
   
   //создаём кнопки "+" и "-". Первые две строки rect - плюс
   fill(255);
   rect((int)((width-W)/2) + W - 10, 25, 12, 2);
   rect((int)((width-W)/2) + W - 5, 20, 2, 12);
   rect((int)((width-W)/2) + W - 30, 25, 11, 2);
   
   fill(255);
   stroke(51);
   rect(k_x[0], k_y[0], 10, 19);
    
   second_type(k_x[3], k_y[3], 11, 3);
   second_type(k_x[4], k_y[4], 10, 0);
   second_type(k_x[5], k_y[5], 10, 1);
   second_type(k_x[6], k_y[6], 10, 2);
   
   fill(255);
   text("Clear", (int)((width-W)/2) + W - 32, (50+15+H));
   
   fill(255);
   text("mirror", k_x[0] + 20,  k_x[0] - 1);
   text("Clear", (int)((width-W)/2) + W - 32, 50+10+10+H+250+15);
   
   fill(255);
   
   //кнопки полей зеркала
   
    field_text("k0", (width-W)/2, 50+10+10+H+5);
    field_text("k+", (width-W)/2+55, 50+10+10+H+5);
    field_text("k-", (width-W)/2+110, 50+10+10+H+5);
    /*field_text("k0_1", (width-W)/2 + 190, 50+10+10+H+5);
    field_text("k+_1", (width-W)/2+55 + 190, 50+10+10+H+5);
    field_text("k-_1", (width-W)/2+110 + 190, 50+10+10+H+5);*/
    
  cp0
    .addTextfield("p" + fieldNum++)
    .setPosition((width-W)/2, 50+10+10+H+5 + 260)
    .setSize(50, 20)
    .setInputFilter(2)
    .setAutoClear(false)
    .setText("0");
    
  fieldColor();
  
  cp0
    .addButton("reloadSize")
    .setCaptionLabel("OK") 
    .setPosition(k_x[7] + 465, k_y[7]-7)
    .setSize(25, 20);
    
  cp0
    .addButton("addfield")
    .setCaptionLabel(" +") 
    .setPosition((width-600)/2 + 55, 50+10+10+200+5 + 260)
    .setSize(25, 20) ;
    
  cp0
    .addTextfield("width")
    .setPosition(k_x[7] + 350, k_y[7] - 7)
    .setSize(50, 20)
    .setInputFilter(1)
    .setAutoClear(false)
    .setText("600");
    
  cp0
    .addTextfield("height")
    .setPosition(k_x[7] + 400 + 5, k_y[7] - 7)
    .setSize(50, 20)
    .setInputFilter(1)
    .setAutoClear(false)
    .setText("200");
    
  cp0
    .addButton("removefield")
    .setCaptionLabel(" -") 
    .setPosition((width-W)/2 + 110 + 55 + 25 * fieldNum, 50+10+10+H+5 + 260)
    .setSize(25, 20)
    .setVisible(false);
  
  cp2
    .addButton("addColor")
    .setCaptionLabel(" +") 
    .setSize(25, 20)
    .setVisible(true)
    .setPosition((width-W)/2 + 180, 50+10+10+H+5);
    
  cp2
    .addButton("removeColor")
    .setCaptionLabel(" -") 
    .setSize(25, 20)
    .setVisible(false)
    .setPosition((width-W)/2 + 565, 50+10+10+H+5);
    
  cp0
    .addButton("submit")
    .setSize(60, 30)
    .setCaptionLabel(" save")
    .setPosition(W - 25, 2 * H + 150)
    .setVisible(true);
  
  cp0
    .addTextfield("caption")
    .setSize(300, 50)
    .setPosition((width-W)/2 - 20, 50+10+H - 60)
    .setText("           To maintain half-detailed balance enter equal values of K+ K-")
    .setCaptionLabel("")
    .setVisible(false)
    .lock();

    
  fill(255);
  pushMatrix();
  translate(30, 105);
  rotate(-HALF_PI);
  text("Geometry",0,0);
  popMatrix();
  
  pushMatrix();
  translate(30, 2*H - 38);
  rotate(-HALF_PI);
  text("Density",0,0);
  popMatrix();
  
  mirror("left b.",k_x[7]+30,k_y[7]);
  mirror("head b.",k_x[7]+90,k_y[7]);
  mirror("right b.",k_x[7]+150,k_y[7]);
  mirror("down b.",k_x[7]+210,k_y[7]);     
}

void addColor() {
  field_text("k0_" + ++colorNum, (width-600)/2 + 180 * colorNum + colorNum, 50+10+10+200+5);
  field_text("k+_" + colorNum, (width-600)/2+55 + 180 * colorNum + colorNum, 50+10+10+200+5);
  field_text("k-_" + colorNum, (width-600)/2+110 + 180 * colorNum + colorNum, 50+10+10+200+5);
  
  if (colorNum == 1) { 
    fill(color0);
    keyField0 = true;
  }
  else  {
    fill(color3);
    keyField = true;
  }
      
  stroke(255);
  
  rect((int)((width-600)/2)+ 176 + 170 * colorNum + (colorNum - 1) * 11, 50+10+10+200+5, 10, 19);
  
  fill(0);
  noStroke();
  rect((width-600)/2 + 180 * colorNum, 50+10+10+200+5, 51, 21);
  
  if (colorNum < 2) {
    cp2.get(Button.class, "addColor").setPosition((width-600)/2 + 180 * colorNum + 181 + (colorNum - 1), 50+10+10+200+5);
    cp2.get(Button.class, "removeColor").setPosition((width-600)/2 + 180 * colorNum + 206 + (colorNum - 1), 50+10+10+200+5).setVisible(true);
  }
  else {
    cp2.get(Button.class, "removeColor").setPosition((width-600)/2 + 180 * colorNum + 181 + (colorNum - 1), 50+10+10+200+5).setVisible(true);
    cp2.get(Button.class, "addColor").setPosition(width + 1, height + 1);
  }    
}

void removeColor() {
  colorNum--;
  if (colorNum == 0) { 
    fill(0);
    noStroke();
    rect((width-600)/2 + 180, 50+10+10+200+5, 400, 40);
    cp2.get(Button.class, "addColor").setPosition((width-600)/2 + 180, 50+10+10+200+5);
    cp2.get(Button.class, "removeColor").setPosition(width + 1, height + 1);
    keyField0 = false;
    
    b = color2;
    color_shape = 2;
    
    for(int i=0; i<W; i++)
      for(int j=0; j<H; j++)
        if(a[i][j] == 0)
          a[i][j] = 2;
  }
  
  else {
    
    fill(0);
    noStroke();
    rect((width-600)/2 + 360, 50+10+10+200+5, 400, 40);
    cp2.get(Button.class, "addColor").setPosition((width-600)/2 + 180 * colorNum + 181 + (colorNum - 1), 50+10+10+200+5);
    cp2.get(Button.class, "removeColor").setPosition((width-600)/2 + 180 * colorNum + 206 + (colorNum - 1), 50+10+10+200+5).setVisible(true);
    keyField = false;
    
    b = color2;
    color_shape = 2;
    
    for(int i=0; i<W; i++)
      for(int j=0; j<H; j++)
        if(a[i][j] == 3)
          a[i][j] = 2;
  }
  
  cp0.get(Textfield.class, "k0_" + (colorNum + 1)).remove();
  cp0.get(Textfield.class, "k+_" + (colorNum + 1)).remove();
  cp0.get(Textfield.class, "k-_" + (colorNum + 1)).remove();
  
}

void addfield() {
  
  if (fieldNum < 7) {
    
    cp0
      .addTextfield("p" + fieldNum++)
      .setPosition((width-600)/2 + 55 * (fieldNum - 1), 50+10+10+200+5 + 260)
      .setSize(50, 20)
      .setInputFilter(2)
      .setAutoClear(false)
      .setText("0");
      
    cp0.get(Button.class, "addfield").setPosition((width-600)/2 + 55 * (fieldNum), 50+10+10+200+5 + 260); 
    
      if (fieldNum > 1)
      
        cp0.get(Button.class, "removefield").setPosition((width-600)/2 + 55 * (fieldNum) + 25, 50+10+10+200+5 + 260).setVisible(true);
        
  }
   
  else 
    if (fieldNum == 7) {
      
      cp0
      .addTextfield("p"  + fieldNum++)
      .setPosition((width-600)/2 + 55 * (fieldNum - 1), 50+10+10+200+5 + 260)
      .setSize(50, 20)
      .setInputFilter(2)
      .setAutoClear(false)
      .setText("0");
      
      cp0.get(Button.class, "removefield").setPosition((width-600)/2 + 55 * (fieldNum), 50+10+10+200+5 + 260).setVisible(true);
    }
  
  fieldColor();
}

void reloadSize()
{   
    v = new int[W][H];
    
    W1 = Integer.parseInt(cp0.get(Textfield.class,"width").getText());
    H1 = Integer.parseInt(cp0.get(Textfield.class,"height").getText());
    
    if (W1 < 600 && H1 < 200 ) //<>//
    {
      if(W1 > H1)
      {
        W2 = 600;
        H2 = ((W2*H1)/W1) % 201 + 1;
        
      }
      else
      {
        H2 = 200;
        W2 = (W1*H2)/H1 % 601 + 1;
      }
    }
    else
    {
      if(W1 < 600)
      {
        W2 = W1;
        H2 = (W2*H1)/W1; 
        
        if(H2 > 200)
        {
          H2 = 200;
          W2 = (W1*H2)/H1;
          if(W2 < 200)
            W2 = 200;
        }
        else if(H2<100) H2 = 100;
        
      }
      else
      {
        W2 = 600;
        H2 = (W2*H1)/W1;
        
        if(H2 > 200)
        {
          H2 = 200;
          W2 = (W1*H2)/H1;
          if(W2 < 200)
            W2 = 200;
        }
        else if(H2<100) H2 = 100;
        
      }
    }
    
    
    for(int i=0; i < W; i++)
      for(int j=0; j < H; j++)
        v[i][j] = a[i][j];
        
    a = new int[W2][H2];
    
    for(int i = 0; i < W2; i++)
      for(int j =0; j < H2; j++)
        if(i<W && j<H) a[i][j] = v[i][j];
          else a[i][j] = 2;
    
    for(int i = 0; i < W; i++)
      for(int j =0; j < H; j++)
        v[i][j] = c[i][j];
    
    c = new int[W2][H2];
    
    for(int i = 0; i < W2; i++)
      for(int j =0; j < H2; j++)
        if(i<W && j<H) c[i][j] = v[i][j];
          else c[i][j] = 0;
     
    fill(0);
    noStroke();
    rect((width-W)/2, 50, 600, 200);
    rect((width-W)/2, 320, 600, 200);
     
     W = W2;
     H = H2;
     
     pg = createGraphics(W, H); 
     pg1 = createGraphics(W, H);
}

void removefield() {
  if (fieldNum > 0) {
    
    if(fieldNum-1 == color_shape2) 
    { 
      b1 = destField[0];
      color_shape2 = 0;  
    } //<>//
    
    for (int i = 0; i<W; i++)
        for(int j =0; j<H; j++)
            if(c[i][j] == fieldNum-1)
                c[i][j] = 0;
    
     fieldNum -= 1;
     cp0.get(Textfield.class, "p" + fieldNum).remove();
     
     fill(0);
     noStroke();
     rect((width-600)/2 + 55 * fieldNum - 1, 50+10+10+200+5 + 260, 52, 40);
     
     cp0.get(Button.class, "addfield").setPosition((width-600)/2 + 55 * (fieldNum), 50+10+10+200+5 + 260);
     
     if (fieldNum == 1)
       cp0.get(Button.class, "removefield").setPosition((width-600)/2 + 55 * (fieldNum) + 25, 50+10+10+200+5 + 260 + 500);
     else
       cp0.get(Button.class, "removefield").setPosition((width-600)/2 + 55 * (fieldNum) + 25, 50+10+10+200+5 + 260);
     
     fill(0);
     noStroke();
     rect((width-600)/2 + 55 * (fieldNum + 1), 50+10+10+200+5 + 260, 52, 40);
  }
}

void fieldColor() {
  fill(destField[fieldNum - 1]);
  noStroke();
  rect((width-600)/2 + 55 * (fieldNum - 1) + 12, 50+10+10+200+5 + 260 + 25, 15, 8);
}

void draw ()
{
   
  pg.beginDraw(); //начинаю рисовать двигающуюся фигуру-курсор
  pg.clear(); //очищаю поле курсора (чтобы не оставался след от предыдущего положения курсора)
  
  pg1.beginDraw();
  pg1.clear();
  
   switch (shape) //рисую сам курсор в зависимости от типа выбранной фигуры
  {
    case 0:
        if(mouseY >= 0 && mouseY <= 50+H)
        {
          pg.fill(b);
          pg.stroke(255);
          pg.ellipse(mouseX-(int)((width-W)/2), mouseY-50, shape_size, shape_size);
        }
        else
        {
          pg1.fill(b1);
          pg1.stroke(255);
          pg1.ellipse(mouseX-(int)((width-W)/2), mouseY-320, shape_size, shape_size);
        }
        break;
    case 1:
        if(mouseY >= 0 && mouseY <= 50+H)
        {
          pg.fill(b);
          pg.stroke(255);
          pg.rect(mouseX-(int)((width-W)/2)-shape_size/2, mouseY-50-shape_size/2, shape_size, shape_size);
        }
        else
        {
          pg1.fill(b1);
          pg1.stroke(255);
          pg1.rect(mouseX-(int)((width-W)/2)-shape_size/2, mouseY-320-shape_size/2, shape_size, shape_size);
        }
        break;
    case 2:
        if(mouseY >= 0 && mouseY <= 50+H)
        {
          pg.fill(b);
          pg.stroke(255);
          pg.rect(mouseX-(int)((width-W)/2)-shape_size/4, mouseY-50-shape_size/2, shape_size/2, shape_size);
        }
        else
        {
          pg1.fill(b1);
          pg1.stroke(255);
          pg1.rect(mouseX-(int)((width-W)/2)-shape_size/4, mouseY-320-shape_size/2, shape_size/2, shape_size);
        }
        break;
    case 3:
        if(mouseY >= 0 && mouseY <= 50+H)
        {
          pg.fill(b);
          pg.stroke(255);
          pg.triangle(mouseX-(int)((width-W)/2), mouseY - sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2-50, mouseX - shape_size/2-(int)((width-W)/2), mouseY + sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2-50, mouseX + shape_size/2-(int)((width-W)/2), mouseY + sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2-50);
        }
        else
        {
          pg1.fill(b1);
          pg1.stroke(255);
          pg1.triangle(mouseX-(int)((width-W)/2), mouseY - sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2-320, mouseX - shape_size/2-(int)((width-W)/2), mouseY + sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2-320, mouseX + shape_size/2-(int)((width-W)/2), mouseY + sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2-320);
        }
  }
  
  //рисую значения массива a
  for(int i=0; i<(W); i++)
    for(int j=0; j<(H); j++)
  {
    switch (a[i][j])
    {
      case 0:
              set(i+(int)((width-W)/2),j+50, color0);
              break;
      case 1:
              set(i+(int)((width-W)/2),j+50, color1);
              break;
      case 2:
              set(i+(int)((width-W)/2),j+50, color2);
              break;
      case 3:
              set(i+(int)((width-W)/2),j+50, color3);
              break;
    }
  }
  
  for(int i=0; i<(W); i++)
    for(int j=0; j<(H); j++)
  {
    switch (c[i][j])
    {
      case 0:
              set(i+(int)((width-W)/2),j+320, destField[0]);
              break;
      case 1:
              set(i+(int)((width-W)/2),j+320, destField[1]);
              break;
      case 2:
              set(i+(int)((width-W)/2),j+320, destField[2]);
              break;
      case 3:
              set(i+(int)((width-W)/2),j+320, destField[3]);
              break;
      case 4:
              set(i+(int)((width-W)/2),j+320, destField[4]);
              break;
      case 5:
              set(i+(int)((width-W)/2),j+320, destField[5]);
              break;
      case 6:
              set(i+(int)((width-W)/2),j+320, destField[6]);
              break;
      case 7:
              set(i+(int)((width-W)/2),j+320, destField[7]);
              break;
    }
  }
  
   if (!cp0.get(Textfield.class,"k-").getText().equals(cp0.get(Textfield.class,"k+").getText()) ||
      (keyField0 &&!cp0.get(Textfield.class,"k-_1").getText().equals(cp0.get(Textfield.class,"k+_1").getText())) ||
      (keyField && !cp0.get(Textfield.class,"k-_2").getText().equals(cp0.get(Textfield.class,"k+_2").getText()))) { 

    image(exclam, (width-600)/2 - 27, 50+10+10+200+7);
    
    if (mouseX >= (width-600)/2 - 27 && mouseX <= (width-600)/2 - 7 && mouseY >= 50+10+10+200+7 && mouseY <= 50+10+10+200+27)
       cp0.get(Textfield.class, "caption").setVisible(true);
       
    else {
      cp0.get(Textfield.class, "caption").setVisible(false);
      fill(0);
      noStroke();
      rect((width-600)/2 - 27, 50+10+100, 27, 100);
      
    }
  }
  else {
    fill(0);
    noStroke();
    rect((width-600)/2 - 25, 50+10+10+200+5, 20, 25);
  }
  
  if(mousePressed)
  {
    int field_border;
    int field_type;
  
    if(mouseY >= 0 && mouseY <= 50+H)
    {
      field_border = 50;
      field_type = 1;
    }
    else
    {
      field_border=320;
      field_type=2;
    }
    
     pushMatrix();    
  
        if(cp1.get(Toggle.class,"left b.").isMousePressed() == true)
      {
        if(cp1.get(Toggle.class,"left b.").getBooleanValue() == false)
        left = 1;
      else 
      {
        left = 0;
        for(int i = 0; i < 2; i++)
             for(int j = 2*head; j < H-2*down;j++)
               a[i][j] = 2;
      }
      }
      
       if(cp1.get(Toggle.class,"head b.").isMousePressed() == true)
      {
        if(cp1.get(Toggle.class,"head b.").getBooleanValue() == false)
        head = 1;
      else 
      {
        head = 0;
        for(int i = 2*left; i < W - 2*right; i++)
         for(int j =0; j < 2; j++)
           a[i][j] = 2;
      }
      }
      
      if(cp1.get(Toggle.class,"right b.").isMousePressed() == true)
      {
        if(cp1.get(Toggle.class,"right b.").getBooleanValue() == false)
        right = 1;
      else 
      {
        right = 0;
        for(int i = W - 2; i < W; i++)
         for(int j =2*head; j < H - 2*down; j++)
           a[i][j] = 2;
      }
      }
      
      if(cp1.get(Toggle.class,"down b.").isMousePressed() == true)
      {
        if(cp1.get(Toggle.class,"down b.").getBooleanValue() == false)
        down = 1;
      else 
      {
        down = 0;
        for(int i = 2*left; i < W - 2*right; i++)
         for(int j = H - 2; j < H; j++)
           a[i][j] = 2;
      }
      }
      
   popMatrix();
  
    if(mouseX >=(int)((width-W)/2) && mouseX <= ((int)((width-W)/2) + W) && mouseY >= field_border && mouseY <= (field_border+H))
    {
        //определяю границы, по которым будет осуществляться проверка на принадлежность фигуре
        int k_x,k_x_2;
        
        if (shape !=2)
        {
          k_x = mouseX-shape_size/2;
          k_x_2 = mouseX+shape_size/2;
        }
        else
        {
          k_x = mouseX-shape_size/4;
          k_x_2 = mouseX+shape_size/4;
        }
        
        int k_y = mouseY-shape_size/2;
        int k_y_2 = mouseY+shape_size/2;
        
        //смещаю границы, если фигура выходит за пределы поля
        if (border(field_border))
        {
        if ((mouseX-shape_size/2) <= (int)((width-W)/2) || ((mouseX-shape_size/4) <= (int)((width-W)/2))&&shape==2)
            k_x = (int)((width-W)/2);
        if ((mouseX+shape_size/2) >= ((int)((width-W)/2) + W) ||((mouseX+shape_size/4) >= ((int)((width-W)/2) + W))&&shape==2)
            k_x_2 = (int)((width-W)/2 + W)-1;
        if ((mouseY-shape_size/2)<=field_border || ((mouseY - sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2) <=field_border && shape == 3))
            k_y = field_border;
        if ((mouseY+shape_size/2) >= (field_border+H) || ((mouseY+sqrt(shape_size*shape_size-(shape_size*shape_size)/4)/2) >= (field_border+H) && shape==3))
            k_y_2 = (field_border+H)-1;
        }
        
        switch (shape)
          {case 0: 
                  if(field_type==1)
                  {
                   figure_0(a, field_border, k_x, k_x_2, k_y, k_y_2, color_shape);      
                  }
                  else
                  {
                    figure_0(c, field_border, k_x, k_x_2, k_y, k_y_2, color_shape2);  
                  }
                  break;
                 
           case 1:
                  if(field_type==1)
                  {
                   figure_1(a, field_border, k_x, k_x_2, k_y, k_y_2, color_shape);      
                  }
                  else
                  {
                    figure_1(c, field_border, k_x, k_x_2, k_y, k_y_2, color_shape2);  
                  }
                  break;
           case 2:
                  if(field_type==1)
                  {
                   figure_2(a, field_border, k_x, k_x_2, k_y, k_y_2,color_shape);      
                  }
                  else
                  {
                    figure_2(c, field_border, k_x, k_x_2, k_y, k_y_2,color_shape2);  
                  }
                  break;
           case 3:
                 if(field_type==1)
                  {
                   figure_3(a, field_border, k_x, k_x_2, k_y, k_y_2,color_shape);      
                  }
                  else
                  {
                   figure_3(c, field_border, k_x, k_x_2, k_y, k_y_2,color_shape2);  
                  }
                  break;
           }
       }
  }
       
       //зеркало - верх
       for(int i = 0; i < W*head; i++)
         for(int j =0; j < 2*head; j++)
           a[i][j] =1;
       
       //зеркало - лево
       for(int i = 0; i < 2*left; i++)
         for(int j = 2*head; j < H-2*down;j++)
           a[i][j] =1;
       
       //зеркало - право
       for(int i = W-right*2; i < W; i++)
         for(int j = 2*head; j < H-2*down;j++)
           a[i][j] =1;
       
       //зеркало - низ
       for(int i = 0; i < W*down; i++)
         for(int j = H-2*down; j < H; j++)
           a[i][j] =1;
           
         
       
       image(pg,(int)((width-W)/2), 50); //определяю координаты поля, по которому движется курсор-фигура
       pg.endDraw(); //заканчиваю рисовать поле перемещения курсора
       
       image(pg1,(int)((width-W)/2), 320); //определяю координаты поля, по которому движется курсор-фигура
       pg1.endDraw(); //заканчиваю рисовать поле перемещения курсора
           
}

void submit() { //<>//
  if (isEmptyField()) {
    matrix(
      Float.parseFloat(cp0.get(Textfield.class,"k0").getText()),
      Float.parseFloat(cp0.get(Textfield.class,"k+").getText()),
      Float.parseFloat(cp0.get(Textfield.class,"k-").getText()),
      0);
       
    if (keyField0)
       matrix(
         Float.parseFloat(cp0.get(Textfield.class,"k0_1").getText()),
         Float.parseFloat(cp0.get(Textfield.class,"k+_1").getText()),
         Float.parseFloat(cp0.get(Textfield.class,"k-_1").getText()),
         1);
         
    if (keyField)
       matrix(
         Float.parseFloat(cp0.get(Textfield.class,"k0_2").getText()),
         Float.parseFloat(cp0.get(Textfield.class,"k+_2").getText()),
         Float.parseFloat(cp0.get(Textfield.class,"k-_2").getText()),
         2);
       
    W1 =  Integer.parseInt(cp0.get(Textfield.class,"width").getText());
    H1 =  Integer.parseInt(cp0.get(Textfield.class,"height").getText());
     
    a1 = new int[W1][H1]; 
    c1 = new int[W1][H1];
     
    float k1 = (float)H/H1;
    float k2 = (float)W/W1;
     
    for(int i = 0; i < W1; i++)
      for(int j = 0; j < H1; j++)
        a1[i][j] = a[(int)(k2*i)][(int)(k1*j)];
         
    for(int i = 0; i < W1; i++)
      for(int j = 0; j < H1; j++)
        c1[i][j] = c[(int)(k2*i)][(int)(k1*j)];
         
    output = createWriter("matrixesA.txt"); //<>//
    for(int i = 0; i < H; i++) {
      for(int j = 0; j < W; j++)
         output.print(a[j][i]);
      output.println();
    }
    
    output.flush();
      
    output = createWriter("Geometry.txt");
     
    for(int i = 0; i < H1; i++) {
      for(int j = 0; j < W1; j++)
        output.print(a1[j][i] + " ");
      output.println();
    }
       
    output.flush();
      
    output = createWriter("matrixesC.txt");
    for(int i = 0; i < H; i++) {
      for(int j = 0; j < W; j++)
        output.print(c[j][i]);
      output.println();
    }
    
    output.flush();
      
    output = createWriter("Density.txt");
       for(int i = 0; i < H1; i++) {
         for(int j = 0; j < W1; j++) //<>//
           output.print(cp0.get(Textfield.class,"p" + c1[j][i]).getText() + " ");
         output.println();
       }
     
    output.flush();
    output.close();
    JOptionPane.showMessageDialog(null, "Матрицы сгенерированы");
  }
}

boolean isEmptyField() {
  if (cp0.get(Textfield.class,"k0").getText().equals("") ||
      cp0.get(Textfield.class,"k+").getText().equals("") ||
      cp0.get(Textfield.class,"k-").getText().equals("") )
     {
      JOptionPane.showMessageDialog(null, "Заполните все поля");
      return false;
     }
     
  if (keyField0)
    if (cp0.get(Textfield.class,"k+_1").getText().equals("") ||
        cp0.get(Textfield.class,"k-_1").getText().equals("") ||
        cp0.get(Textfield.class,"k0_1").getText().equals("")) 
      {
        JOptionPane.showMessageDialog(null, "Заполните все поля");
        return false;
      }  
     
  if (keyField)
    if (cp0.get(Textfield.class,"k+_2").getText().equals("") ||
        cp0.get(Textfield.class,"k-_2").getText().equals("") ||
        cp0.get(Textfield.class,"k0_2").getText().equals("")) 
      {
        JOptionPane.showMessageDialog(null, "Заполните все поля");
        return false;
      }
      
  if (cp0.get(Textfield.class,"height").getText().equals("") ||
      cp0.get(Textfield.class,"width").getText().equals(""))
      {
        JOptionPane.showMessageDialog(null, "Заполните все поля");
        return false;
      }
      
      
  return true;   
}

void mousePressed()
{
  //нажатие на первую слева кнопку цвета
  if(mouseX >= k_x[0] - 1 && mouseX<=(k_x[0]+11) && mouseY>=k_y[0] && mouseY<=(k_y[0]+20))
  {
    b = color1;
    color_shape=1;
  }
  //нажатие на вторую слева кнопку цвета
  if(mouseX >= (width-600)/2 + 164 && mouseX<=((width-600)/2 + 165 + 11) && mouseY>=50+10+10+200+4 && mouseY<=(50+10+10+200+5+20))
  { //<>//
    b = color2;
    color_shape=2;
  }
  //нажатие на третью слева кнопку цвета rect((int)((width-W)/2)+ 176 + 170 * colorNum + (colorNum - 1) * 11, 50+10+10+H+5, 10, 19);
  if(keyField0 && mouseX >= (width-600)/2+ 176 + 169 && mouseX<=((width-600)/2+ 176 + 169 + 11) && mouseY>=50+10+10+200+4 && mouseY<=(50+10+10+200+5+20))
  {
    b = color0;
    color_shape=0;
  }
  //нажатие на четвёртую слева кнопку цвета
  if(keyField && mouseX >= (width-600)/2+ 176 + 169 * 2 + 11 && mouseX<=((width-600)/2+ 176 + 169 * 2 + 11 + 11) && mouseY>=50+10+10+200+4 && mouseY<=(50+10+10+200+5+20)) {
    b = color3;
    color_shape=3;
  }   
  
  //нажатие на первую слева кнопку фигур
  if(mouseX >=k_x[0] && mouseX <= (k_x[0]+10) && mouseY >= (50+3+200) && mouseY <=(50+3+10+10+200))
  shape = 3;
  
  //на вторую слева кнопку фигур
  if(mouseX >=(k_x[0]+20) && mouseX <= (k_x[1]+10) && mouseY >= (50+3+200) && mouseY <=(50+10+10+200))
  shape = 0;
  
  //нажатие на третью слева кнопку фигур
  if(mouseX >=(k_x[0]+40) && mouseX <= (k_x[2]+10) && mouseY >= (50+3+200) && mouseY <=(50+10+10+200))
  shape = 1;
  
  if(mouseX >=(k_x[6]-4) && mouseX <= (k_x[6]+7) && mouseY >= (50+3+200) && mouseY <=(50+10+10+200))
  shape = 2;
  
  //нажатие на "+"
  if(mouseX >= ((int)((width-600)/2) + 600 - 10) && mouseX <= ((int)((width-600)/2) + 600) && mouseY>=k_y[0] && mouseY<=(k_y[0]+10))
  if (shape_size<100) shape_size+=5;
  
  //нажатие на "-"
  if(mouseX >= ((int)((width-600)/2) + 600 - 30) && mouseX <= ((int)((width-600)/2) + 600 - 20) && mouseY>=k_y[0] && mouseY<=(k_y[0]+10))
  if (shape_size>1) shape_size-=5;
  
  //нажатие на "clear"
  if(mouseX >= ((int)((width-600)/2) + 600 - 32) && mouseX <= ((int)((width-600)/2) + 600) && mouseY >= (50+3+200) && mouseY <=(50+10+10+200))
  for (int i=0; i<(W); i++)
    for (int j =0; j<(H); j++)
      a[i][j]=2; 
      
  //нажатие на "z"(W - 25, 2 * H + 150)
  //if (mouseX >= W - 26 && mouseX <= W - 26 + 61 && mouseY >= 2 * H + 149 && mouseY <= 2 * H + 149 + 31)
   // if (isEmptyField())
     // submit();
      
  if(mouseX >= (width-600)/2 + 12 && mouseX <= (width-600)/2 + 12 + 15  && mouseY >= (50+10+10+200+5+260+25) && mouseY <= 50+10+10+200+5+260+25+8)
    {
     b1 = destField[0];
     color_shape2=0;
    } 
  if(mouseX >= (width-600)/2 + 12 + 55 && mouseX <= (width-600)/2 + 12 + 15 + 55  && mouseY >= (50+10+10+200+5+260+25) && mouseY <= 50+10+10+200+5+260+25+8)
    {
     b1 = destField[1];
     color_shape2=1;    
    } 
  if(mouseX >= (width-600)/2 + 12 + 110 && mouseX <= (width-600)/2 + 12 + 15 + 110 && mouseY >= (50+10+10+200+5+260+25) && mouseY <= 50+10+10+200+5+260+25+8)
     {
     b1 = destField[2];
     color_shape2=2;    
    } 
    
  if(fieldNum > 3 && mouseX >= (width-600)/2 + 12 + 165 && mouseX <= (width-600)/2 + 12 + 15 + 165 && mouseY >= (50+10+10+200+5+260+25) && mouseY <= 50+10+10+200+5+260+25+8)
     {
       b1 = destField[3];
       color_shape2=3;    
    } 
    
   if(fieldNum > 4 && mouseX >= (width-600)/2 + 12 + 220 && mouseX <= (width-600)/2 + 12 + 15 + 220 && mouseY >= (50+10+10+200+5+260+25) && mouseY <= 50+10+10+200+5+260+25+8)
     {
       b1 = destField[4];
       color_shape2 = 4;    
    }
    
    if(fieldNum > 5 && mouseX >= (width-600)/2 + 12 + 275 && mouseX <= (width-600)/2 + 12 + 15 + 275 && mouseY >= (50+10+10+200+5+260+25) && mouseY <= 50+10+10+200+5+260+25+8)
     {
       b1 = destField[5];
       color_shape2 = 5;    
    }
    
    if(fieldNum > 6 && mouseX >= (width-600)/2 + 12 + 330 && mouseX <= (width-600)/2 + 12 + 15 + 330 && mouseY >= (50+10+10+200+5+260+25) && mouseY <= 50+10+10+200+5+260+25+8)
     {
       b1 = destField[6];
       color_shape2 = 6;    
    }
    
    if(fieldNum > 7 && mouseX >= (width-600)/2 + 12 + 385 && mouseX <= (width-600)/2 + 12 + 15 + 385 && mouseY >= (50+10+10+200+5+260+25) && mouseY <= 50+10+10+200+5+260+25+8)
     {
       b1 = destField[7];
       color_shape2 = 7;    
    }
    if(mouseX >= (int)((width-600)/2) + W - 32 && mouseX <= ((int)((width-600)/2) + W) && mouseY >= 50+10+10+200+250+7 && mouseY <= 50+10+10+200+250+15+6)
      {
        for (int i=0; i<(W); i++)
          for (int j =0; j<(H); j++)
            c[i][j]=0; 
      }
}

boolean massParticle(int i, int j) {
  int temp_i = 0, temp_j = 0, iter;
  for (iter = 0; iter < 4; iter++) {
    temp_i += (particles[iter] & i) >> iter;
    temp_j += (particles[iter] & j) >> iter;
  }
  temp_i += ((particles[iter] & i) >> iter) * 2; 
  temp_j += ((particles[iter] & j) >> iter) * 2; iter++;
  temp_i += ((particles[iter] & i) >> iter) * 4; 
  temp_j += ((particles[iter] & j) >> iter) * 4;
  return temp_j == temp_i;
}

boolean impParticle(int i, int j) {
  int pX_i, pY_i, pX_j, pY_j;
  pY_i = (i & particles[0]) - ((i & particles[2]) >> 2);
  pY_j = (j & particles[0]) - ((j & particles[2]) >> 2);
  pX_i = ((i & particles[1]) >> 1) - ((i & particles[3]) >> 3);
  pX_j = ((j & particles[1]) >> 1) - ((j & particles[3]) >> 3);
  return pY_i == pY_j && pX_i == pX_j;
}

int keyProb(int i, int j) {
  int temp_i, temp_j;
  temp_i = ((i & particles[4]) >> 4) * 2 + ((i & particles[5]) >> 5) * 4;
  temp_j = ((j & particles[4]) >> 4) * 2 + ((j & particles[5]) >> 5) * 4;
  if (i == j)
    return 2;
  if (temp_i > temp_j)
    return -1;
  else
    if (temp_i < temp_j)
      return 1;
  return 0;
}

void matrix(float k0, float k_plus, float k_min, int iter) {
  ArrayList[] matrixS = new ArrayList[matrixSize];
  ArrayList[] matrixP = new ArrayList[matrixSize];
  int[] count = new int[matrixSize];
  boolean[] check = new boolean[matrixSize];
  float temp, temp_0, temp_min, temp_plus; 
  int i, j;
  
  particles = new int[6];
  
  for (i = 0; i < 6; i++)
    particles[i] = 1 << i;
    
  for (i = 0; i < matrixSize; i++)
    check[i] = false;
      
  for (i = 0; i < matrixSize; i++) {
    count[i] = 0;
    matrixS[i] = new ArrayList();
    matrixP[i] = new ArrayList();
  }
  
  for (i = 0; i < matrixSize; i++) { // filling matS
    for (j= 0; j < matrixSize; j++) {
      if (impParticle(i, j) && massParticle(i, j)) {
          matrixS[i].add(j);
          count[i]++;
        }
    }
  }
  
  for (i = 0; i < matrixSize; i++) { // filling matP
    if (!check[i] && count[i] > 1) {
      switch (count[i]) {
      case 2:
      
        temp_min = k_min; temp_plus =  k_plus;
        check[i] = true; check[(int)matrixS[i].get(1)] = true;
        matrixP[i].add(1 - temp_plus);
        matrixP[i].add(temp_plus);
        matrixP[(int)matrixS[i].get(1)].add(temp_min);
        matrixP[(int)matrixS[i].get(1)].add(1 - temp_min);
        break;
  
      case 3:

        temp_min = k_min / 2; temp_plus = k_plus / 2; temp_0 = k0 / 2;
        check[i] = true; check[(int)matrixS[i].get(1)] = true; check[(int)matrixS[i].get(2)] = true;
        
        for (int k = 0; k < count[i]; k++) {
          for (j = 0; j < count[i]; j++) {
            temp = keyProb((int)matrixS[i].get(k), (int)matrixS[i].get(j));
            if (temp == 2)
              matrixP[(int)matrixS[i].get(k)].add(0);
            else
              if (temp == 0)
                matrixP[(int)matrixS[i].get(k)].add(temp_0);
              else
                if (temp == -1)
                  matrixP[(int)matrixS[i].get(k)].add(temp_min);
                else
                  if (temp == 1)
                    matrixP[(int)matrixS[i].get(k)].add(temp_plus);
          }
          
          temp = (float)matrixP[(int)matrixS[i].get(k)].get((k + 1) % 3) + (float)matrixP[(int)matrixS[i].get(k)].get((k + 2) % 3);
          matrixP[(int)matrixS[i].get(k)].set(k, 1 - temp); 
          
        }  
        break;

      case 4:

        temp_min = k_min / 3; temp_plus = k_plus / 3; temp_0 = k0 / 3;
        check[i] = true; check[(int)matrixS[i].get(1)] = true; check[(int)matrixS[i].get(2)] = true; check[(int)matrixS[i].get(3)] = true;
        
        for (int k = 0; k < count[i]; k++) {
          for (j = 0; j < count[i]; j++) {
            temp = keyProb((int)matrixS[i].get(k), (int)matrixS[i].get(j));
            if (temp == 2)
              matrixP[(int)matrixS[i].get(k)].add(0);
            else
              if (temp == 0)
                matrixP[(int)matrixS[i].get(k)].add(temp_0);
              else
                if (temp == -1)
                  matrixP[(int)matrixS[i].get(k)].add(temp_min);
                else
                  if (temp == 1)
                    matrixP[(int)matrixS[i].get(k)].add(temp_plus);
          }
          
          temp = (float)matrixP[(int)matrixS[i].get(k)].get((k + 1) % 4) + (float)matrixP[(int)matrixS[i].get(k)].get((k + 2) % 4) + (float)matrixP[(int)matrixS[i].get(k)].get((k + 3) % 4);
          matrixP[(int)matrixS[i].get(k)].set(k, 1 - temp); 
          
        }
        break;
      }
    }
  }
  
  output = createWriter("matrixes" + iter + ".txt");
  
  for (i = 0; i < matrixSize; i++) {
    //output.print(" " + i + " ");
    if (matrixP[i].size() == 0)
      output.print("0 ");
    for (j = 0; j < matrixP[i].size(); j++)
      output.print(matrixP[i].get(j) + " ");
    //output.println(" ");
  }  
  
  output.flush();
  output.close();
}
