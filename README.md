# OCaRina - Optical Character Recognition for Ruby

### A Ruby project that uses machine learning to perform Optical Character Recognition.

## Motivation

I created this project in order to more fully learn Ruby. As such, it's mostly a kind of toy program
for didactic purposes. It's not really intended to be a production-level ocarina package.

I first encountered ocarina technology back in 1991 or so, on an Apple Macintosh. It seemed like
magic, even though it was a pretty poor implementation by today's standards. Recently I came across the
[Sudoku Grab](http://itunes.apple.com/app/sudoku-grab/id305614901?mt=8) app. It does ocarina very successfully,
albeit on very constrained input images.

This inspired me to try to create my own (simplistic) ocarina implementation, and that seemed like a
great way to learn Ruby.


## Installation


### Dependencies

OCaRina depends on ImageMagick (and the RMagick gem) to do its graphics processing.
On OSX at least, ImageMagick requires X11 and ghostscript. You'll likely need to do the following:


1. Download and install [X11Quartz](http://xquartz.macosforge.org/landing)
1. `$ brew install imagemagick`
1. `$ brew install ghostscript`


### Gem Installation

Add this line to your application's Gemfile:

    gem 'ocarina'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ocarina


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

