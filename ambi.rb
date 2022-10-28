in_thread do
  
  scale_to_play = nil
  tonic_to_play = nil
  progression_to_play = nil
  rythm_to_play = nil
  
  # selects a scale randomly
  define :scale_selector do
    new_scale = scale_names.choose
    if scale_to_play == new_scale
      new_scale = scale_names.choose
    end
    new_scale
    
    scale_to_play = [:major, :minor].choose # for now lets stick to major or minor.
  end
  
  # selects a key randomly ex. C4, F3
  define :tonic_selector do
    [:A,:B,:C,:D,:E,:F,:G].map do |item|
      [3,4].map { |num| "#{item}#{num}".to_sym }
    end.flatten.choose
  end
  
  # set the scale and key to be used in the notes and chords loop
  define :change_key do
    puts "Changing key and scale!!!!!!!!!!!!!!!!!!!!"
    scale_to_play = scale_selector || scale_selector
    tonic_to_play = tonic_selector || tonic_selector
  end
  change_key
  
  # plays single notes for the 'melody'
  live_loop :notes do
    use_bpm rrand(60, 80)
    
    # randomly select a synth type
    synth_selector = [:piano].choose
    use_synth synth_selector
    
    # build a list of size between 0 and 7
    # this list will decide how many notes and which notes
    # we play as a pattern.
    array = Array.new(rand(4))
    
    # builds a list of notes that will be played as a pattern.
    notes_array = array.map do |i|
      scale(tonic_to_play, scale_to_play, num_octaves: 3).choose
    end
    
    puts "Lets play some notes:"
    puts "#{scale_to_play} #{tonic_to_play}"
    puts "Notes: #{notes_array}"
    
    # plays the pattern
    # amp => is the volume
    play_pattern_timed notes_array, [1,2,3,4,5].shuffle,
      amp: rrand(10, 30),
      pitch: [12, 24].choose,
      attack: rrand(0.1, 0.2),
      decay: 0.2,
      sustain: 0.2,
      release: 0.2
    
    
    sleep rrand(20, 30)
  end
  
  # selects a chord progression randomly
  define :chord_progression_selector do
    progression = [[2,5,1], [1,7,6,5], [1,3,6,2,5,1]].choose
    puts progression
    progression
  end
  
  # selects a chord progression randomly
  define :chord_beats_selector do
    rythm = rrand(3,10)
    puts rythm
    rythm
  end
  
  define :change_rythms do
    progression_to_play = chord_progression_selector
    rythm_to_play = chord_beats_selector
  end
  change_rythms
  
  looped_times = 0
  
  live_loop :chords do
    
    use_bpm rrand(40,60)
    
    # randomly select a synth type
    synth_selector = [:piano].choose
    use_synth synth_selector
    
    # randomly select how many notes to play
    number_of_notes = [3,4,5].choose
    
    # randomly select which inversion to play
    inversion = [1,2,3].choose
    
    puts "Lets play some chords:"
    progression_to_play.each do |degree|
      print "#{scale_to_play} #{tonic_to_play}"
      print "number of notes: #{number_of_notes}"
      print "inversion: #{inversion}"
      print "degree: #{degree} for progression #{progression_to_play}"
      
      # play the chord
      # amp => is the volume
      play (chord_degree degree, tonic_to_play, scale_to_play, number_of_notes, invert: inversion),
        amp: rrand(30,90),
        pitch: [0].choose,
        attack: rrand(0.1, 0.5),
        decay: 0.5,
        sustain: 0.5,
        release: 0.5
      
      sleep rrand(2,8)
    end
    
    puts "looped times #{looped_times}"
    if looped_times == 10
      puts "in!"
      
      change_key
      change_rythms
      
      looped_times = 0
    else
      looped_times += 1
    end
    
    sleep rythm_to_play
  end
end
