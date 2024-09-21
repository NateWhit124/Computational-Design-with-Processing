import Turtle.*;
import processing.pdf.*;
Turtle t;
int num_iter = 6;
int padding = 10;

void setup() {
  t = new Turtle(this);
  stroke(0); 
  size(700,700);
  noLoop();
}

void draw() {
  int x1 = padding;
  int x2 = width-padding;
  int y1 = height-padding;
  int y2 = padding;
  int x3 = (x2+x1)/2;
  
  for(int i=0; i<num_iter; i++) {
    // draw the current triangle
    t.penUp();
    t.goToPoint(x1,y1);
    t.penDown();
    t.goToPoint(x2,y1);
    t.goToPoint(x3,y2);
    t.goToPoint(x1,y1);
    
    println("Triangle Points: (" + x1 + ", " + y1 + "), (" + x2 + ", " + y1 + "), (" + x3 + ", " + y2 + ")\n");
    // setup points for next inner triangle
    int x1_new = (x3 + x1) / 2;
    int x2_new = (x3 + x2) / 2;
    int y2_new = y1;
    int y1_new = (y2+y1)/2;
    
    x1 = x1_new;
    x2 = x2_new;
    y2 = y2_new;
    y1 = y1_new;
  }
}

// The following was courtesy of Professor Rivera's Github for exporting PDFs from Processing
// https://github.com/utilityresearchlab/compfab-2023-fall/blob/main/processing-demos/EllipsesExportPDF/EllipsesExportPDF.pde
// Handles key press events
void keyPressed() { 
  // press 's' to save a svg of your drawing
  if (key == 's') {
    // Make file name with the currrent date/time
    String folder = "output";
    String fileName = "drawing-" + getDateString() + ".pdf";
    beginRecord(PDF, folder + "/" + fileName);
    setup();
    draw();
    endRecord();
    println("Saved to file: " + fileName);
  }
} 

// Generates a date string of the format year_month_day-hour_min_second
String getDateString() {
  String time = str(hour()) + "_" + str(minute()) + "_" + str(second());
  String date = str(year()) + "_" + str(month()) + "_" + str(day());
  return date + "-" + time;
}
