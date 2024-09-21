import Turtle.*;
import processing.pdf.*;
import processing.core.PVector;
import java.util.HashMap;
import java.util.ArrayList;

Turtle t;
HashMap<String, Boolean> traveledPointsMap; // Using String keys for simplicity
float noiseLowerBound = 0.5;
float noiseUpperBound = 0.52;
int padding = 50;

void setup() {
  size(500, 500);
  t = new Turtle(this);
  traveledPointsMap = new HashMap<String, Boolean>();
  stroke(0);
  background(255);
  noLoop();
}

void draw() {
  t.penUp();

  // Finding a starting point
  outerloop:
  for (int i = padding; i < width - padding; i++) {
    for (int j = padding; j < height - padding; j++) {
      float noiseVal = noise(i * 0.015, j * 0.015);
      if (noiseVal > noiseLowerBound && noiseVal < noiseUpperBound) {
        t.goToPoint(i, j);
        break outerloop;
      }
    }
  }

  t.penDown();
  PVector currentCoords = new PVector(t.getX(), t.getY());
  traveledPointsMap.put(currentCoords.x + "," + currentCoords.y, true);

  ArrayList<PVector> openNeighbors = findOpenNeighbors(currentCoords);
  int maxIter = 20000;
  int count = 0;

  while (!openNeighbors.isEmpty()) {
    PVector newCoords = openNeighbors.remove(0); // Move to and remove the first open neighbor
    if (!traveledPointsMap.containsKey(newCoords.x + "," + newCoords.y)) {
      t.goToPoint(newCoords.x, newCoords.y);
      traveledPointsMap.put(newCoords.x + "," + newCoords.y, true);
      currentCoords = new PVector(newCoords.x, newCoords.y);
      openNeighbors.addAll(findOpenNeighbors(currentCoords)); // Get new neighbors from the new position
    }
    count++;
  }

  println("Done");
}

public ArrayList<PVector> findOpenNeighbors(PVector coords) {
  ArrayList<PVector> openNeighbors = new ArrayList<PVector>();
  for (int i = -5; i <= 5; i++) {
    for (int j = -5; j <= 5; j++) {
      if ((coords.x + i > padding) && (coords.x + i < width - padding) && (coords.y + j > padding) && (coords.y + j < height - padding) && !(i == 0 && j == 0)) {
        PVector newCoords = new PVector(coords.x + i, coords.y + j);
        if (!traveledPointsMap.containsKey(newCoords.x + "," + newCoords.y) && isValidNeighbor(newCoords)) {
          openNeighbors.add(newCoords);
        }
      }
    }
  }
  return openNeighbors;
}

public boolean isValidNeighbor(PVector coords) {
  float noiseVal = noise(coords.x * 0.015, coords.y * 0.015);
  return noiseVal > noiseLowerBound && noiseVal < noiseUpperBound;
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
