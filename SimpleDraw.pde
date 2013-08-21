//SimpleDraw v1.0                
//April 2009 Seth Toles (www.sethtoles.com)

//Fill Method Adapted from Flood Fill by Mikkel Crone Koser (www.beyondthree.com)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int r = 0;                   //Fill Color
int g = 0;                     //
int b = 0;                     //
int pR = 0;                  //Stored Color
int pG = 0;                    //
int pB = 0;                    //
int tool = 0;                //0=Brush, 1=Line, 2=Rectangle, 3=Ellipse, 4=Fill
int function = 200;          //100=Clear, 101=ResetAspect, 102=StrokeToggle, 103=FillToggle, 104=SampleOff, 150-154 & 202-203=SampleOn for tools
int strokeR = 0;             //Stroke Color
int strokeG = 0;               //
int strokeB = 0;               //
int psR = 0;                 //Stored Stroke Color
int psG = 0;                   //
int psB = 0;                   //
int strokeSize = 1;          //Stroke Line Weight
int brushSize = 25;          //Brush Controls
int brushAspect = 50;          //
int brushWidth = 25;           //
int brushHeight = 25;          //
int fillAlpha = 255;         //Opacity of Filled Shapes
int strokeAlpha = 255;       //Opacity of Stroke Lines
int startX = 0;              //X and Y coordinates on click and release
int startY = 0;                //
int endX = 0;                  //
int endY = 0;                  //
int diffX;                   //Difference between two X values
int diffY;                   //Difference between two Y values
boolean filled = true;       //Determines whether a shape is filled
boolean stroked = true;      //Determines whether a shape has an outline
PFont Large;                 //The Large Font=Arial, size 15
PFont Small;                 //The Small Font=Arial, size 10


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--SETUP
void setup() {
  size(1000, 600);
  background(255);
  Large = loadFont("Arial-15.vlw");
  Small = loadFont("Arial-10.vlw");
  smooth();
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--SET START COORDIATES
void mousePressed(){
  startX=mouseX;
  startY=mouseY;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--SET END COORDINATES
void mouseReleased(){
  endX=mouseX;
  endY=mouseY;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--COORDINATE RESET
void reset(){
  startX=200;
  startY=0;
  endX=200;
  endY=0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--RECTANGLE STROKE
void rectStroke(int x,int y,int wide,int tall,int weightIn){
  fill(0,0);
  strokeWeight(weightIn);
  if (wide<0 && tall<0){
    rect(x+(wide-(float)weightIn/2),y+(tall-(float)weightIn/2),weightIn-wide-1,weightIn-tall-1);
  }
  else if (wide<0 && tall>0){
    rect(x+(wide-(float)weightIn/2),y-(float)weightIn/2,weightIn-1-wide,tall+weightIn-1);
  }
  else if (wide>0 && tall<0){
    rect(x-(float)weightIn/2,y+(tall-(float)weightIn/2),wide+weightIn-1,weightIn-1-tall);
  }
  else{
    rect((x-(float)weightIn/2)-.5,(y-(float)weightIn/2)-.5,wide+weightIn,tall+weightIn);
  }
  strokeWeight(weightIn);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--ELLIPSE STROKE
void ellipseStroke(int x,int y,int wide,int tall,int weightIn){
  fill(0,0);
  strokeWeight(weightIn);
  if (wide<0 && tall<0){
    ellipse(x+(wide-(float)weightIn/2),y+(tall-(float)weightIn/2),weightIn-wide-1,weightIn-tall-1);
  }
  else if (wide<0 && tall>0){
    ellipse(x+(wide-(float)weightIn/2),y-(float)weightIn/2,weightIn-1-wide,tall+weightIn-1);
  }
  else if (wide>0 && tall<0){
    ellipse(x-(float)weightIn/2,y+(tall-(float)weightIn/2),wide+weightIn-1,weightIn-1-tall);
  }
  else{
    ellipse((x-(float)weightIn/2)+.5,(y-(float)weightIn/2)+.5,wide+weightIn-.5,tall+weightIn-.5);
  }
  strokeWeight(weightIn);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--BUTTON
void button(int x,int y,int wide,int tall,int textX,int textY,String display,int activeID,int buttonID){
  stroke(0,255);
  strokeWeight(1);
  if (mouseX>=x && mouseX<=(x+wide) && mouseY>=y && mouseY<=(y+tall)){
    fill(200,255);
  }
  else {
    fill(160,255);
  }
  if (tool==activeID || function==activeID){
    fill(255,255);
  }
  rect(x,y,wide,tall);
  fill(0,255);
  textFont(Small,10);
  text(display,x+textX,y+textY);

  if (startX>=x && startX<=(x+wide) && startY>=y && startY<=(y+tall)){
    if (buttonID<100){
      tool=buttonID;
    }
    else {
      function=buttonID;
    }
    reset();
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--SLIDER 
int slider(int x,int y,float wide,float range,int lowest,int out,int sliderR,int sliderG,int sliderB){
  float conversion=(wide/range);

  strokeWeight(8);
  stroke(64,255);
  line(x,y,x+wide,y);
  strokeWeight(1);
  stroke(0,255);
  fill(sliderR,sliderG,sliderB,255);

  if (startX<x || startX>(x+wide) || startY<(y-5) || startY>(y+5)){
    if (out!=1){
      ellipse(round(out*conversion)+x,y,10,10);
    }
    else {
      ellipse(x,y,10,10);
    }
  }

  if (startX>=x && startX<=(x+wide)){
    if (startY>=(y-5) && startY<=(y+5)){
      if (mousePressed){
        function=200;
        if (mouseX>=x && mouseX<=(x+wide)){
          ellipse(mouseX,y,10,10);
          out=round((mouseX-x)/conversion);
          if (out<lowest){
            out=lowest;
          }
        }
        else if (mouseX<x){
          ellipse(x,y,10,10);
          out=lowest;
        }
        else {
          ellipse(x+wide,y,10,10);
          out=round(range);
        }
      }
      else {
        if (endX>=x && endX<=(x+wide)){
          ellipse(endX,y,10,10);
          out=round((endX-x)/conversion);
        }
        else if (endX<x){
          ellipse(x,y,10,10);
          out=lowest;
        }
        else {
          ellipse((x+wide),y,10,10);
          out=round(range);
        }
      }
    }
  }
  return out;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--FILL AREA
void fillArea(int x,int y,color testColor,color rgb){ 
  int pixelQueue[] = new int[480000]; 
  int pixelQueueSize = 0; 
  
  pixelQueue[0] = (y << 16) + x; 
  pixelQueueSize = 1; 

  set(x,y,rgb); 
  while (pixelQueueSize > 0){ 
    x = pixelQueue[0] & 0xffff; 
    y = (pixelQueue[0] >> 16) & 0xffff; 
    pixelQueueSize--; 
    pixelQueue[0] = pixelQueue[pixelQueueSize]; 
    
    if (x>200){ 
      if ((get(x-1,y)==testColor) && (get(x-1, y)!=rgb)){ 
        set(x-1,y,rgb); 
        pixelQueue[pixelQueueSize] = (y << 16)+x-1; 
        pixelQueueSize++; 
      } 
    }
    if (y>0){ 
      if ((get(x,y-1)==testColor) && (get(x,y-1) != rgb)){ 
        set(x,y-1,rgb); 
        pixelQueue[pixelQueueSize] = ((y-1) << 16)+x; 
        pixelQueueSize++; 
      } 
    } 
    if (x<1000){ 
      if ((get(x+1,y)==testColor) && (get(x+1,y) != rgb)){ 
        set(x+1,y,rgb); 
        pixelQueue[pixelQueueSize] = (y << 16)+x+1; 
        pixelQueueSize++; 
      } 
    } 
    if (y<600){ 
      if ((get(x,y+1)==testColor) && (get(x,y+1) != rgb)){ 
        set(x,y+1,rgb); 
        pixelQueue[pixelQueueSize] = ((y+1) << 16)+x; 
        pixelQueueSize++; 
      } 
    } 
  } 
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--DRAW
void draw(){
  ////////////////////////////////////////////////////////////////////////////////////////Menu Background
  fill(128,255);
  noStroke();
  rect(0,0,200,600);
  stroke(0,255);
  strokeWeight(2);
  line(200,0,200,600);


  ////////////////////////////////////////////////////////////////////////////////////////Tool Set
  strokeWeight(1);
  fill(160,255);
  button(15,15,80,30,30,20,"Brush",0,0);          //Brush Button
  button(105,15,80,30,30,20,"Line",1,1);          //Line Button
  button(15,55,80,30,30,20,"Rectangle",2,2);      //Rectangle Button
  button(105,55,80,30,30,20,"Ellipse",3,3);       //Ellipse Button
  button(15,95,80,30,30,20,"Fill Area",4,4);      //Fill Area Button
  button(105,95,80,30,30,20,"Clear All",100,100); //Clear All Button
  if (function==100){                               //
    noStroke();                                     //
    fill(255,255);                                  //
    rect(200,0,1000,600);                           //
    r=pR;                                           //
    g=pG;                                           //
    b=pB;                                           //
    function=200;                                   //
  }                                                 //
  fill(255,255);                                  //--Line--
  strokeWeight(2);                                  //
  line(0,140,200,140);                              //
  textFont(Small,10);                             //Preview Box
  rect(4,475,190,120);                              //
  fill(192,255);                                    //
  noStroke();                                       //
  rect(6,535,187,59);                               //
  fill(0,255);                                      //
  text("Preview",8,486);                            //


  ////////////////////////////////////////////////////////////////////////////////////////Tool Icons
  strokeWeight(1);                                //Brush Icon
  stroke(0,255);                                    //
  line(37,21,30,33);                                //
  line(36,21,28,32);                                //
  line(28,37,23,39);                                //
  strokeWeight(2);                                  //
  line(25,36,23,39);                                //
  line(29,32,28,34);                                //
  strokeWeight(1);                                  //
  fill(255,0);                                      //
  ellipse(27,35,4,4);                               //
  fill(0,255);                                      //
  line(115,38,127,22);                            //Line Icon
  noFill();                                       //Rectangle Icon
  rect(23,62,12,16);                                //
  ellipse(121,70,12,16);                          //Ellipse Icon
  ellipse(30,110,16,16);                          //Fill Area Icon
  fill(80,255);                                     //
  arc(30,110,16,16,-PI/4,.75*PI);                   //
  line(22,118,38,102);                              //
  line(114,100,124,100);                          //Clear All Icon
  line(110,104,110,120);                            //
  line(124,100,124,110);                            //
  line(110,120,124,120);                            //
  line(114,100,110,104);                            //
  line(114,100,114,104);                            //
  line(110,104,114,104);                            //
  line(116,116,126,116);                            //
  line(130,112,126,116);                            //
  line(124,120,124,116);                            //
  strokeWeight(2);                                  //
  line(120,112,129,112);                            //
  line(120,112,116,115);                            //
  
  

  ////////////////////////////////////////////////////////////////////////////////////////Color Sampler
  if (function==106){
    reset();  
    function=200;
  }
  if (function>=104 && function<=203 && function!=200){                                            
    if (mouseX>202){
      if (tool==function-150){
        r=round(red(get(mouseX,mouseY)));
        g=round(green(get(mouseX,mouseY)));
        b=round(blue(get(mouseX,mouseY)));
      }
      else{
        strokeR=round(red(get(mouseX,mouseY)));
        strokeG=round(green(get(mouseX,mouseY)));
        strokeB=round(blue(get(mouseX,mouseY)));
      }
    }
    if (function==104 || function==105 || ((tool!=function-150) && (tool!=function-200))){
        strokeR=psR;
        strokeG=psG;
        strokeB=psB;
        r=pR;
        g=pG;
        b=pB;
      function=106;
    }
    if (endX>202){
      function=106;
    }
  }
  else{
    pR=r;
    pG=g;
    pB=b;
    psR=strokeR;
    psG=strokeG;
    psB=strokeB;
  }


  ////////////////////////////////////////////////////////////////////////////////////////Brush Tool
  if (tool==0){
    fill(0,255);                                                       //Menu Text
    textFont(Large,15);                                                  //
    text("Brush",5,160);                                                 //
                                                                         //
    textFont(Small,10);                                                  //
    text("Size",5,180);                                                  //
    text("Aspect",5,200);                                                //

    if (brushAspect!=50){                                              //Reset Aspect Button
      button(118,147,70,15,5,12,"Reset Aspect",100,101);                 //
      if (function==101){                                                //
        brushAspect=50;                                                  //
        function=200;                                                    //
      }                                                                  //
    }                                                                    //
    
    if (function==150){                                                //Sample Color Button
      button(5,270,80,20,24,15,"Cancel",150,105);                        //
    }                                                                    //
    else{                                                                //
      button(5,270,80,20,9,15,"Sample Color",100,150);                   //
    }                                                                    //

    brushSize=slider(50,176,135,100,1,brushSize,255,255,255);          //Brush Size Slider                                        
    brushAspect=slider(50,196,135,100,1,brushAspect,255,255,255);      //Brush Aspect Slider

    r=slider(10,216,175,255,0,r,255,0,0);                              //Red Slider
    g=slider(10,236,175,255,0,g,0,255,0);                              //Green Slider
    b=slider(10,256,175,255,0,b,0,0,255);                              //Blue Slider

    if (brushAspect<50){                                               //Brush Aspect Calculator
        brushHeight=round(((float)brushSize/50)*brushAspect);            //
        if (brushHeight==0){                                             //
          brushHeight=1;                                                 //
        }                                                                //
        brushWidth=brushSize;                                            //
      }                                                                  //
      else if (brushAspect>50){                                          //
        brushWidth=round(brushSize-((float)brushSize/50)*((float)brushAspect-50));
        if (brushWidth==0){                                              //
          brushWidth=1;                                                  //
        }                                                                //
        brushHeight=brushSize;                                           //
      }                                                                  //
      else {                                                             //
        brushWidth=brushSize;                                            //
        brushHeight=brushSize;                                           //
      }                                                                  //

    noStroke();                                                        //Brush Preview
    fill(r,g,b,255);                                                     //
    ellipse(100,535,brushWidth,brushHeight);                             //

    if (startX>200){                                                   //Draw Brush
      if (function!=150){                                                //
        if (mousePressed){                                               //
          if (mouseX>200){                                               //
            diffX=pmouseX-mouseX;                                        //
            diffY=pmouseY-mouseY;                                        //
            if (abs(diffX)>abs(diffY)){                                  //
              if (mouseX>pmouseX){                                       //
                for (int i=0;i<=abs(diffX);i++){                         //
                  ellipse(pmouseX+i,pmouseY+round(((float)diffY/(float)diffX)*i),brushWidth,brushHeight);
                }                                                        //
              }                                                          //
              else {                                                     //
                for (int i=0;i<=abs(diffX);i++){                         //
                  fill(r,g,b,fillAlpha);                                 //
                  ellipse(mouseX+i,mouseY+round(((float)diffY/(float)diffX)*i),brushWidth,brushHeight);
                }                                                        //
              }                                                          //
            }                                                            //
            else {                                                       //
              if (mouseY>pmouseY){                                       //
                for (int i=0;i<=abs(diffY);i++){                         //
                  fill(r,g,b,fillAlpha);                                 //
                  ellipse(pmouseX+round(((float)diffX/(float)diffY)*i),pmouseY+i,brushWidth,brushHeight);
                }                                                        //
              }                                                          //
              else {                                                     //
                for (int i=0;i<=abs(diffY);i++){                         //
                  fill(r,g,b,fillAlpha);                                 //
                  ellipse(mouseX+round(((float)diffX/(float)diffY)*i),mouseY+i,brushWidth,brushHeight);
                }                                                        //
              }                                                          //
            }                                                            //
          }                                                              //
        }                                                                //
      }                                                                  //
    }                                                                    //
  }                                                    


  ////////////////////////////////////////////////////////////////////////////////////////Line Tool
  if (tool==1){
    fill(0,255);                                                       //Menu Text
    textFont(Large,15);                                                  //
    text("Line",5,160);                                                  //
                                                                         //
    textFont(Small,10);                                                  //
    text("Size",5,180);                                                  //
    text("Opacity",5,200);                                               //
    
    if (function==201){                                                //Sample Color Button
      button(5,270,80,20,24,15,"Cancel",201,104);                        //
    }                                                                    //
    else{                                                                //
      button(5,270,80,20,9,15,"Sample Color",100,201);                   //
    }                                                                    //

    strokeSize=slider(50,176,135,25,1,strokeSize,255,255,255);         //Line Size Slider                                        
    strokeAlpha=slider(50,196,135,255,1,strokeAlpha,255,255,255);      //Line Alpha Slider
    //
    strokeR=slider(10,216,175,255,0,strokeR,255,0,0);                  //Stroke-Red Slider
    strokeG=slider(10,236,175,255,0,strokeG,0,255,0);                  //Stroke-Green Slider
    strokeB=slider(10,256,175,255,0,strokeB,0,0,255);                  //Stroke-Blue Slider

    stroke(strokeR,strokeG,strokeB,strokeAlpha);                       //Line Preview
    strokeWeight(strokeSize);                                            //
    line(30,535,170,535);                                                //

    if (startX>200){                                                   //Draw Line
      if (function!=151){                                                //
        if (!mousePressed){                                              //
          strokeWeight(strokeSize);                                      //
          stroke(strokeR,strokeG,strokeB,strokeAlpha);                   //
          line(startX,startY,endX,endY);                                 //
          reset();                                                       //
        }                                                                //
      }                                                                  //
    }                                                                    //
  }


  ////////////////////////////////////////////////////////////////////////////////////////Rectangle Tool
  if (tool==2){
    fill(0,255);                                                       //Menu Text
    textFont(Large,15);                                                  //
    text("Outline",5,160);                                               //
    text("Fill",5,315);                                                  //
                                                                         //
    textFont(Small,10);                                                  //
    text("Size",5,180);                                                  //
    text("Outlined:",128,159);                                           //
    text("Opacity",5,200);                                               //
    text("Filled:",142,314);                                             //
    text("Opacity",5,335);                                               //
    
    
    line(0,297,200,297);                                               //Stroke/Fill Divider
    
    if (function==202){                                                //Sample Stroke Color Button
      button(5,270,80,20,24,15,"Cancel",202,104);                        //
    }                                                                    //
    else{                                                                //
      button(5,270,80,20,9,15,"Sample Color",100,202);                   //
    }                                                                    //
    
    if (function==152){                                                //Sample Fill Color Button
      button(5,405,80,20,24,15,"Cancel",152,105);                        //
    }                                                                    //
    else{                                                                //
      button(5,405,80,20,9,15,"Sample Color",100,152);                   //
    }                                                                    //

    strokeSize=slider(50,176,135,25,1,strokeSize,255,255,255);         //Outline Size Slider                                        
    strokeAlpha=slider(50,196,135,255,1,strokeAlpha,255,255,255);      //Outline Alpha Slider

    strokeR=slider(10,216,175,255,0,strokeR,255,0,0);                  //Outline-Red Slider
    strokeG=slider(10,236,175,255,0,strokeG,0,255,0);                  //Outline-Green Slider
    strokeB=slider(10,256,175,255,0,strokeB,0,0,255);                  //Outline-Blue Slider
                                           
    fillAlpha=slider(50,331,135,255,1,fillAlpha,255,255,255);          //Fill Alpha Slider

    r=slider(10,351,175,255,0,r,255,0,0);                              //Fill-Red Slider
    g=slider(10,371,175,255,0,g,0,255,0);                              //Fill-Green Slider
    b=slider(10,391,175,255,0,b,0,0,255);                              //Fill-Blue Slider
    
    if (stroked){                                                      //Disable/Enable Outline Button
      button(173,147,15,15,4,12,"X",100,102);                            //
      if (function==102){                                                //
        stroked=false;                                                   //
        if (!filled){                                                    //
          filled=true;                                                   //
        }                                                                //
        function=200;                                                    //
      }                                                                  //
    }                                                                    //
    else {                                                               //
      button(173,147,15,15,4,12," ",100,102);                            //
      if (function==102){                                                //
        stroked=true;                                                    //
        function=200;                                                    //
      }                                                                  //
    }                                                                    //
    
    if (filled){                                                       //Disable/Enable Fill Button
      button(173,302,15,15,4,12,"X",100,103);                            //
      if (function==103){                                                //
        filled=false;                                                    //
        if (!stroked){                                                   //
          stroked=true;                                                  //
        }                                                                //
        function=200;                                                    //
      }                                                                  //
    }                                                                    //
    else {                                                               //
      button(173,302,15,15,4,12," ",100,103);                            //
      if (function==103){                                                //
        filled=true;                                                     //
        function=200;                                                    //
      }                                                                  //
    }                                                                    //

    if (stroked){                                                      //Rectangle Preview
      strokeWeight(strokeSize);                                          //
      stroke(strokeR,strokeG,strokeB,strokeAlpha);                       //
    }                                                                    //
    else {                                                               //
      noStroke();                                                        //
    }                                                                    //
    if (filled){                                                         //
      rectStroke(60,512,80,50,strokeSize);                               //
      fill(r,g,b,fillAlpha);                                             //
      noStroke();                                                        //
      rect(60,512,80,50);                                                //
    }                                                                    //
    else {                                                               //
      noFill();                                                          //
      rectStroke(60,512,80,50,strokeSize);                               //
    }                                                                    //

    if (startX>200){                                                   //Draw Rectangle
      if (!mousePressed){                                                //
        if (function!=152 && function!= 106 && function!=202){           //
          diffX=endX-startX;                                             //
          diffY=endY-startY;                                             //
          if (stroked){                                                  //
            strokeWeight(strokeSize);                                    //
            stroke(strokeR,strokeG,strokeB,strokeAlpha);                 //
          }                                                              //
          else {                                                         //
            noStroke();                                                  //
          }                                                              //
          if (filled){                                                   //
            rectStroke(startX,startY,diffX,diffY,strokeSize);            //
            fill(r,g,b,fillAlpha);                                       //
            noStroke();                                                  //
            rect(startX,startY,diffX,diffY);                             //
          }                                                              //
          else {                                                         //
            noFill();                                                    //
            rectStroke(startX,startY,diffX,diffY,strokeSize);            //
          }                                                              //
          reset();                                                       //
        }                                                                //
      }                                                                  //
    }                                                                    //
  }
  
  
  ////////////////////////////////////////////////////////////////////////////////////////Ellipse Tool
  if (tool==3){
    fill(0,255);                                                       //Menu Text
    textFont(Large,15);                                                  //
    text("Outline",5,160);                                               //
    text("Fill",5,315);                                                  //
                                                                         //
    textFont(Small,10);                                                  //
    text("Size",5,180);                                                  //
    text("Outlined:",128,159);                                           //
    text("Opacity",5,200);                                               //
    text("Filled:",142,314);                                             //
    text("Opacity",5,335);                                               //
    
    line(0,297,200,297);                                               //Stroke/Fill Divider
    
    if (function==203){                                                //Sample Stroke Color Button
      button(5,270,80,20,24,15,"Cancel",203,104);                        //
    }                                                                    //
    else{                                                                //
      button(5,270,80,20,9,15,"Sample Color",100,203);                   //
    }                                                                    //
    
    if (function==153){                                                //Sample Fill Color Button
      button(5,405,80,20,24,15,"Cancel",153,105);                        //
    }                                                                    //
    else{                                                                //
      button(5,405,80,20,9,15,"Sample Color",100,153);                   //
    }                                                                    //

    strokeSize=slider(50,176,135,25,1,strokeSize,255,255,255);         //Outline Size Slider                                        
    strokeAlpha=slider(50,196,135,255,1,strokeAlpha,255,255,255);      //Outline Alpha Slider

    strokeR=slider(10,216,175,255,0,strokeR,255,0,0);                  //Stroke-Red Slider
    strokeG=slider(10,236,175,255,0,strokeG,0,255,0);                  //Stroke-Green Slider
    strokeB=slider(10,256,175,255,0,strokeB,0,0,255);                  //Stroke-Blue Slider
    
    fillAlpha=slider(50,331,135,255,1,fillAlpha,255,255,255);          //Fill Alpha Slider

    r=slider(10,351,175,255,0,r,255,0,0);                              //Fill-Red Slider
    g=slider(10,371,175,255,0,g,0,255,0);                              //Fill-Green Slider
    b=slider(10,391,175,255,0,b,0,0,255);                              //Fill-Blue Slider

    if (stroked){                                                      //Disable/Enable Outline Button
      button(173,147,15,15,4,12,"X",100,102);                            //
      if (function==102){                                                //
        stroked=false;                                                   //
        if (!filled){                                                    //
          filled=true;                                                   //
        }                                                                //
        function=200;                                                    //
      }                                                                  //
    }                                                                    //
    else {                                                               //
      button(173,147,15,15,4,12," ",100,102);                            //
      if (function==102){                                                //
        stroked=true;                                                    //
        function=200;                                                    //
      }                                                                  //
    }                                                                    //
    
    if (filled){                                                       //Disable/Enable Fill Button
      button(173,302,15,15,4,12,"X",100,103);                            //
      if (function==103){                                                //
        filled=false;                                                    //
        if (!stroked){                                                   //
          stroked=true;                                                  //
        }                                                                //
        function=200;                                                    //
      }                                                                  //
    }                                                                    //
    else {                                                               //
      button(173,302,15,15,4,12," ",100,103);                            //
      if (function==103){                                                //
        filled=true;                                                     //
        function=200;                                                    //
      }                                                                  //
    }                                                                    //

    ellipseMode(CORNER);                                               //Ellipse Preview
    if (stroked){                                                        //
      strokeWeight(strokeSize);                                          //
      stroke(strokeR,strokeG,strokeB,strokeAlpha);                       //
    }                                                                    //
    else {                                                               //
      noStroke();                                                        //
    }                                                                    //
    if (filled){                                                         //
      ellipseStroke(60,512,80,50,strokeSize);                            //
      fill(r,g,b,fillAlpha);                                             //
      noStroke();                                                        //
      ellipse(60,512,80,50);                                             //
    }                                                                    //
    else {                                                               //
      noFill();                                                          //
      ellipseStroke(60,512,80,50,strokeSize);                            //
    }                                                                    //

    if (startX>200){                                                   //Draw Ellipse
      if (!mousePressed){                                                //
        if (function!=153 && function!=106 && function!=203){           //
          diffX=endX-startX;                                             //
          diffY=endY-startY;                                             //
          if (stroked){                                                  //
            strokeWeight(strokeSize);                                    //
            stroke(strokeR,strokeG,strokeB,strokeAlpha);                 //
          }                                                              //
          else {                                                         //
            noStroke();                                                  //
          }                                                              //
          if (filled){                                                   //
            ellipseStroke(startX,startY,diffX,diffY,strokeSize);         //
            fill(r,g,b,fillAlpha);                                       //
            noStroke();                                                  //
            ellipse(startX,startY,diffX,diffY);                          //
          }                                                              //
          else {                                                         //
            noFill();                                                    //
            ellipseStroke(startX,startY,diffX,diffY,strokeSize);         //
          }                                                              //
          reset();                                                       //
        }                                                                //
      }                                                                  //
    }                                                                    //
    ellipseMode(CENTER);                                                 //
  }
  
  
  ////////////////////////////////////////////////////////////////////////////////////////Fill Area Tool
  if (tool==4){
    fill(0,255);                                                       //Menu Text
    textFont(Large,15);                                                  //
    text("Fill Area",5,160);                                             //
    
    if (function==150){                                                //Sample Color Button
      button(5,230,80,20,24,15,"Cancel",154,105);                        //
    }                                                                    //
    else{                                                                //
      button(5,230,80,20,9,15,"Sample Color",100,154);                   //
    }                                                                    //
    
    r=slider(10,176,175,255,0,r,255,0,0);                              //Red Slider
    g=slider(10,196,175,255,0,g,0,255,0);                              //Green Slider
    b=slider(10,216,175,255,0,b,0,0,255);                              //Blue Slider
    
    noStroke();                                                        //Fill Area Preview
    fill(r,g,b,255);                                                     //
    rect(80,515,40,40);                                                  //
    
    if (startX>200){                                                   //Fill Area
      if (function!=150){                                                //
        if (!mousePressed){                                              //
          if (mouseX>200){                                               //
            color testColor=get(endX,endY);                              //
            color rgb=color(r,g,b);                                      //
            if (testColor!=rgb){                                         //
              set(endX,endY,rgb);                                        //
              fillArea(endX,endY,testColor,rgb);                         //
            }                                                            //
          }                                                              //
        }                                                                //
      }                                                                  //
    }                                                                    //
  }
}
