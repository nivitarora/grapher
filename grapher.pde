/*Program: grapher.pde
  Author:  Nivita Arora
  Date:    11/30/14
  Notes:   zoom doesn't work that well
*/

int xLine = 0;
int yLine = 0;
float aGrid;
float hGrid;
float kGrid;
float bGrid;
float cGrid;
float xPointGraph1;
float yPointGraph1;
float xPointGrid1;
float yPointGrid1;
float xPointGraph2;
float yPointGraph2;
float xPointGrid2;
float yPointGrid2;
float xGrid;
float yGrid;
String hSign;
String kSign;
String bSign;
String cSign;
float root1;
float root2;
PrintWriter output;
PImage graph;
float slope;
float xPointSlope;
float yPointSlope;
boolean flat;
int a;
int number;
PImage img;

void setup() {
  size(750, 500);
  drawGrid();
}//setup()

void drawGrid() {
  background(0, 0, 50);
  stroke(0, 214, 187);
  xLine = yLine = 0;
  for (int i = 0; i < 20; i++) {
    xLine += 25;
    yLine += 25;
    if (xLine == 250) {
      strokeWeight(3);
      //arrows
      line(xLine, 0, xLine-10, 10);
      line(xLine, 0, xLine+10, 10);
      line(500, yLine, 490, yLine-10);
      line(500, yLine, 490, yLine+10);
      //x and y labels
      fill(193, 242, 236);
      textSize(16);
      text("x", 475, 240);
      text("y", 240, 25);
    }//axes
    else {
      strokeWeight(1);
    }//non-axes grid lines
    line(xLine, 0, xLine, 500);
    line(0, yLine, 500, yLine);
  }//grid lines
  //origin mark
  noStroke();
  fill(193, 242, 236);
  ellipse(250, 250, 10, 10);
  //scale marks
  stroke(0, 214, 187);
  strokeWeight(3);
  for(int i = 0; i < 500; i+=125) {
    line(i, 245, i, 255);
    line(245, 500-i, 255, 500-i);
  }//hash marks at 5th intervals
  textSize(12);
  text(10, 375, 265);
  text(10, 230, 124);
  //zoom buttons
  fill(0, 222, 142);
  text("zoom", 620, 440);
  rect(600, 450, 25, 25);
  rect(650, 450, 25, 25);
  fill(0);
  textSize(24);
  text("+", 603, 469);
  text("-", 655, 469);
  textSize(12);
}//drawGrid()

void draw(){
  //allows mouseClicked() to work
}//draw()

void mouseClicked() {
  xGrid = (mouseX-250.0)*2.0/25.0;
  yGrid = (-mouseY+250.0)*2.0/25.0;
  if (mouseButton == LEFT || mouseButton == RIGHT) {
    if ((450 < mouseY && mouseY < 475) && ((600 < mouseX && mouseX < 625) || (650 < mouseX && mouseX < 675))) {
      zoom();
    }
    else {
      drawGrid();
    }
    output = createWriter("data/info.txt");
    if (xGrid <= 20){
      axisOfSymmetry();
      graphEquation();
      drawGraph();
      findRoots();
      asciiGraph();
    }//only draw graph if clicked inside grid
    output.flush();
    output.close();
    screenshot();
  }//if left or right clicked
  if (mouseButton == CENTER) {
    drawTangent();
  }//if wheel clicked
}//mouseClicked()

void graphEquation() {
  if (mouseButton == RIGHT) {
    aGrid = round(-1*random(-10, 0)*1000)/1000.0;
  }//right clicked
  else {
    aGrid = round(random(-10, 0)*1000)/1000.0;
  }//left clicked
  hGrid = xGrid;
  kGrid = yGrid;
  bGrid = round(-2*hGrid*aGrid*1000)/1000.0;
  cGrid = round((sq(hGrid)*aGrid + kGrid)*1000)/1000.0;
  fill(0, 232, 102);
  text("vertex: (" + hGrid + " , " + kGrid + ")", 505, 115);
  output.println("vertex: (" + hGrid + " , " + kGrid + ")");
  output.println("");
  if (hGrid >= 0) {
    hSign = "-";
  }
  else {
    hSign = "+";
  }
  if (kGrid >= 0) {
    kSign = "+";
  }
  else {
    kSign = "-";
  }
  if (bGrid >= 0){
    bSign = "+";
  }
  else {
    bSign = "-";
  }
  if (cGrid >= 0){
    cSign = "+";
  }
  else {
    cSign = "-";
  }
  fill(235, 180, 255);
  textSize(13);
  text("y = " + aGrid + "(" + "x " + hSign + " " + abs(hGrid) + ")" + char(178) + " " + kSign + " " + abs(kGrid), 505, 25);
  text("y = " + aGrid + "x" + char(178) + " " + bSign + " " + abs(bGrid) + "x " + cSign + " " + abs(cGrid), 505, 50);
  output.println("y = " + aGrid + "(" + "x " + hSign + " " + abs(hGrid) + ")" + char(178) + " " + kSign + " " + abs(kGrid));
  output.println("y = " + aGrid + "x" + char(178) + " " + bSign + " " + abs(bGrid) + "x " + cSign + " " + abs(cGrid));
  output.println("");
}//graphEquation()

void axisOfSymmetry() {
  stroke(178, 48, 250);
  strokeWeight(1);
  for(int i = 0; i < 500; i += 25){
    line(xGrid*(25.0/2.0)+250.0, i, xGrid*(25.0/2.0)+250.0, i+10);
  }//dotted line of symmetry
  fill(178, 48, 250);
  textSize(13);
  text("line of symmetry equation: x = " + xGrid, 505, 80);
  output.println("line of symmetry equation: x = " + xGrid);
  output.println("");
}//axisOfSymmetry()

void findRoots() {
  noStroke();
  fill(18, 162, 255);
  textSize(14);
  if ((sq(bGrid) - 4*aGrid*cGrid) == 0) {
    root1 = round((-bGrid/(2*aGrid))*1000)/1000.0;
    text("one real root:" + root1, 505, 150);
    text("x = " + root1, 505, 165);
    output.println("one real root:" + root1);
    output.println("x = " + root1);
    if (root1 <= 20) {
      ellipse(root1*(25.0/2.0)+250.0, 250, 10, 10);
    }//if inside grid
  }//one real root
  else if ((sq(bGrid) - 4*aGrid*cGrid) > 0) {
    root1 = round(((-bGrid - sqrt(sq(bGrid) - 4*aGrid*cGrid))/(2*aGrid))*1000)/1000.0;
    root2 = round(((-bGrid + sqrt(sq(bGrid) - 4*aGrid*cGrid))/(2*aGrid))*1000)/1000.0;
    text("two real roots:", 505, 150);
    text("x = " + root1, 505, 165);
    text("x = " + root2, 505, 180);
    output.println("two real roots:");
    output.println("x = " + root1);
    output.println("x = " + root2);
    if (root1 <= 20) {
      ellipse(root1*(25.0/2.0)+250.0, 250, 10, 10);
    }//if inside grid
    if (root2 <= 20) {
      ellipse(root2*(25.0/2.0)+250.0, 250, 10, 10);
    }//only draw root if it is inside grid
  }//two real roots
  else{
    root1 = round((-bGrid/(2*aGrid))*1000)/1000.0;
    root2 = round((sqrt(abs(sq(bGrid) - 4*aGrid*cGrid)))/(2*aGrid)*1000)/1000.0;
    text("two imaginary roots:", 505, 150);
    text("x = " + root1 + " - " + abs(root2) + "i", 505, 165);
    text("x = " + root1 + " + " + abs(root2) + "i", 505, 180);
    output.println("two imaginary roots:");
    output.println("x = " + root1 + " - " + abs(root2) + "i");
    output.println("x = " + root1 + " + " + abs(root2) + "i");
  }//two imaginary roots
  output.println("");
}//findRoots()

void drawGraph() {
  fill(0, 232, 102);
  textSize(14);
  text("X", 505, 215);
  text("Y", 575, 215);
  output.println("X,      Y");
  textSize(12);
  for(float i = 0; i <= 50; i += .25){
    xPointGrid1 = round((hGrid-25+i)*1000)/1000.0;
    yPointGrid1 = round((aGrid*sq(-25+i) + kGrid)*1000)/1000.0;
    xPointGraph1 = xPointGrid1*(25.0/2.0) + 250.0;
    yPointGraph1 = (yPointGrid1*(25.0/2.0)-250.0)*-1;
    if (xPointGrid1 <= 20){
      xPointGrid2 = hGrid-25+(i+.25);
      yPointGrid2 = aGrid*sq(-25+(i+.25)) + kGrid;
      xPointGraph2 = xPointGrid2*(25.0/2.0) + 250.0;
      yPointGraph2 = (yPointGrid2*(25.0/2.0)-250.0)*-1;
      stroke(235, 180, 255);
      strokeWeight(3);
      line(xPointGraph1, yPointGraph1, xPointGraph2, yPointGraph2);
    }//if inside grid
    if (round(i) == i){
      if (xPointGrid1 <= 20){
        noStroke();
        ellipse(xPointGraph1, yPointGraph1, 6.5, 6.5);
      }//if inside grid
      if (20 <= i && i <= 30){
        text(xPointGrid1, 505, i*15-70);
        text(yPointGrid1, 575, i*15-70);
        output.println(xPointGrid1 + ", " + yPointGrid1);
      }//x, y table of 11 values
    }//only if i is whole number
  }
  output.println("");
}//drawGraph()

void screenshot() {
  graph = get(0, 0, 500, 500);
  graph.save("data/graph.jpg");
}//screenshot()

void drawTangent() {
  slope = 2*aGrid*xGrid + bGrid;
  xPointSlope = xGrid*(25.0/2.0) + 250.0;
  yPointSlope = ((aGrid*sq(xGrid) + bGrid*xGrid + cGrid)*(25.0/2.0)-250.0)*-1;
  stroke(255);
  strokeWeight(1);
  line(xPointSlope, yPointSlope, 0, yPointSlope+slope*xPointSlope);
  line(xPointSlope, yPointSlope, 500, yPointSlope-slope*(500-xPointSlope));
}//drawTangent()

void asciiGraph() {
  output.println("ascii version of parabola:");
  output.println("");
  flat = false;
  number = 0;
  if (aGrid > 0) {
    a = 0;
  }//if parabola opens up
  else {
    a = 15;
  }//if parabola opens down
  while(0 <= a && a <= 15){
    xPointGrid1 = hGrid-15+a;
    yPointGrid1 = aGrid*sq(-15+a) + kGrid;
    xPointGrid2 = hGrid-15+(a+1);
    yPointGrid2 = aGrid*sq(-15+(a+1)) + kGrid;
    if (abs(yPointGrid2 - yPointGrid1) > .5) {
      if(flat == true) {
        output.println("");
      }//if last part was 'flat'
      flat = false;
      for(int j = 0; j <= a; j++) {
        output.print(" ");
      }//beginning spaces
      output.print("+");
      for(int j = 0; j <= 30-2*a; j++) {
          output.print(" ");
      }//spaces until the other point at same y-coord
      output.print("+");
    }//if steeper part of graph
    else {
      if (flat == false) {
          for(int j = 0; j <= a; j++) {
            output.print(" ");
          }
        }//if last part was 'steep'
      output.print(" +");
      flat = true;
    }//if flat part of graph
    for(int j = 0; j <= abs(yPointGrid2 - yPointGrid1); j++) {
      if (abs(yPointGrid2 - yPointGrid1) <= .5) {
        output.print("");
        break;
      }//if flat
      else {
        output.println("");
      }//if steep
    }
    if (aGrid > 0) {
      a++;
    }
    else {
      a--;
    }
  }//for 16 points
}//asciiGraph()

void zoom() {
  img = get(0, 0, 500, 500);
  if (600 < mouseX && mouseX < 625) {
    //translate(width/2, height/2);
    scale(1.1);
    image(img, 0, 0, img.width, img.height);
    /*for (int i = 0; i < 250000; i++) {
      map(pixels[i]
    }*/
  }
  else {
    //translate(width*2, height*2);
    //scale(.9);
    image(img, 0, 0, img.width, img.height);
  }
}//zoom()
