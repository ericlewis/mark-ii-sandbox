# Fsticuffs Kaldi - Customizable Offline Speech to Text


## Installation

Requirements:

* Python 3.7 or later
* A model (e.g., `data-en-us.tar.gz`) unzipped into the `data` directory 
* A Kaldi installation (e.g., `kaldi-x86_64.tar.gz`) unzipped into the `kaldi` directory
    * **NOTE**: You must select the Kaldi version compiled for your CPU

## Running

Once installed, use the `train.sh` script in the root directory. For example:

``` sh
./train.sh examples/demo.ini
```

This will create an `output` directory with the trained model.

Now, use `test.sh` to transcribe a WAV file:

``` sh
./test.sh /path/to/file.wav
```

The transcription will be printed to standard output.

If you have custom [slot files](https://rhasspy.readthedocs.io/en/latest/training/#slots-lists), put them in the `slots` directory.


## Sentence Templates

See the [Rhasspy docs](https://rhasspy.readthedocs.io/en/latest/training/#sentencesini) for details on the template language. Not all features from Rhasspy are supported.

Supported features:

* Words with substitutions
    * `word:sub` will expect "word" to be spoken, but produce "sub" in the transcript
    * `word:(sub1 sub2)` will substitute multiple words
* Groups
    * `(word1 word2)` is a series of words, one after the other
    * `(word1 | word2)` is an **alternative** where either `word1` or `word2` can be spoken
* Optionals
    * `[word]` means a word may or may not be spoken
    * `[word1 | word2]` means either `word1` or `word2` may or may not be spoken
    * **NOTE**: The brackets `[...]` must surround an entire word, not just part of it
* Numbers and ranges
    * Any number will be automatically expanded, e.g. "123" to "one hundred twenty three"
    * The original number is automatically substituted, so "123" will appear in the transcript instead of "one hundred twenty three"
    * `N..M` where `N` and `M` are numbers will be expanded to the an alternative with each number in the range (inclusive)
        * `1..3` will be equivalent to `(one:1 | two:2 | three:3)`


## Guessing Word Pronunciations

Words that are not in the lexicon (`data/<lang>/lexicon.db`) have their pronunciations guessed with [phonetisaurus](https://github.com/AdolfVonKleist/Phonetisaurus).


## Custom Words

Put your custom word pronunciations in `output/custom_words.txt` with the format:

``` 
<word> <phoneme> <phoneme> ...
<word> <phoneme> <phoneme> ...
```

Run `train.sh` again to have them written to your model's lexicon (in `output/acoustic_model/data/local/dict/lexicon.txt`).


## Data Directory

Example `data` directory:

* `data`
    * `en-us`
        * `acoustic_model` - Kaldi model
        * `g2p.fst` - Phonetisaurus model for guessing word pronunciations
        * `lexicon.db` - Sqlite database with known word pronunciations


## Kaldi Directory

Example `kaldi` directory:

* `kaldi`
    * `bin` - executable files for Kaldi, Phonetisaurus and OpenFST
    * `lib` - `.so` files for Kaldi, Phonetisaurus, OpenFST
    * `egs`
        * `wsj` - Wallstreet Journal example from Kaldi repo
            * `s5`
                * `steps`
                * `utils`