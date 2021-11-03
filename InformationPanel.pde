class InformationPanel {
  Song song;
  int panelW, panelH;
  
  InformationPanel(Song song, int panelW, int panelH) {
    this.song = song;
    this.panelW = panelW;
    this.panelH = panelH;
  }
  
  void drawPanel() {
    int x = song.getPosX();
    int y = song.getPosY();
    
    x -= panelW/2;
    y -= (panelH + 25);
    
    if (x < 5)
      x = 5;
     
    boolean atBottom = false;
    if (y < 5) {
      y += 50 + panelH;
      atBottom = true;
    }
    
    //stroke(#FFFFFF);
    //strokeWeight(4);
    
    fill(song.averageColor);
    rect(x, y, panelW, panelH, 10);
    // noStroke();
    
    fill(song.averageColor);
    if (atBottom)
      triangle(song.getPosX(), song.getPosY(), song.getPosX() - 15, song.getPosY() + 25, song.getPosX() + 15, song.getPosY() + 25);
    else
      triangle(song.getPosX(), song.getPosY(), song.getPosX() - 15, song.getPosY() - 25, song.getPosX() + 15, song.getPosY() - 25);
    
    textSize(15);
    if (song.isDarkText)
      fill(#FFFFFF);
    else
      fill(#191414);
    
    String authorAndTitle = this.song.getArtist() + " - " + this.song.getTitle();
    if (authorAndTitle.length() > 35) {
      authorAndTitle = authorAndTitle.substring(0, 33) + "...";
    }
    
    text("\n" + authorAndTitle
          + "\nGenre: " + this.song.getGenre()
          + "\nValence: " + this.song.getVal()
          + "\nPopularity: " + this.song.getPop()
          + "\nLength: " + this.song.getLen() + ", speech: " + this.song.getSpch(),
          x + panelH + 10, y + 2.5);
          
    
    song.getImage().resize(panelH-20, panelH - 20);
    image(song.getImage(), x + 10, y + 10);
    
  }
  
}
