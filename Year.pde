class Year {
  
  ArrayList<Song> songs;
  int year;
  int mostPopularSongIndex, leastPopularSongIndex;
  
  int clickedOnSong = -1;
  
  int meanX = -1;
  int meanY = -1;
  
  int maxDisplayedSongs = 15;
  
  Year(int year) {
    this.songs = new ArrayList<Song>();
    this.year = year;
  }
  
  void addSong(String artist, String name, String genre, int val, int dur, int pop, int spch) {
    Song newSong = new Song(artist, name, genre, val, dur, pop, spch);
    songs.add(newSong);
  }
  
  void sortSongs() {
    songs.sort((o1, o2) -> Integer.compare(o2.getPop(), o1.getPop()));
  }
  
  void renderYear(int x, int y, int w, int h) {
    // fill(#FFFFFF);
    // rect(x, y, w, h, 28);
    
    int index = 0;
    
    /*
    for(Song song: songs) {
      if (maxDisplayedSongs <= index)
        return;
        
      song.renderSong(x, y, w, h);
      index++;
    }
    */
    for (int i = maxDisplayedSongs - 1; i >= 0; i--) {
      songs.get(i).renderSong(x, y, w, h);
    }
  }
  
  void findMostPopularSong() {
    int currentMostPopular = -1, currentIndex = 0;
    
    for (Song song: songs) {
      if (song.getPop() > currentMostPopular) {
        currentMostPopular = song.getPop();
        this.mostPopularSongIndex = currentIndex;
      }
      currentIndex++;
      
      if (currentIndex > maxDisplayedSongs)
        return;
    }
  }
  
  void findLeastPopularSong() {
    int currentLeastPopular = 101, currentIndex = 0;
    
    println();
    
    for (Song song: songs) {
      if (song.getPop() < currentLeastPopular) {
        currentLeastPopular = song.getPop();
        this.leastPopularSongIndex = currentIndex;
      }
      currentIndex++;
      
      if (currentIndex > maxDisplayedSongs)
        return;
    }
  }
  
  void calculateAndDrawMean(int x, int y, int w, int h) {
    int positionX, positionY;
    
    if(meanX == -1 && meanY == -1) {
      int sumSpch = 0, sumLen = 0;
      
      int currentIndex = 0;
    
      for (Song song : songs) {
        sumSpch += song.getSpch();
        sumLen += song.getLen();
        
        currentIndex++;
        if (maxDisplayedSongs == currentIndex)
          break;
      }
      
      int meanSpch = sumSpch / maxDisplayedSongs;
      int meanLen = sumLen / maxDisplayedSongs;
      
      int minDur = 134, maxDur = 424;
      int minSpch = 0, maxSpch = 48;
      
      positionX = x + ((meanLen - minDur) * w) / (maxDur - minDur);
      positionY = y + h - ((meanSpch - minSpch) * h) / (maxSpch - minSpch);
      
      this.meanX = positionX;
      this.meanY = positionY;
    } else {
      positionX = this.meanX;
      positionY = this.meanY;
    }
    
    int radius = 5;
     
    fill(#FF0000);
    circle(positionX, positionY, radius);
    
    //println(positionX + ", " + positionY);
  }
  
  int calculateMeanValence() {
    int meanValence = 0;
    for (Song song : songs) {
      meanValence += song.getVal();
    }
    return meanValence / songs.size();
  }
  
  boolean checkHovering(boolean isClicked) {
    boolean onTop = true;
    boolean atLeastOne = false;
    boolean infoClicked = false;
    
    int index = 0;
    for (Song song: songs) {
      if (song.overCircle() && onTop) {
        song.setHoverMultiply(1.5);
        onTop = false;
        
        if (isClicked) {
          clickedOnSong = index;
          infoClicked = true;
          println("Clicked on song " + index);
        }
        
        atLeastOne = true;
      }
      else
        song.setHoverMultiply(1);
        
      index++;
    }
    
    if (!atLeastOne && isClicked) {
      clickedOnSong = -1;
      stopTrack();
    }
      
    return infoClicked;
  }
  
  void handleDisplayInfo() {
    Song song = songs.get(clickedOnSong);
    
    displayInfo(song);
    
    if (song.getPreviewUrl() == null && song.getSongUrl() == null)
      song.setUrls();
    
    // If no previews were found, display an error message
    if (song.getPreviewUrl() == null)
      displayErrorMessage();
    
    startTrack(song.getPreviewUrl(), song.getArtist() + " " + song.getTitle());
  }
  
  void displayInfo(Song song) {
    InformationPanel panel = new InformationPanel(song, 450, 150);
    panel.drawPanel();
  }
  
  void displayErrorMessage() {
    colorMode(HSB, 360, 100, 100);
    fill(color(0, 0, 80));
    colorMode(RGB, 255, 255, 255);
    rect(width / 2 - 100, 50, 200, 20, 20);
    fill(#000000);
    textSize(15);
    text("Preview not found!", width / 2 - 60, 65);
  }
  
  String getPopularArtist() {
    return songs.get(this.mostPopularSongIndex).getArtist();
  }
  
  String getPopularTitle() {
    return songs.get(this.mostPopularSongIndex).getTitle();
  }
  
  int getPopularity() {
    return songs.get(this.mostPopularSongIndex).getPop();
  }
  
  int getPopularityL() {
    return songs.get(this.leastPopularSongIndex).getPop();
  }
  
  // Getter function
  int getYear() {
    return this.year;
  }
  
  int getMeanX() {
    return this.meanX;
  }
  
  int getMeanY() {
    return this.meanY;
  }
  
}
