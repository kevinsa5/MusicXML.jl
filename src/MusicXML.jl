module MusicXML

using LightXML

@enum STEP C=1 D=3 E=5 F=6 G=8 A=10 B=12
@enum TYPE whole=1 half=2 quarter=3 eighth=4 sixteenth=5 thirtysecond=6

type Pitch
  step::STEP
  octave::Int
  alter::Int
end

type Note
  pitch::Pitch
  duration::Int
  voice::Int
  notetype::TYPE
  isrest::Bool
end

type Measure
  notes::Array{Note, 1}
end

type Part
  measures::Array{Measure, 1}
end

type MXMLTree
  parts::Array{Part, 1}
end

function parseMXMLFile(fname::String)
  xmlfile = parse_file(fname)
  return parseMXMLTree(root(xmlfile))
end

function parseMXMLTree(root::XMLElement)
  parts = Part[]
  for c1 in child_elements(root)
    if LightXML.name(c1) == "part"
      measures = Measure[]
      for c2 in child_elements(c1)
        if LightXML.name(c2) == "measure"
          notes = Note[]
          for c3 in child_elements(c2)
            if LightXML.name(c3) == "note"
              c4 = find_element(c3, "pitch")
              step = A
              octave = 0
              alter = 0
              isrest = true
              if typeof(c4) != Void
                step = eval(parse(content(find_element(c4, "step"))))
                octave = parse(content(find_element(c4, "octave")))
                alternode = find_element(c4, "alter")
                alter = typeof(alternode) == Void ? 0 : parse(content(alternode))
                isrest = false
              end
              p = Pitch(step, octave, alter)
              duration = parse(content(find_element(c3, "duration")))
              voice = parse(content(find_element(c3, "voice")))
              notetype = quarter #eval(parse(content(find_element(c3, "type"))))

              push!(notes, Note(p, duration, voice, notetype, isrest))
            end
          end
          push!(measures, Measure(notes))
        end
      end
      push!(parts, Part(measures))
    end
  end
  return MXMLTree(parts)
end

end
