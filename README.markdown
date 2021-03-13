# Fountain

Fountain is a simple markup syntax that allows screenplays to be written, edited, and shared in plain, human-readable text. Fountain allows you to work on your screenplay anywhere, on any computer, using any software that edits text files.

Like John Gruber’s Markdown, a priority of Fountain is that the raw file itself is eminently readable. Every effort has been made to impose a minimum of syntax requirements. When syntax is required, it should be intuitive. Even when viewed in plain text, your screenplay should feel like a screenplay.

Fountain supports everything that a writer is likely to need in the early, creative phases of writing. Not included are production features such as MOREs, CONTINUEDs, revision marks, locked pages, or colored pages.

Fountain is also a good format for archiving screenplays without worry of file-format obsolescence or incompatibility. For this reason, Fountain does support scene numbers.

For more details on Fountain see http://fountain.io.

## Overview

To encourage and ease integration of Fountain into your own apps we're making our own Fountain code available to you under a permissive MIT license. The code was designed for our own use, so your mileage may vary, but we're hoping this will at least help you get going with Fountain.

The Xcode project includes files to read and write Fountain files, and stores the file in a fairly generic data model. If this model is insufficient for your needs, or you have your own model you'd like to use, we recommend using a converter to bridge the two models.

One important note: we do not deal with text styling (bold, italic, underline, etc) in the parser or data model. We retain the styling and pass it along for downstream use. That is, whatever is supposed to display or print the Fountain file should handle text styling and clean up of the styling markup. We think that's just easier on everyone. We've included regular expressions for text styling, in case you need them.

## Components

### FNScript

FNScript is intended to make it easy to drop Fountain support into new apps. FNScript handles reading and writing of Fountain files, and holds the script content. The content of the script is represented as an NSArray of FNElements, and the title page is an NSArray of NSDictionary items.

### FNElement

This is the data model for the script elements.

### FastFountainParser

FastFountainParser is a redesigned line-by-line parser. The advantages to this parser over the previously used FountainParser are 1) less reliance on regular expressions (it should be much easier to change now) and 2) greatly improved performance. FastFountainParser is roughly 10 times faster than FountainParser. It is the default in FNScript, however you may still use the older FountainParser via using the FNParserTypeRegex option on the appropriate methods.

### FountainWriter

FountainWriter provides class methods to convert an FNScript into a Fountain NSString.

### FountainParser

FountainParser provides class methods to read a Fountain script's title page and script body separately. The body is returned as an NSArray of FNElements, and the title page is returned as an NSArray of NSDictionary items. This code is provided for legacy purposes.

### FountainRegexes

This file contains all the regular expressions used by FountainParser. It remains a part of this package because regular expressions provide the simplest route to portability. That said, please be aware that the regular expressions are not fully compliant with the tests, and may not be updated for a while.

## Installation

1. Copy all the files in the Fountain group to your project.
2. RegexKitLite requires the `-licucore` linker flag to be added to your project. See http://regexkit.sourceforge.net/RegexKitLite/#AddingRegexKitLitetoyourProject for help enabling RegexKitLite in your project.

If you don't want to use RegexKitLite you can remove the references to it in FountainParser.m and FountainWriter.m. You shouldn't have to change much code outside those files to change the regex library. While the regular expressions should be compatible with most standard regex implementation, you might have to massage them to work with a different library. Good luck with that.

## Usage

See the sample project for a simple example of how the classes here can be used.

## Testing

The Xcode project includes unit tests, along with sample files to play around with. At the moment, the tests aren't great, and need to be much more comprehensive, but they're there.

## License

All code is copyright Nima Yousefi &amp; John August. Released under an MIT license. Do whatever you want with this code, but it would be super cool if you shared your improvements with the world.

See the included LICENSE file for legal jargon.

## Contact

If you have any questions, or just want to say 'hi', you can catch me on Twitter [@nyousefi](http://twitter.com/nyousefi).

Follow Qapps on Twitter [@qapps](http://twitter.com/qapps).


## Credits

### Fountain Format

Fountain comes from several sources. John August and Nima Yousefi developed Scrippets, which used simple markup to embed screenplay-formatted material in websites. Stu Maschwitz drafted a more extensive spec known as Screenplay Markdown or SPMD, designed for full-length screenplays.

Stu and John discovered that they were simultaneously working on similar text-based screenplay formats, and merged them into what you see here. Other contributors to the spec include Martin Vilcans, Brett Terpstra, Jonathan Poritsky, and Clinton Torres.

### Fountain Code

The code included here was developed by Nima Yousefi and John August, with copious emotional and spiritual support by Ryan Nelson and Stuart Friedel. However, all invectives should be directly solely at Nima Yousefi (don't worry, he has it coming).
