color chooseColor(String genre, int valence) {
  
  colorMode(HSB, 360, 100, 100);
  
  valence /= 2;
  valence += 50;
  
  switch (genre) {
    // Electronic
    case "big room":
    case "electro":
    case "brostep":
    case "electronic trap":
    case "edm":
    case "electro house":
    case "tropical house":
    case "belgian edm":
    case "complextro":
    case "house":
      return color(0, 100, valence);
      
    // Pop
    case "pop":
    case "canadian pop":
    case "dance pop":
    case "barbadian pop":
    case "australian pop":
    case "indie pop":
    case "art pop":
    case "colombian pop":
    case "baroque pop":
    case "acoustic pop":
    case "moroccan pop":
    case "folk-pop":
    case "candy pop":
    case "danish pop":
    case "french indie pop":
      return color(0, 0, valence);
      
      
    // Hip hop
    case "hip hop":
    case "detroit hip hop":
    case "atl hip hop":
    case "canadian hip hop":
    case "australian hip hop":
      return color(80, 100, valence);
      
    // R&B
    case "alternative r&b":
      return color(160, 100, valence);
      
    // Rap
    
    // Other genres
    default:
      return color(240, 100, valence);
      
  }
}

/*
british soul
chicago rap
permanent wave
boy band
celtic rock
alaska indie
metropopolis
australian dance
hollywood
canadian contemporary r&b
irish singer-songwriter
latin
canadian latin
downtempo
contemporary country
escape room
alternative r&b
neo mellow
*/
