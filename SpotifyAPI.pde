import processing.sound.*;

import com.wrapper.spotify.SpotifyApi;
import com.wrapper.spotify.SpotifyApi;
import com.wrapper.spotify.exceptions.SpotifyWebApiException;
import com.wrapper.spotify.model_objects.specification.Paging;
import com.wrapper.spotify.model_objects.specification.Track;
import com.wrapper.spotify.requests.data.search.simplified.SearchTracksRequest;

String accessToken = "BQAdx08vszl7OwDhfX3PoHgwjFSzHThK25dYUou0CoLw0HojCx0j1Cww9SRAvdK6bx3fxYfKfKQbjasv0Y63Ov5VPGz0WjfcPE5T7ujZCPcVPK48i5zjhKAIfXqjBNctT2L7hLRPGLFkC-XqRji8g2NYdCZJ0j866eI";

SoundFile soundFile;
boolean isPlaying = false;
String currentlyPlaying = "";

boolean connectionToSpotify = false;

SpotifyApi spotifyApi;

void setupSpotifyAPI() {
  try {
    spotifyApi = new SpotifyApi.Builder()
      .setAccessToken(accessToken)
      .build();
      
    connectionToSpotify = true;
  } catch (Exception e) {
    println("Error: " + e.getMessage());
  }
}
  
PackageData searchTracks(String songName) {
  println(songName);
  
  try {
    SearchTracksRequest searchTracksRequest = spotifyApi.searchTracks(songName)
                .market(CountryCode.SI)
    //          .limit(10)
    //          .offset(0)
    //          .includeExternal("audio")
                .build();
                
    Paging<Track> trackPaging = searchTracksRequest.execute();
    
    Track foundTrack = trackPaging.getItems()[0];
    String prUrl = foundTrack.getPreviewUrl();
    
    ExternalUrl extUrls = foundTrack.getExternalUrls();
    String songUrl = extUrls.get("spotify");
    
    int index = 1;
    while(prUrl == null && index < trackPaging.getItems().length) {
      foundTrack = trackPaging.getItems()[index];
      prUrl = foundTrack.getPreviewUrl();
      index++;
    }

    AlbumSimplified album = foundTrack.getAlbum();
    
    String imageUrl = null;
    
    try {
      com.wrapper.spotify.model_objects.specification.Image image = album.getImages()[0];
      imageUrl = image.getUrl();
    } catch (Exception e) {
      println("Unable to find cover.");
    }
    
    println(prUrl);
    println(songUrl);
    println(imageUrl);
    
    PackageData pack = new PackageData(prUrl, songUrl, imageUrl);
    
    return pack;
    
  } catch (Exception e) {
    println("Error: " + e.getMessage());
  }
  
  return null;
}

void startTrack(String previewUrl, String songName) {
  if (isPlaying && !songName.equals(currentlyPlaying)) {
    println("Changed song");
    stopTrack();
  }
  
  if (!isPlaying && previewUrl != null) {
    soundFile = new SoundFile(this, previewUrl);
    soundFile.play();
    isPlaying = true;
    currentlyPlaying = songName;
  }
}

void stopTrack() {
  if (isPlaying) {
    soundFile.stop();
    isPlaying = false;
    currentlyPlaying = "";
  }
}

class PackageData {
  String prUrl, songUrl, imageUrl;
  
  PackageData(String prUrl, String songUrl, String imageUrl) {
    this.prUrl = prUrl;
    this.songUrl = songUrl;
    this.imageUrl = imageUrl;
  }
  
  String getPrUrl() {
    return this.prUrl;
  }
  
  String getSongUrl() {
    return this.songUrl;
  }
  
  String getImage() {
    return this.imageUrl;
  }
}
