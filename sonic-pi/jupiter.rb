# Alexandre rANGEL
# 'jupiter coming with the wolves' (v13)
# www.quasecinema.org
# 28-Feb-2016 / Sonic Pi 2.12

arrangement = true
mybpmbase = 120
mybpm = mybpmbase # * 2 #6, 8, 12, 16, 4, 2
use_bpm mybpm
startClock = 0 # 0 to start song at beginning
clock = startClock # global var
bar = 0 # global var
set_sched_ahead_time! 1
set_volume! 1.0 #1.1 #0.75
t = Time.new
x = ((t.year - t.month - t.day - t.hour - t.min - t.sec) * 1).to_int
puts "x = #{x}"
use_random_seed = x #1946 1966 1858
# http://www.freesound.org/people/clarinet_pablo_proj/sounds/248870/
# http://www.freesound.org/people/bcnlab/sounds/270736/
# download 2 samples above, rename to rhodes120bpm.wav and clarinetf6.wav
sampleRhodes120bpm =  '/Users/piatra/Documents/SamplesPi/rhodes120bpm.wav' # your path here
sampleClarinetf6 = '/Users/piatra/Documents/SamplesPi/clarinetf6.wav'
load_samples [sampleRhodes120bpm, sampleClarinetf6, :bd_haus, :bd_pure, :bd_klub, :bd_fat]

live_loop :metro do
  
  mybpm = mybpmbase * [0.5,1,1,1,2].choose #ramdom bpms
  mybpm = mybpmbase / 2.0 if bar < 3
  
  with_bpm mybpm do
    cue :metro
    sleep 0.5
    clock = startClock + tick
    bar = (clock / 4) + 1
    puts "let's go!" if clock < 1
    puts "bar : #{bar}, bpm: #{mybpm}"
    puts ring( "1 !","2 ! !","3 ! ! !","4 ! ! ! !")[clock]
  end #mybpm
  
end #metro

with_fx :compressor, slope_below: 2.0, slope_above: 1.15, mix: 0.5 do
  live_loop :song1 do
    
    with_fx :slicer, phase: 4 do
      
      with_bpm mybpm do
        
        # the break
        if bar < (8+16) or bar > (24+16) then
          myAmp = 1.0
        else
          myAmp = 0.0
        end
        
        sample sampleRhodes120bpm, rate: 1.0 / 4.0,
          amp: 12 * myAmp,
          window_size: (ring 0.003333,0.002,0.001)[tick + 1]
        
      end
      
    end #slicer
    
    sleep ( (sample_duration sampleRhodes120bpm) * 4)
    
  end #:song1
  
  sleep 2 # offset
  
  live_loop :song2 do
    if bar > (24+16) then # the break
      
      with_fx :slicer, phase: 4, slope_down: 1.0/8.0 do
        
        with_bpm mybpm do
          
          sample sampleRhodes120bpm, rate: 1.0 / 4.0,
            amp: 7.777 * 1.3,
            window_size: (ring 0.003333,0.002,0.001)[tick],
            pitch: [12,14,16].choose
          
        end #bpm
        
      end #slicer
      
    end #if
    
    sleep ( (sample_duration sampleRhodes120bpm) * 4)
    
  end #:song2
  
  sleep 4
  
  with_fx :echo do
    with_fx :ixi_techno do
      
      live_loop :song3, phase: 0.5 do
        
        # the break
        if bar < (8+16) or bar > (24+16) then
          myAmp = 1.0
        else
          myAmp = 0.0
        end
        
        with_fx :slicer, phase: 8, slope_down: 1.0/8.0 do
          
          with_bpm mybpm do
            
            with_fx :flanger, phase: [0.250,0.5].choose,
            delay: [1,2,4].choose do
              
              with_fx :slicer,
                phase: 0.25 *0.5,
              slope_up: (ring 0,0.1,0,0.25)[tick/1] do
                
                sample sampleRhodes120bpm, rate: 1.0 / 4.0,
                  amp: 5.555 * myAmp,
                  window_size: (ring 0.001,0.003333,0.002,)[tick],
                  pitch: -24
                
              end #:slicer
            end #:flanger
            
          end #:slicer
          
          sleep ((sample_duration sampleRhodes120bpm) * 4.0)
          
        end
        
      end #:song3
      
    end #:ixi
  end #:echo
  
  #sleep 24
  
  live_loop :scream1 do
    
    with_bpm mybpm do
      
      sample sampleClarinetf6, pitch: rrand(-36,-12),
        window_size: (ring 0.003333,0.002,0.001,rrand(0.0001,0.01))[tick],
        beat_stretch: (ring 16,1,2,1,4,1,2,1,8)[tick] * 2,
        pan: rrand(-0.2,0.2), pan_slide: (ring 0.5,1,2,4,8)[tick],
        rate: [-1,1].choose, amp: rrand(1.0,1.25)
      
      sleep (sample_duration sampleClarinetf6) *0.25
      
      sample sampleClarinetf6, pitch: rrand(-36,-20),
        window_size: (ring 0.003333,0.002,0.001,rrand(0.0001,0.01))[tick],
        beat_stretch: (ring 1,2,1,4,1,2,1,8)[tick] * 2,
        rate: [-1,1,-1].choose, amp: 0.25 if one_in(8)
      
      sleep (sample_duration sampleClarinetf6) *0.5
      
      sample sampleClarinetf6, pitch: rrand(-24,-12),
        window_size: (ring 0.003333,0.002,0.001,rrand(0.0001,0.01))[tick],
        beat_stretch: (ring 1,2,1,4,1,2,1,8)[tick] * 2,
        rate: [-1,1,1,-1].choose, amp: 0.25 if one_in(6)
      
      sleep (sample_duration sampleClarinetf6) *0.25
      
      with_fx :slicer, phase: 0.25 do
        sample sampleClarinetf6, pitch: rrand(-36,-16),
          window_size: (ring 0.003333,0.002,0.001,rrand(0.0001,0.01))[tick-1],
          beat_stretch: (ring 4,8,16,32,64)[tick] * 2,
          pan: rrand(-0.5,0.5), pan_slide: (ring 4,8,16,32,64)[tick],
          rate: [1,-1,1].choose, amp: 0.25 if one_in(16)
        
      end #:slicer
      
      sleep (sample_duration sampleClarinetf6) * [1,2,4].choose
      
    end
    
  end #if
  
  #######################################################################
  
  live_loop :scream2 do
    
    if bar > (12+16) and bar < (36+16) then # the break
      
      with_bpm mybpm do
        
        sample sampleClarinetf6, pitch: rrand(-36,-12),
          window_size: (ring 0.003333,0.002,0.001,rrand(0.0001,0.01))[tick],
          beat_stretch: 16,
          pan: rrand(-0.2,0.2), pan_slide: (ring 0.5,1,2,4,8)[tick],
          rate: [-1,1].choose, amp: rrand(1.0,1.25) * 2
        
        sleep (sample_duration sampleClarinetf6) *0.25
        
        sample sampleClarinetf6, pitch: rrand(-36,-20),
          window_size: (ring 0.003333,0.002,0.001,rrand(0.0001,0.01))[tick],
          beat_stretch: 8, rate: [-1,1,-1].choose, amp: 0.5
        
        sleep (sample_duration sampleClarinetf6) *0.5
        
        sample sampleClarinetf6, pitch: rrand(-24,-12),
          window_size: (ring 0.003333,0.002,0.001,rrand(0.0001,0.01))[tick],
          beat_stretch: 4, rate: [-1,1,1,-1].choose, amp: 0.25
        
        sleep (sample_duration sampleClarinetf6) *0.25
        
        with_fx :slicer, phase: 0.25 do
          sample sampleClarinetf6, pitch: rrand(-36,-16),
            window_size: (ring 0.003333,0.002,0.001,rrand(0.0001,0.01))[tick-1],
            beat_stretch: (ring 4,8,16,32,64)[tick] * 2,
            pan: rrand(-0.5,0.5), pan_slide: (ring 4,8,16,32,64)[tick],
            rate: [1,-1,1].choose, amp: 0.25 if one_in(16)
        end #:slicer
      end #bpm
      
    end #if
    
    sleep (sample_duration sampleClarinetf6) * [1,2,4].choose
    
  end #:scream2
  #######################################################################
end #:compressor
#######################################################################

live_loop :hat do
  x = [0.05,0.1].choose # [0.25/2.0,0.25/2.0].choose #offset
  
  if bar < (10+16) or bar > (23+16) then
    
    with_fx :echo, phase: [0.25,0.5].choose,
    mix: rrand(0.5,0.9) do
      with_fx :reverb, mix: 0.2 do
        use_synth :cnoise
        play rrand(90,120), attack: 0.05, release: rrand(0.1,0.12),
          sustain: 0.05,
          amp: rrand(0.10,0.16) *0.6
        
        sleep x #offset
        
        use_synth :pnoise
        play rrand(90,120), attack: 0.05, release: rrand(0.05,0.07),
          sustain: 0.05,
          amp: rrand(0.10,0.14) *0.6
        
      end
    end
  end #if
  
  sleep ((ring 1,0.5,1,0.25)[tick] * 1) - x
  sleep 4 if one_in(64)
  
end #hat
#############################################################

live_loop :kick do
  
  if bar < (8+16) or bar > (22+16) then
    if bar > 4 then
      if bar < 22 or bar % 13 == 0 then
        with_fx :slicer, phase: 0.25 do
          with_fx :ixi_techno, mix: 0.4, res: rrand(0.1,0.3),
          phase: (ring 0.25,48,0.5,24,16,8,4)[tick/4] do
            with_fx :echo, phase: 1.0 / 4.0, reps: 2, mix: 0.666 do
              sample :bd_fat,
                amp: rrand(0.6,0.8) * (ring 0.4,0.5,0,0.4,0.2)[tick/4] * 4,
                pan: rrand(-0.333,0.333), pan_slide: 1.0 / 8.0
              sleep 1.0
            end #fx
          end #fx
        end #fx
      else
        sample :bd_zome,
          amp: rrand(0.8,1.0) * (ring 0.2,0.5,0,0.333,0)[tick/8] * rrand(1.2,1.5),
          rate: -(1.0/[1.0,2.0,3.0,4.0,8.0].choose), window_size: rrand(0.001,0.002),
          beat_stretch: (ring 0.5,1,2,4,8)[tick/4]
        with_fx :reverb, room: 0.5 do
          sample [:drum_bass_hard,:drum_bass_soft].choose, amp: (ring 0,1,1.5,2.0,0)[tick/4]
        end #fx
        sleep 1
      end #if
      sample :bd_klub, amp: rrand(0.8,1.0) *6.4
    end #if
  end #if
  
  sleep 1
  
  sleep 4 if bar > (24+16) and one_in(24)
  
end #kick
#############################################################