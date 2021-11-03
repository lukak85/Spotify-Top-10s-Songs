# Spotify Top 10s Songs

Spotify is a growing platform for media consumption in the form of music. During the 2010s, different songs have topped the lists as one of the most popular songs on the platform.

With this application, we take a look at the trends of the most popular 20 songs in each year in 2010s and look at the trends in popular music by looking at length, valence and duration of the most popular songs of that year.

## Sample images:

![Online Mode](/screenshots/SpotifyTop10s_online.png)

![Offline Mode](/screenshots/SpotifyTop10s_offline.png)

## Attibute meaning

* *Valence*: How happy the song is.
* *Speech*: How much words are said in a song.
* *Lenght*: How long the song is in seconds.
* *Genre*: Which genre the song belongs to.
* *Popularity*: How popular the song was in comparassion to others.

## Quick overview

The lenght attribute in the application is represented by the _x_ axis, while the speech attribute is represented by the _y_ axis. Genres are shown using different colors and their valence displayed using different brightness of the color. Popularity of a song is displayed by resizing the bubbles appropriately.

Based on speech and lenght of the song, a mean of the two values of all the songs in a select year is calculated and displayed. We also draw a line, showing the movement of said mean during the years.

On the right hand side resides the information about the current year, as well as said year's most popular song. Here is also displayed the mean valence of the current year. Below it is a legend.

# How to use

## Getting started

In order to be able to use the API, one must generate an OAuth token on the [Spotify Web API](https://developer.spotify.com/web-api/) website, section _Console_, subsection [_Search for Item_](https://developer.spotify.com/console/get-search-item/) and pass it to the application. To generate the token, the user must have a Spotify accoun.

The token is passed to the application as a String to the file SpotifyAPI as a variable _accessToken_.

Example:

```
String accessToken = "BQCYQKxnEcbQKY7K6WoRBKhKWWcCT_SLjBCOWCqC0XUv6j5aJMM9nlfsDUDHnry8JVzi6naypjDUcTtPjSuwOlVy-DXz7yArEHMLFvNxULTdFIS5d2WJRa993gMfrUVhO0jUEzN2CvA0VuSa0gjnqWsPFD6YKp7ciIc";
```

If no such (valid) token is produced, the application goes into offline mode, where the playback of a preview and display of songs' covers are disabled.

To run the application using the Processing IDE, simply click run.

## Using the application

In front of you is a running application. To scroll trough the years, use either of the following:
* up / down arrow key
* left and right buttons situated to the eather side of the current year
* scroll wheel

To view the details of each bubble representing a song, click on in. An informational pannel will pop up and, if the preview is available, the said preview will play. The information pannel also displays the song's cover picture (or more preciselly, the cover of one of the albums the song appears on; if no such cover is found, a placeholder *No picture found* picture is displayed).

# Technology used

* Processing 4.x
* [Spotify Web API Java](https://github.com/spotify-web-api-java)

# Known problems

* When clicking on a particular song and therefore searced using Spotify API, a non-ideal instance of a song is played (i.e. Eminem - Lose Yourself)

### Version 0.1.0