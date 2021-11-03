import java.awt.Desktop;
import java.net.URI;
import java.io.IOException;
import java.net.URISyntaxException;

Desktop desktop;

// Information
Table topSongs;

ArrayList<Year> years;

// UI variables
int currentYearIndex = 0;

int mainDisplayX;
int mainDisplayY;
int mainDisplayW;
int mainDisplayH;

boolean inDarkMode;
PImage imageLM;
PImage imageDM;
PImage imageDMa;

String popularArtist;
String popularTitle;
int popularity;

int popularityL;

Song overSongG;
boolean clickedForInfo;

void initializeVariables() {
  clickedForInfo = false;
  
  mainDisplayX = 50;
  mainDisplayY = 50;
  mainDisplayW = width - mainDisplayX - 400;
  mainDisplayH = height - 2 * mainDisplayY;
  
  inDarkMode = false;
  
  try {
    imageLM = loadImage("media_files/Spotify_Logo_RGB_White.png");
    imageLM.resize(250, 0);
    imageDM = loadImage("media_files/Spotify_Logo_RGB_Green.png");
    imageDM.resize(250, 0);
    imageDMa = loadImage("media_files/Spotify_Logo_RGB_Black.png");
    imageDMa.resize(250, 0);
  } catch (Exception e) {
    e.printStackTrace();
  }
}

void setup() {
  years = new ArrayList<Year>();
  
  for (int i = 2010; i < 2020; i++) {
    years.add(new Year(i));
  }
  
  try {
    topSongs = loadTable("spotify_data/top10s.csv", "header");
    
    try {
      for(TableRow row : topSongs.rows()){
        String artist = row.getString("artist");
        String title = row.getString("title");
        int year = row.getInt("year");
        int index = year - 2010;
        String genre = row.getString("top genre");
        
        int val = row.getInt("val");
        int dur = row.getInt("dur");
        int pop = row.getInt("pop");
        int spch = row.getInt("spch");
        
        // println("Song name and artist: " + artist + "-" + title + "\nPopularity: " + pop + "\n");
        if (pop > 0)
          years.get(index).addSong(artist, title, genre, val, dur, pop, spch);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
  
  for (Year year : years) {
    year.sortSongs();
    year.findMostPopularSong();
    year.findLeastPopularSong();
  }
  
  // Setup desktop instance
  desktop = Desktop.getDesktop();
  
  // Setup Spotify API
  setupSpotifyAPI();
  
  // Set window
  size(1280, 720);
  initializeWindow();
  
  // Initialize stuff
  initializeVariables();
  initializeUI();
}

void initializeWindow() {
  surface.setTitle("Spotify Top 10s");
  // surface.setResizable(true);
}

void initializeUI() {
  getMostPopular();
  getLeastPopular();
  
  PFont myFont = createFont("SansSerif", 32);
  textFont(myFont);
}

void draw() {
  if (!inDarkMode)
    background(#191414);
  else
    background(#1DB954);
    
  noStroke();
  
  executeProgramLogic();
  renderSongs();
  renderUI();
}

void executeProgramLogic() {
  // TODO
}

void renderUI() {
  // Background on the right
  // fill(#1DB954);
  fill(#2C856B);
  rect(mainDisplayX + mainDisplayW + 50, 0, 500, height, 35);
  
  // Spotify logo
  if (imageDM != null && imageLM != null) {
    if (inDarkMode)
      //image(imageDMa, mainDisplayX + mainDisplayW + 100, mainDisplayY);
      image(imageDM, mainDisplayX + mainDisplayW + 100, mainDisplayY);
    else
      image(imageLM, mainDisplayX + mainDisplayW + 100, mainDisplayY);
  }
  
  // Information about most popular song
  fill(#FFFFFF);
  textSize(20);
  text("Most popular song:\n- " + popularArtist + "\n- " + popularTitle + "\n- Popularity: " + popularity + " / 100", mainDisplayX + mainDisplayW + 100, mainDisplayY + 130);
  
  // fill(#EE0000);
  text("Mean valence this year: " + years.get(currentYearIndex).calculateMeanValence(), mainDisplayX + mainDisplayW + 100, mainDisplayY + 275);
  
  textSize(18);
  fill(#FFFFFF);
  text("GENRES:\n    - pop\n    - electronic\n    - hip hop\n    - rnb\n    - other", mainDisplayX + mainDisplayW + 100, mainDisplayY + 335);
  
  text("POPULARITY:\n    - " + popularityL + "\n    - " + popularity, width - 160, mainDisplayY + 335);
  
  int distanceSpheresInLegend = 29;
  
  // Render legend spheres
  colorMode(HSB, 360, 100, 100);
  renderLegendSpheres(color(0, 0, 100), mainDisplayX + mainDisplayW + 110, mainDisplayY + 331 + distanceSpheresInLegend, 10);
  renderLegendSpheres(color(0, 100, 100), mainDisplayX + mainDisplayW + 110, mainDisplayY + 331 + distanceSpheresInLegend * 2, 10);
  renderLegendSpheres(color(80, 100, 100), mainDisplayX + mainDisplayW + 110, mainDisplayY + 331 + distanceSpheresInLegend * 3, 10);
  renderLegendSpheres(color(160, 100, 100), mainDisplayX + mainDisplayW + 110, mainDisplayY + 331 + distanceSpheresInLegend * 4, 10);
  renderLegendSpheres(color(240, 100, 100), mainDisplayX + mainDisplayW + 110, mainDisplayY + 331 + distanceSpheresInLegend * 5, 10);
  
  renderLegendSpheres(color(0, 0, 100), width - 150, mainDisplayY + 331 + distanceSpheresInLegend, popularityL / 5);
  renderLegendSpheres(color(0, 0, 100), width - 150, mainDisplayY + 331 + distanceSpheresInLegend * 2, popularity / 5);
  colorMode(RGB, 255, 255, 255);
  
  if (inDarkMode)
    fill(#1DB954);
  else
    fill(#FFFFFF);
  
  // Year of song's release
  textSize(110);
  fill(#FFFFFF);
  text(years.get(currentYearIndex).getYear(), mainDisplayX + mainDisplayW + 110, height - 50);
  
  // Arrows for moving trough the years
  fill(#FFFFFF);
  if(currentYearIndex > 0) {
    overPreviousYear();
    triangle(mainDisplayX + mainDisplayW + 70, height - 85, mainDisplayX + mainDisplayW + 100, height - 55, mainDisplayX + mainDisplayW + 100, height - 115);
  }
  if(currentYearIndex < 9) {
    // Check if hovering over it, if it is, display color it appropriately
    overNextYear();
    triangle(width - 10, height - 85, width - 40, height - 55, width - 40, height - 115);
  }
  
  // Valence horizontal text
  fill(#FFFFFF);
  textSize(24);
  text("L      E      N      G      T      H", width/2 - 350, height - 15);
  // Length vertical text
  text("S\nP\nE\nE\nC\nH", 15, height / 2 - 100);
  
  
  // Draw x and y axis
  // x axis
  fill(#FFFFFF);
  rect(mainDisplayX - 10, mainDisplayY + mainDisplayH, mainDisplayW, 2);
  // y axis
  fill(#FFFFFF);
  rect(mainDisplayX, mainDisplayY, 2, mainDisplayH + 10);
  
  
  // Lines to denote some labels on x and y axis
  fill(#FFFFFF);
  rect(mainDisplayX - 10, mainDisplayY, 20, 2);
  fill(#FFFFFF);
  rect(mainDisplayX + mainDisplayW - 10, mainDisplayY + mainDisplayH - 10, 2, 20);
  
  // Labels
  // int minDur = 134, maxDur = 424;
  // int minSpch = 0, maxSpch = 48;
  textSize(20);
  text("0", 15, mainDisplayY + mainDisplayH + 5);
  text("48", 10, mainDisplayY + 7);
  
  text("134", 35, mainDisplayY + mainDisplayH + 30);
  text("424", mainDisplayX + mainDisplayW - 30, mainDisplayY + mainDisplayH + 30);
  
  
  // Check if the cursor hovers over any items, if it is, make them larger and display info
  years.get(currentYearIndex).checkHovering(false);
  
  if (clickedForInfo) {
    years.get(currentYearIndex).handleDisplayInfo();
  }
  
}

void renderLegendSpheres(color c, int x, int y, int r) {
  fill(c);
  circle(x, y, r);
}

void renderSongs() {
  // Draw songs
  years.get(currentYearIndex).renderYear(mainDisplayX, mainDisplayY, mainDisplayW, mainDisplayH);
  
  // Draw mean
  years.get(currentYearIndex).calculateAndDrawMean(mainDisplayX, mainDisplayY, mainDisplayW, mainDisplayH);
  
  connectMeans();
}

void connectMeans() {
  for (int i = 0; i < currentYearIndex; i++) {
    stroke(#FF0000);
    line(
      years.get(i    ).getMeanX(),
      years.get(i    ).getMeanY(),
      years.get(i + 1).getMeanX(),
      years.get(i + 1).getMeanY()
    );
    noStroke();
  }
}

void keyPressed() {
  if(key == CODED) {
    if(keyCode == DOWN && currentYearIndex < 9) {
      currentYearIndex++;
      getMostPopular();
      getLeastPopular();
    } else if (keyCode == UP && currentYearIndex > 0){
      currentYearIndex--;
      getMostPopular();
      getLeastPopular();
    }
  }
  
  /*
  if(key == 'm') {
    inDarkMode = !inDarkMode;
  }
  */
}

void mousePressed() {
  // Check if the cursor hovers over any items, if it is, make them larger and display info
  clickedForInfo = years.get(currentYearIndex).checkHovering(true);
  
  if (overPreviousYear()) {
    currentYearIndex--;
    getMostPopular();
    getLeastPopular();
  }
    
  if (overNextYear()) {
    currentYearIndex++;
    getMostPopular();
    getLeastPopular();
  }
}

float lastScrolled = 0;

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  
  float nowScrolled = millis();

  if (e == -1.0 && currentYearIndex > 0 && abs(lastScrolled - nowScrolled) > 500) {
    currentYearIndex--;
    getMostPopular();
    getLeastPopular();
    lastScrolled = nowScrolled;
  }
    
  if (e == 1.0  && currentYearIndex < 9 && abs(lastScrolled - nowScrolled) > 500) {
    currentYearIndex++;
    getMostPopular();
    getLeastPopular();
    lastScrolled = nowScrolled;
  }
}

boolean overPreviousYear() {
  if(mouseX >= mainDisplayX + mainDisplayW + 70 && mouseX <= mainDisplayX + mainDisplayW + 100 && mouseY <= height - 55 && mouseY >= height - 115 && currentYearIndex > 0) {
    fill(#DDDDDD);
    return true;
  }
  fill(#FFFFFF);
  return false;
}

boolean overNextYear() {
  if (mouseX <= width - 10 && mouseX >= width - 40 && mouseY <= height - 55 && mouseY >= height - 115 && currentYearIndex < 9) {
    fill(#DDDDDD);
    return true;
  }
  fill(#FFFFFF);
  return false;
}

void getMostPopular() {
  popularArtist = years.get(currentYearIndex).getPopularArtist();
  popularTitle = years.get(currentYearIndex).getPopularTitle();
  popularity = years.get(currentYearIndex).getPopularity();
}

void getLeastPopular() {
  popularityL = years.get(currentYearIndex).getPopularityL();
}
