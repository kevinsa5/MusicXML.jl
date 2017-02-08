# MusicXML

A simple parser for MusicXML files, designed to be used with the MXMLSynth library.  Very much still a work in progress.

Example usage:

    using MusicXML
    using MXMLSynth
    using PortAudio
    using SampledSignals

    cd(joinpath(homedir(), "MusicXML", "mxml_tests"))

    @time begin
      song = MusicXML.parseMXMLFile("fur_elise.xml")
      sb = MXMLSynth.synthesizeTrack(song)
    end

    sbs = SampleBufSource(sb)
    out = PortAudioStream("default")
    write(out, sbs)
    #MXMLSynth.saveTrack(joinpath(homedir(), "furry-lease2.ogg"), sb)
