import java.awt.Image;
import java.net.URL;
import javax.imageio.ImageIO;

class Song {
  String artist;
  String name;
  String genre;
  int val, dur, pop, spch;
  color c;
  
  float hoverMultiply;
  
  int positionX, positionY, radius;
  
  String previewUrl, songUrl;
  
  float sineOffset, sineAmplitude, sineFrequency;
  
  boolean noImage;
  PImage image;
  color averageColor;
  boolean isDarkText;
  
  Song(String artist, String name, String genre, int val, int dur, int pop, int spch) {
    // Properties
    this.artist = artist;
    this.name = name;
    this.genre = genre;
    this.val = val;
    this.dur = dur;
    this.pop = pop;
    this.spch = spch;
    
    // Stuff that we need to render the scene
    this.hoverMultiply = 1;
    this.positionX = 0;
    this.positionY = 0;
    this.radius = 0;
    
    this.sineOffset = random((float) Math.PI * 2); 
    this.sineAmplitude = 1;
    this.sineFrequency = 0.001;
    
    this.c = chooseColor(this.genre, this.val);
    this.image = loadImage("media_files/No-image-available.png");
    this.noImage = true;
    
    averageColor = color(0, 0, 90);
    
    this.isDarkText = false;
  }
  
  void setUrls() {
    PackageData data = searchTracks(this.artist + " " + this.name);
    
    if (data != null) {
      this.previewUrl = data.getPrUrl();
      this.songUrl = data.getSongUrl();
    }
    else
      return;
    
    if (noImage && data.getImage() != null) {
      Image image = null;
      try {
          URL url = new URL(data.getImage());
          image = ImageIO.read(url);
      } catch (IOException e) {
          System.out.println("Unable to retrieve image.");
      }

      if (image != null) {
        this.image = new PImage(image);
        noImage = false;
      }
      
      if (this.image != null) {
        getAverageColor();
      } else {
        this.averageColor = color(255, 255, 255);
      }
    }
  }
  
  void getAverageColor() {
    colorMode(RGB, 255, 255, 255);
    
    long red = 0;
    long green = 0;
    long blue = 0;
    
    this.image.loadPixels();   
    int index = 0;
    
    for (int y = 0; y < this.image.height; y++) {
      for (int x = 0; x < this.image.width; x++) {
      
        color c = this.image.pixels[index];
  
        red += red(c);
        green += green(c);
        blue += blue(c);
        
        index++;      
      }
    }
    
    red /= index;
    green /= index;
    blue /= index;
    color rgbAverage = color(red, green, blue);
    
    this.averageColor = rgbAverage;
    
    if (red + green + blue < 255)
      this.isDarkText = true;
  }
  
  void renderSong(int x, int y, int w, int h) {
    int minDur = 134, maxDur = 424;
    int minSpch = 0, maxSpch = 48;
    
    this.positionX = x + ((dur - minDur) * w) / (maxDur - minDur);
    this.positionY = y + h - ((spch - minSpch) * h) / (maxSpch - minSpch);
    this.radius = (int) ((pop * this.hoverMultiply) / 5);
     
    // fill(#FFFFFF);
    fill(this.c);
    
    float currentTime = millis();
    float alteredPositionY = positionY + this.sineAmplitude * (float) Math.sin(currentTime * this.sineFrequency + this.sineOffset);
    circle(positionX, alteredPositionY, radius);
  }
  
  boolean overCircle() {
    float disX = positionX - mouseX;
    float disY = positionY - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < this.radius - 10) {
      return true;
    } else {
      return false;
    }
  }
  
  // Getter functons
  int getPop() {
    return this.pop;
  }
  
  int getVal() {
    return this.val;
  }
  
  int getLen() {
    return this.dur;
  }
  
  int getSpch() {
    return this.spch;
  }
  
  String getArtist() {
    return this.artist;
  }
  
  String getTitle() {
    return this.name;
  }
  
  String getGenre() {
    return this.genre;
  }
  
  int getPosX() {
    return this.positionX;
  }
  
  int getPosY() {
    return this.positionY;
  }
  
  String getPreviewUrl() {
    return this.previewUrl;
  }
  
  String getSongUrl() {
    return this.songUrl;
  }
  
  PImage getImage() {
    return this.image;
  }
  
  void setHoverMultiply(float hoverMultiply) {
    this.hoverMultiply = hoverMultiply;
  }
}
