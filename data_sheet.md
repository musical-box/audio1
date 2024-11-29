# Model datasheet

This is a dataset of artificially reverberated speech utterances.

The speech utterances are a subset of the DARPA TIMIT acoustic-phonetic continuous speech corpus.
The artificially reverberated versions of the speech utterances are obtained using a subset of the Open Acoustic Impulse Response Library.

## Motivation

The TIMIT corpus includes time aligned orthographic, phonetic, and word transcriptions, as well as speech waveform data for each spoken sentence.
The TIMIT corpus of read speech has been designed to provide speech data for the acquisition of acoustic-phonetic knowledge and for the development and evaluation of automatic speech recognition systems. TIMIT has resulted from the joint efforts of several sites under sponsorship from the Defense Advanced Research Projects Agency - Information Science and Technology Office (DARPA-ISTO). Text corpus design was a joint effort among the Massachusetts Institute of Technology (MIT), Stanford Research Institute (SRI), and Texas Instruments (TI).

The Open Acoustic Impulse Response Library, is a research database of acoustic impulse response data and anechoic recordings of buildings and environments around the world, including locations in the UK.
The aim of the Open Acoustic Impulse Response (Open AIR) Library is to provide a centralised, feature rich and future proof on-line resource for anyone interested in auralization and acoustical impulse response data. For example it may be useful for researchers to quickly compare impulse responses recorded using different approaches, for developers of game audio wanting to recreate the acoustic environment of a specific building, or for musical composers looking for a desirable reverberation effect.
The Open AIR Library is developed and maintained by Audiolab, Department of Electronics, University of York.
 
## Composition

TIMIT contains a total of 6300 sentences, 10 sentences spoken by each of 630 speakers from 8 major dialect regions of the United States.

OpenAIR contains acoustic impulse response data of buildings and environments around the world.

For this dataset:
- the training set is a subset of 41 speech utterances selected from the TIMIT data set, and each utterance has been artificially reverberated using one of the 7 impulse responses from the OpenAIR data set, giving 287 samples.
- the validation set is a subset of the same 41 speech utterances, reverberated with an additional 49 impulse responses also obtained from the OpenAIR data set, giving 2009 samples.

## Collection process

The text material in the TIMIT prompts consists of 2 dialect sentences, 450 phonetically-compact sentences, and 1890 phonetically-diverse sentences.
The dialect sentences were read by all 630 speakers.
Each speaker read 5 of the phonetically-compact sentences.
Each speaker read 3 of the phonetically-diverse sentences.

The impulse response data is available in various common spatial audio formats (stereo, B-format, 5.1).

## Preprocessing/cleaning/labelling

All the speech samples were converted to mono, and normalised for loudness. The leading and trailing periods of silence were trimmed from the samples.
 
## Uses

This data set can be used for any other tasks related to analysing reverberated speech, for example estimating the reverberation time.

This data set should not, however, be directly used for extracting sections of speech or analysing phonemes, because of the distortion to the original signal caused by the artificial reverberation.

## Distribution

The TIMIT data set has been previously distributed on a CD-ROM and is being distributed online.

The Open Acoustic Impulse Response Library is being distributed online.

## Maintenance

The Open AIR Library is developed and maintained by Audiolab, Department of Electronics, University of York.

