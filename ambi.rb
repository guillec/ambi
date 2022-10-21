in_thread do
  
  # selects a scale randomly
  define :scale_selector do
    scale_names.choose
    :major
  end
  
  # selects a key randomly
  define :tonic_selector do
    [:A,:B,:C,:D,:E,:F,:G].choose
    :C
  end
  
  scale_to_play = nil
  tonic_to_play = nil
  
  # set the scale and key to be used in the notes and chords loop
  live_loop :change_key do
    scale_to_play = scale_selector #[:ussak]
    tonic_to_play = tonic_selector
    sleep rrand(100, 180) # lets change the key and scale every so often
  end
  
  # plays single notes for the 'melody'
  live_loop :notes do
    use_bpm rrand(60, 80)
    
    # randomly select a synth type
    synth_selector = [:piano].choose
    use_synth synth_selector
    
    # prints data to logs
    puts tonic_to_play
    puts scale_to_play
    puts synth_selector
    
    # build a list of size between 0 and 3
    # this list will decide how many notes and which notes
    # we play as a pattern.
    array = (0..3).to_a
    
    # builds a list of notes that will be played as a pattern.
    notes_array = array.map do |i|
      scale(tonic_to_play, scale_selector).choose
    end
    
    # builds a list to decide how long per note will the pattern play.
    time_array = array.map do |i|
      [1,2,3,4,5,6,7,8,9,10].choose
    end
    
    # plays the pattern
    # amp => is the volume
    play_pattern_timed notes_array, time_array, amp: rrand(10, 25), pitch: rrand(-5,0), attack: rrand(0.2, 0.7)
    
    sleep rrand(5, 7)
  end
  
  live_loop :extra_note_sprinkles do
    use_bpm 40
    
    # randomly select a synth type
    synth_selector = [:piano].choose
    use_synth synth_selector
    
    # prints data to logs
    puts tonic_to_play
    puts scale_to_play
    puts synth_selector
    
    # build a list of size between 0 and 3
    # this list will decide how many notes and which notes
    # we play as a pattern.
    array = (0..3).to_a
    
    # builds a list of notes that will be played as a pattern.
    notes_array = array.map do |i|
      scale(tonic_to_play, scale_selector).choose
    end
    
    # builds a list to decide how long per note will the pattern play.
    time_array = array.map do |i|
      [0.5,2].choose
    end
    
    # plays the pattern
    # amp => is the volume
    play_pattern_timed notes_array, time_array, amp: rrand(10, 25), pitch: rrand(-12,12), attack: rrand(0.5, 1)
    
    sleep rrand(5,10)
  end
  
  live_loop :chords do
    use_bpm rrand(40,60)
    
    # randomly select a synth type
    synth_selector = [:piano].choose
    use_synth synth_selector
    
    # prints data to logs
    puts tonic_to_play
    puts scale_to_play
    
    # randomly choose a degree to play
    degree = [1,2,3,4,5,6,7].choose
    
    # randomly select how many notes to play
    number_of_notes = [3,5,7].choose
    
    # randomly select which inversion to play
    inversion = [1,2,3].choose
    
    # play the chord
    # amp => is the volume
    play (chord_degree degree, tonic_to_play, scale_selector, number_of_notes, invert: inversion), amp: rrand(10,30), pitch: rrand(-12,1), attack: rrand(0.5, 1)
    sleep rrand(1, 6)
  end
end
