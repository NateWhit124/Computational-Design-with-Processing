import Turtle.*;
import processing.pdf.*;
Turtle t;

void setup() {
   t = new Turtle(this);
   stroke(0);
   size(700,700);
   background(255,255,255);
}

void draw() {
  float lower_bound = 0.5;
  float upper_bound = 0.52;
  int padding = 50;
  for(int i=padding; i<width-padding; i++) {
    for(int j=padding; j<height-padding; j++) {
      float noise_val = noise(i*0.015,j*0.015);
      if (noise_val > lower_bound && noise_val < upper_bound ) {
        set(i,j,color(0));
      }
    }
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
