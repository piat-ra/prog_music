# Snippets

 A file to track some cool sounding snippets with notes

## Careful with that Axe, Eugene

``` ruby
loop do
  with_fx :slicer, phase: 0.125 do
    synth :zawa, note: :e1, release: 8, cutoff: 70
    synth :zawa, note: :e1 + 4, release: 8, cutoff: 80
    sleep 0.125
  end
end
```

This little chunk makes nice use of the `slicer` filter. The trick will be to tie the note to a MIDI or OSC slider..

## Selecting notes and using `slider` and `cutoff`

```ruby
live_loop :dark_mist do
  co = (line 70, 130, steps: 8).tick
  note_1 = chord(:e1, :minor7).choose
  with_fx :slicer, probability: 0.7, prob_pos: 1 do
    synth :prophet, note: note_1, release: 8, cutoff: co
  end
  
  with_fx :slicer, phase: [0.125, 0.25].choose do
    sample :guit_em9, rate: 0.5
  end
  sleep 8
end

live_loop :crashing_waves do
  with_fx :slicer, wave: 0, phase: 0.25 do
    sample :loop_mika, rate: 0.5
  end
  sleep 16
end
```

Very grungy synthwave feel. Lots of legs here.