import Turtle.*;
import java.util.ArrayList;
import java.io.*;
import processing.pdf.*;
Turtle t;

public class GridTile {
  public boolean traversed = false;
  public float x; // the x-coord of the center of the tile
  public float y; // the y-coord of the center of the tile
  public int tile_x;
  public int tile_y;
  public GridTile(float _x, float _y, int _tile_x, int _tile_y) {
     x = _x;
     y = _y;
     tile_x = _tile_x;
     tile_y = _tile_y;
  }
}

public class Grid {
  public GridTile[][] grid;
  public int grid_width;
  public int grid_height;
  
  public Grid(int _grid_width,int _grid_height) {
    grid_width = _grid_width;
    grid_height = _grid_height;
    grid = new GridTile[grid_width][grid_height];
    
    // fill grid with grid tiles
    for(int i=0; i<grid_height; i++) {
      for(int j=0; j<grid_width; j++) {
        float x = (j*tile_width) + (tile_width/2);
        float y = (i*tile_height) + (tile_height/2);
        GridTile new_tile = new GridTile(x,y,i,j);
        grid[i][j] = new_tile;
      }
    }
  }
  
  public GridTile get_tile(int tile_x,int tile_y) {
    return grid[tile_x][tile_y];
  }
  
  public ArrayList<GridTile> get_open_neighbors(GridTile tile) {
    int tile_x = tile.tile_x;
    int tile_y = tile.tile_y;
    ArrayList<GridTile> open_n = new ArrayList<GridTile>();
    for(int i=-1; i<=1; i++) { // for including diagonal neighbors
      for(int j=-1; j<=1; j++) {
        if( (tile_x + i >= 0) && (tile_x + i < grid_width) && (tile_y + j >= 0) && (tile_y + j < grid_height) && !(i==0 && j==0)) {
          if(!grid[tile_x + i][tile_y + j].traversed) {
            open_n.add(grid[tile_x + i][tile_y + j]);
          }
        }
      }
    }
     
     //for(int i=-1; i<=1; i++) { // for only non-diagonal neighbors
     //  if( (tile_x + i >= 0) && (tile_x + i < grid_width) && (i!=0)) {
     //    if(!grid[tile_x + i][tile_y].traversed) {
     //      open_n.add(grid[tile_x + i][tile_y]);
     //    }
     //  }
     //}
     //for(int i=-1; i<=1; i++) {
     //  if( (tile_y + i >= 0) && (tile_y + i < grid_height) && (i!=0)) {
     //    if(!grid[tile_x][tile_y + i].traversed) {
     //      open_n.add(grid[tile_x][tile_y + i]);
     //    }
     //  }
     //}
     return open_n;
  }
}

int grid_width = 100;
int grid_height = 100;
GridTile[][] grid;
int tile_width;
int tile_height;

void setup() {
  size(800,800);
  tile_width = width/grid_width;
  tile_height = height/grid_height;
  stroke(0);
  noLoop();
  t = new Turtle(this);
  background(255,255,255);
  //draw_grid_lines(); // debug statement to show where grid tiles are
}

void draw() {
  Grid grid = new Grid(grid_width,grid_height); //create a 10x10 grid
  GridTile random_tile = grid.get_tile(int(random(-1,grid.grid_width)),int(random(-1,grid.grid_width)));
  GridTile current_tile;
  ArrayList<GridTile> open_n;
  
  t.penUp();
  for(int i = 0; i < 20; i++) {
    //draw_grid_lines();
    random_tile = grid.get_tile(int(random(-1,grid.grid_width)),int(random(-1,grid.grid_width)));
    t.goToPoint(random_tile.x,random_tile.y);
    current_tile = random_tile;
    current_tile.traversed = true;
    open_n = grid.get_open_neighbors(current_tile);
    while(open_n.size() != 0) {
      int random_idx = int(random(open_n.size()));
      current_tile = open_n.get(random_idx);
      open_n = grid.get_open_neighbors(current_tile);
      //System.out.printf("----------- open tiles for %d,%d -----------\n",current_tile.tile_x,current_tile.tile_y);
      for(int j=0; j < open_n.size(); j++) {
        //System.out.printf("%d,%d\n",open_n.get(j).tile_x,open_n.get(j).tile_y);
      }
      //print("----------------------\n");
      t.penDown();
      t.goToPoint(current_tile.x,current_tile.y);
      t.penUp();
      current_tile.traversed = true;
    }
  }
  
  //t.drawTurtle();
}

void draw_grid_lines() {
  for (int i = 0; i <= grid_width; i++) {
    float x = i * tile_width;
    line(x, 0, x, height); // Draw vertical lines
  }
  
  for (int j = 0; j <= grid_height; j++) {
    float y = j * tile_height;
    line(0, y, width, y); // Draw horizontal lines
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
