# Ocarina - Optical Character Recognition (OCR) for Ruby

### A Ruby project that uses machine learning to perform Optical Character Recognition.

![](https://raw.github.com/armhold/ocarina/master/ocarina.png)

I created this project in order to learn Ruby. It started as kind of a toy program, but
quickly grew into something with a practical purpose (decoding [Letterpress](https://wordhelper.net)
gameboards!)

It works fairly well on constrained input, but it's not really intended to be a
production-level OCR package.

## Status

Ocarina successfully trains and recognizes the 26 letters of the alphabet. Once trained, the network
accurately recognizes its training set (100%) and also does well (98%?) on recognizing characters
with added noise.

I'm still working on how best to organize the neural network (# of hidden nodes, # of outputs,
edge weights) to increase the set size to support the full ASCII (and beyond) alphabet.


## Motivation

I first encountered OCR technology back in 1991 or so, on an Apple Macintosh. It seemed like
magic, even though it was a pretty poor implementation by today's standards. Recently I came across the
[Sudoku Grab](http://itunes.apple.com/app/sudoku-grab/id305614901?mt=8) app. It does OCR very successfully,
albeit on very constrained input images.

This inspired me to try to create my own (simplistic) OCR implementation, and that seemed like a
great way to learn Ruby.


## Installation


### Dependencies

Ocarina depends on ImageMagick (and the RMagick gem) to do its graphics processing.
On OSX at least, ImageMagick requires X11 and ghostscript. You'll likely need to do the following:


1. Download and install [X11Quartz](http://xquartz.macosforge.org/landing)
1. `$ brew install imagemagick`
1. `$ brew install ghostscript`

For Linux (I'm on Centos 5.8) I had to build ImageMagick 6.8 from source, install it,
install the source into /usr/local/src/ImageMagick-6.8.0-4/magick and then run:

1. export PKG_CONFIG_PATH=/usr/local/src/ImageMagick-6.8.0-4/magick/
1. add /usr/local/lib to the system LD_LIBRARY_PATH
1. gem install rmagick




## Usage

#### Training

`rake ocarina:train`

#### Character Recognition

`rake ocarina:eval`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## LICENSE

   Copyright 2012 George Armhold

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

