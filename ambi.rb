in_thread do
  
  # initialize local variables
  scale_to_play = nil
  tonic_to_play = nil
  progression_to_play = nil
  rythm_to_play = nil
  
  # selects a scale randomly. although we will only work with major and minor for now.
  define :scale_selector do
    new_scale = scale_names.choose
    if scale_to_play == new_scale
      new_scale = scale_names.choose
    end
    new_scale
    
    scale_to_play = [:major, :minor].choose
  end
  
  # selects a tonic randomly ex. C4, F3
  # could add sharp and flats later on.
  define :tonic_selector do
    [:A,:B,:C,:D,:E,:F,:G].map do |item|
      [3,4].map { |num| "#{item}#{num}".to_sym }
    end.flatten.choose
  end
  
  # set the scale and tonic to be used in the notes and chords loop
  define :change_key do
    puts "Changing key and scale!"
    scale_to_play = scale_selector || scale_selector
    tonic_to_play = tonic_selector || tonic_selector
  end
  change_key # initialize the scale and tonic.
  
  # plays single notes for the 'melody'
  live_loop :notes do
    use_bpm rrand(60, 80)
    
    # randomly select a synth type, although for now we just use piano.
    synth_selector = [:piano].choose
    use_synth synth_selector
    
    # build a list of size between 0 and 4
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
    play_pattern_timed notes_array, [0.25,0.5,0.75,1].shuffle,
      amp: rrand(1,5),
      pitch: [12, 24].choose,
      attack: rrand(0.1, 0.2),
      decay: 0.2,
      sustain: 0.2,
      release: 0.2
    
    
    sleep rrand(20, 30)
  end
  
  # selects a chord progression randomly
  define :chord_progression_selector do
    progression = [[2,5,1], [1,7,6,5], [1,3,6,2,5,1], [6,4,1,5]].choose
    puts progression
    progression
  end
  
  # selects a time to run each loop for chords.
  define :chord_beats_selector do
    rrand(3,10)
  end
  
  # set rythm related variables
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
        amp: rrand(10,20),
        pitch: [0].choose,
        attack: rrand(0.1, 0.5),
        decay: 0.5,
        sustain: 0.5,
        release: 0.5
      
      sleep rrand(2,8)
    end
    
    # we want a chord progression to repeat for a certain amount of loops. If not the song is tooo random.
    # this code decides when to pick a new chord progression and tempo at which to play.
    puts "looped times #{looped_times}"
    if looped_times == 10
      
      change_key
      change_rythms
      
      looped_times = 0
    else
      looped_times += 1
    end
    
    sleep rythm_to_play
  end
end
