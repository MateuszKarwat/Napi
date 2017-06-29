![Napi](https://raw.githubusercontent.com/MateuszKarwat/Napi/assets/Napi.png)

[![Platforms](https://img.shields.io/badge/platform-macOS-blue.svg)](https://www.apple.com/pl/macos/)
[![Build Status](https://travis-ci.org/MateuszKarwat/Napi.svg?branch=master)](https://travis-ci.org/MateuszKarwat/Napi)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/MateuszKarwat/Napi/blob/master/LICENCE.md)

Napi is a native macOS application to download and convert subtitles for videos.

* [Supported Subtitle Formats](#supported-subtitle-formats)
* [Supported Subtitle Providers](#supported-subtitle-providers)
* [Advanced Usage]($advanced-usage)
  * [Command Line](#command-line)
  * [LaunchAgent](#launch-agent)
  * [Logging](#logging)

## Supported Subtitle Formats
There are few, most common subtitle formats Napi supports, which means Napi can correctly recognize that format and convert it to/from other subtitle formats.
Currently supported formats are:
- [SubRip](https://en.wikipedia.org/wiki/SubRip#SubRip_text_file_format)
- [MicroDVD](https://en.wikipedia.org/wiki/MicroDVD#Format)
- [MPL2](http://svn.gna.org/svn/gaupol/trunk/doc/formats/mpl2-eng.html)
- TMPlayer

## Supported Subtitle Providers
Napi currently supports 3 subtitle providers. It can download and convert subtitles from:
- [Napisy24](http://napisy24.pl)
- [NapiProjekt](http://www.napiprojekt.pl)
- [OpenSubtitles](https://www.opensubtitles.org)

## Advanced Usage

### Command Line
It is possible to run Napi in a background mode. To do so, use `-runInBackground` argument.
```bash
./Napi -runInBackground true
```

Napi also supports `-pathToScan` launch argument which is used to find all video files
at that path and download subtitles for all of them. To specify desired languages and
providers you can use UI preferences pane and/or use defaults.
```bash
./Napi -runInBackground true -closeApplicationWhenFinished true -pathToScan /Users/MyUser/Movies/
```

### LaunchAgent
[Here]() you can see an example of [LaunchAgent](https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html), which runs Napi to scan *Movies* folder every 2 hours. It is a good starting point for your own background downloader.

### Logging
If you need more details about what happens when application is running, you can look at `Napi.log` file located at `~/Library/Caches/com.mateuszkarwat.Napi/`. It's also a good idea to attach that file if you're creating an issue. It will help to find a problem you're facing.

-----
Thank you [Asia](https://www.linkedin.com/in/joannahrycalik) for your testing contribution to this project.

[![donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=7SZZGSVAGTLK2&lc=US&item_name=Mateusz%20Karwat&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)
