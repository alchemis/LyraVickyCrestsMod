#very heavy spoilers in this file! If you havent completed the game, dont look!
#if you want to remove modded crests from enemy trainers, just delete this!

ModCacheInjection.hook(:trainers) {
  def lvc_getTrainer(array) #saves me having to reorder these all the time
      return $cache.trainers[array[1]][array[0]][array[2]]
  end
  # ADDED CRESTS
  #   
  #
  #
  #Krickcrest Havers
  #none...
  #heliolisk
  lvc_getTrainer(["Neptune", :CHALLENGER, 0]).party[0][:item] = :LVCHELIOCREST
  lvc_getTrainer(["Neptune", :CHALLENGER, 0]).party[0][:moves] = [:SHEDTAIL, :THUNDER, :HYPERVOICE, :FOCUSBLAST] #replaced surf -> focusblast due to crest
  #maractus
  #none...
  
  #roserade
  lvc_getTrainer(["Keta", :LEADER_KETA2, 0]).party[1][:item] = :LVCROSECREST
  lvc_getTrainer(["Keta", :LEADER_KETA2, 0]).party[1][:moves] = [:BULLETSEED, :PINMISSILE, :POISONJAB, :STUNSPORE]
  #raichu
  #Kieran
  lvc_getTrainer(["???", :UNKNOWN_1, 0]).party[0][:item] = :LVCRAICHUCREST 
  lvc_getTrainer(["???", :UNKNOWN_1, 1]).party[0][:item] = :LVCRAICHUCREST
  lvc_getTrainer(["Kieran", :UNKNOWN_1, 2]).party[2][:item] = :LVCRAICHUCREST #there are more kieran battles but in those the raichu is holding aloraichumz
  #others
  lvc_getTrainer(["Eizen", :EIZEN, 0]).party[4][:item] = :LVCRAICHUCREST
  lvc_getTrainer(["Erick", :LEADER_ERICK, 0]).party[1][:item] = :LVCRAICHUCREST
  lvc_getTrainer(["Jean", :SPIRITJEAN, 0]).party[0][:item] = :LVCRAICHUCREST

  #klinklang
  lvc_getTrainer(["Escavalier", :ANCIENT, 0]).party[0][:item] = :LVCKLINCREST

  #clear
  lvc_getTrainer(["Clear", :UNKNOWN_2, 0]).party[4][:item] = :LVCKLINCREST
  lvc_getTrainer(["Clear", :UNKNOWN_2, 0]).party[4][:moves] = [:SHIFTGEAR, :GEARGRIND, :POWERGEM, :ZAPCANNON] #return -> powergem
  lvc_getTrainer(["???", :UNKNOWN_2, 1]).party[1] = {
          :species => :KLINKLANG,
          :level => 84,
          :item => :LVCKLINCREST,
          :moves => [:ZAPCANNON, :FLASHCANNON, :POWERGEM, :VOLTSWITCH],
          :ability => :PLUS,
          :nature => :BOLD,
          :iv => 31,
          :happiness => 255,
          :ev => [0, 0, 252, 0, 252, 4],
        }
  lvc_getTrainer(["???", :UNKNOWN_2, 0]).party[4][:disguise][:item] = :LVCKLINCREST
  lvc_getTrainer(["Aelita", :STUDENT_3, 1]).party[5][:item] = :LVCKLINCREST
  lvc_getTrainer(["Aelita", :STUDENT_3, 1]).party[5][:ev] = [0, 0, 0, 252, 252, 4]
  lvc_getTrainer(["Aelita", :STUDENT_3, 1]).party[5][:nature] = :BOLD
  lvc_getTrainer(["Aelita", :STUDENT_3, 1]).party[5][:moves] = [:ZAPCANNON, :FLASHCANNON, :POWERGEM, :VOLTSWITCH]
  lvc_getTrainer(["Risa?", :CLEARISA, 0]).party[4] = {
          :species => :KLINKLANG,
          :level => 91,
          :item => :LVCKLINCREST,
          :moves => [:ZAPCANNON, :FLASHCANNON, :POWERGEM, :VOLTSWITCH],
          :ability => :CLEARBODY,
          :gender => :M,
          :nature => :BOLD,
          :happiness => 255,
          :form => 0,
          # flavor data
          :originalTrainer => "Risa",
          :iv => 31,
          :ev => [0, 0, 252, 0, 252, 4],
          :disguise => {
            :species => :TOXTRICITY,
            :level => 89,
            :item => :AIRBALLOON,
            :moves => [:SHIFTGEAR, :GEARGRIND, :WILDCHARGE, :RETURN],
            :ability => :PUNKROCK,
            :gender => :M,
            :nature => :ADAMANT,
            :iv => 31,
            :form => 0,
            :happiness => 255,
            :name => "Toxtricity",
            :ev => [0, 252, 0, 0, 4, 252],
          },
        }
  lvc_getTrainer(["Clear", :UNKNOWN_2, 4]).party[3] = {
          :species => :KLINKLANG,
          :level => 91,
          :item => :LVCKLINCREST,
          :moves => [:ZAPCANNON, :FLASHCANNON, :POWERGEM, :VOLTSWITCH],
          :ability => :CLEARBODY,
          :nature => :BOLD,
          :iv => 31,
          :happiness => 255,
          :ev => [0, 0, 252, 0, 4, 252],
          :disguise => {
            :species => :MISMAGIUS,
            :level => 90,
            :moves => [:CALMMIND, :SHADOWBALL, :FLASHCANNON, :THUNDERBOLT],
            :ability => :LEVITATE,
            :nature => :MODEST,
            :name => "Mismagius",
            :form => 0,
            :iv => 31,
            :ev => [252, 0, 4, 252, 0, 0],
          },
        }
  lvc_getTrainer(["Clear", :UNKNOWN_2, 3]).party[3] = {
          :species => :KLINKLANG,
          :level => 95,
          :item => :LVCKLINCREST,
          :moves => [:ZAPCANNON, :FLASHCANNON, :POWERGEM, :VOLTSWITCH],
          :ability => :PLUS,
          :nature => :BOLD,
          :iv => 31,
          :happiness => 255,
          :ev => [0, 0, 252, 0, 4, 252],
          # flavor data
          :obtaintype => 0,
          :originalTrainer => "Enya",
          :trainerID => 13803,
          :hiddenID => true,
          :catchlevel => 60,
          :catchtext => "Shattered Familiarity",
          :catchtime => [-45, 7, 13],
        }
  #oh my god that was a lot..

  #jenner
  lvc_getTrainer(["Jenner", :PROFJENNER, 0]).party[3][:item] = :LVCKLINCREST
  lvc_getTrainer(["Jenner", :SPIRITJENNER, 0]).party[5][:item] = :LVCKLINCREST
  lvc_getTrainer(["Jenner", :SPIRITJENNER, 0]).party[5] = {
          :species => :KLINKLANG,
          :level => 66,
          :moves => [:FLASHCANNON, :POWERGEM, :SUBSTITUTE, :ZAPCANNON],
          :ability => :PLUS,
          :item => :LVCKLINCREST,
          :happiness => 255,
          :nature => :BOLD,
          :ev => [4, 0, 252, 0, 0, 252],
          :iv => 31,
        }
  lvc_getTrainer(["Jenner", :PROFJENNER, 1]).party[3][:item] = :LVCKLINCREST
  lvc_getTrainer(["Jenner", :PROFJENNER, 2]).party[3][:item] = :LVCKLINCREST
  lvc_getTrainer(["Jenner", :PROFJENNER, 3]).party[3][:item] = :LVCKLINCREST
  #wailord
  lvc_getTrainer(["??? & ???", :MASKEDDUO, 0]).party[0][:item] = :LVCWAILCREST
  #tsareena
  lvc_getTrainer(["Madelis", :XENEXECUTIVE_2, 5]).party[2][:item] = :LVCTSARCREST
  lvc_getTrainer(["Madelis", :XENEXECUTIVE_2, 5]).party[2][:moves] = [:TROPKICK, :TRIPLEAXEL, :POWERWHIP, :LOWKICK]
  lvc_getTrainer(["Madelis", :XENEXECUTIVE_2, 1]).party[1][:item] = :LVCTSARCREST
  lvc_getTrainer(["Madelis", :XENEXECUTIVE_2, 1]).party[1][:moves] = [:TROPKICK, :BOUNCE, :NATUREPOWER, :LOWKICK]
  lvc_getTrainer(["Madelis", :XENEXECUTIVE_2, 4]).party[3][:item] = :LVCTSARCREST
  lvc_getTrainer(["Madelis", :XENEXECUTIVE_2, 4]).party[3][:moves] = [:NATUREPOWER, :HIJUMPKICK, :TROPKICK, :TRIPLEAXEL]
  lvc_getTrainer(["Madelis", :XENMADELIS, 2]).party[1][:item] = :LVCTSARCREST
  lvc_getTrainer(["Madelis", :XENMADELIS, 6]).party[2][:item] = :LVCTSARCREST
  lvc_getTrainer(["Madelis", :XENMADELIS, 6]).party[2][:moves] = [:POWERWHIP, :HIJUMPKICK, :KNOCKOFF, :TRIPLEAXEL]
  lvc_getTrainer(["Madelis", :XENMADELIS, 1]).party[3][:item] = :LVCTSARCREST
  lvc_getTrainer(["Madelis", :XENMADELIS, 1]).party[3][:moves] = [:POWERWHIP, :HIJUMPKICK, :PROTECT, :TRIPLEAXEL]


  lvc_getTrainer(["Cassandra", :XENADMIN_1, 2]).party[1][:item] = :LVCTSARCREST #i like to think this is madelis' tsareena

  lvc_getTrainer(["Novae", :WANDERER, 2]).party[3][:item] = :LVCTSARCREST
  lvc_getTrainer(["Novae", :WANDERER, 2]).party[3][:moves] = [:TROPKICK, :KNOCKOFF, :PLAYROUGH, :TRIPLEAXEL]
  lvc_getTrainer(["Novae", :WANDERER, 3]).party[1][:item] = :LVCTSARCREST
  lvc_getTrainer(["Novae", :WANDERER, 3]).party[1][:moves] = [:POWERWHIP, :HIJUMPKICK, :KNOCKOFF, :TRIPLEAXEL]
  #noivern
  lvc_getTrainer(["Jenner", :PROFJENNER, 0]).party[1][:item] = :LVCNOIVCREST
  lvc_getTrainer(["Jenner", :PROFJENNER, 0]).party[1][:moves] = [:DRAGONPULSE, :ROOST, :AIRSLASH, :HYPERVOICE]
  lvc_getTrainer(["Jenner", :SPIRITJENNER, 0]).party[2][:item] = :LVCNOIVCREST #alr has boomburst
  lvc_getTrainer(["Melia", :ENIGMA, 5]).party[0][:item] = :LVCNOIVCREST
  lvc_getTrainer(["Melia", :ENIGMA, 5]).party[0][:moves] = [:HYPERVOICE, :HEATWAVE, :DRAGONPULSE, :AIRSLASH]
  lvc_getTrainer(["Melia", :MELIA_AWAKEN, 3]).party[1][:item] = :LVCNOIVCREST
  lvc_getTrainer(["Melia", :MELIA_AWAKEN, 3]).party[1][:moves] = [:HYPERVOICE, :HEATWAVE, :DRAGONPULSE, :AIRSLASH]
  lvc_getTrainer(["Melia", :MELIA_AWAKEN, 4]).party[1][:item] = :LVCNOIVCREST
  lvc_getTrainer(["Melia", :MELIA_AWAKEN, 4]).party[1][:moves] = [:HYPERVOICE, :HEATWAVE, :DRAGONPULSE, :AIRSLASH]
  lvc_getTrainer(["Melia", :ENIGMA_1, 4]).party[0][:item] = :LVCNOIVCREST
  lvc_getTrainer(["Melia", :ENIGMA_1, 4]).party[0][:moves] = [:HYPERVOICE, :HEATWAVE, :DRAGONPULSE, :AIRSLASH]
  lvc_getTrainer(["Melia", :ENIGMA_2, 6]).party[1][:item] = :LVCNOIVCREST
  lvc_getTrainer(["Melia", :ENIGMA_2, 6]).party[1][:moves] = [:TAILWIND, :BOOMBURST, :DRAGONPULSE, :AIRSLASH]
  lvc_getTrainer(["Melia", :MELIA_AWAKEN, 1]).party[5][:item] = :LVCNOIVCREST
  lvc_getTrainer(["Melia", :MELIA_AWAKEN, 1]).party[5][:moves] = [:TAILWIND, :BOOMBURST, :DRACOMETEOR, :AIRSLASH]
  lvc_getTrainer(["Talon", :LEADER_TALON, 0]).party[0][:item] = :LVCNOIVCREST
  lvc_getTrainer(["Talon", :LEADER_TALON, 0]).party[0][:moves] = [:BOOMBURST, :DEFOG, :HURRICANE, :DRAGONPULSE]
  #tyrantrum
  lvc_getTrainer(["Vivian", :SENSEI_1, 0]).party[1][:item] = :LVCTYRACREST
  lvc_getTrainer(["Vivian", :SENSEI_1, 1]).party[2][:item] = :LVCTYRACREST
  lvc_getTrainer(["Aero", :TRAINER_AERO, 0]).party[3][:item] = :LVCTYRACREST #didnt add it to the skip teams i feel like if you want it you should go and buy it
  lvc_getTrainer(["Damien", :LEADER_DAMIEN, 2]).party[2][:item] = :LVCTYRACREST
  #aurorus
  lvc_getTrainer(["Alain", :TRAINER_ALAIN, 0]).party[2][:item] = :LVCAUROCREST 
  lvc_getTrainer(["Alain", :TRAINER_ALAIN, 0]).party[2][:moves] = [:POWERGEM, :EARTHPOWER, :HYPERVOICE, :HYPERBEAM] #meteorbeam -> powergem, because no power herb
  lvc_getTrainer(["Hazuki", :ROGUEHERO, 0]).party[2][:item] = :LVCAUROCREST
  lvc_getTrainer(["Hazuki", :ROGUEHERO, 0]).party[2][:moves] = [:AURORAVEIL, :BLIZZARD, :METEORBEAM, :EARTHPOWER] #meteorbeam -> powergem, same as above
  #jumpluff
  lvc_getTrainer(["Cyan", :POKEBREEDER_F, 0]).party[0][:item] = :LVCJMPLFFCREST #this one random npc gets it because yes
  #BRELOOM
  lvc_getTrainer(["??? & ???", :MASKEDDUO, 0]).party[2][:item] = :LVCBRELCREST
  lvc_getTrainer(["??? & ???", :MASKEDDUO, 0]).party[2][:moves] = [:FAKEOUT, :ZINGZAP, :GIGADRAIN, :SPORE]
  lvc_getTrainer(["Flora", :LEADER_FLORA, 0]).party[4][:item] = :LVCBRELCREST
  lvc_getTrainer(["Florin", :LEADER_FLORIN, 0]).party[4][:item] = :LVCBRELCREST
  lvc_getTrainer(["Florin", :LEADER_FLORIN, 0]).party[4][:moves] = [:SPORE, :MACHPUNCH, :ROCKTOMB, :GIGADRAIN]
  lvc_getTrainer(["Florin", :LEADER_FLORIN2, 0]).party[4][:item] = :LVCBRELCREST
  lvc_getTrainer(["Florin", :LEADER_FLORIN2, 0]).party[4][:moves] = [:SPORE, :MACHPUNCH, :ROCKTOMB, :GIGADRAIN]
  #archeops
  lvc_getTrainer(["Karen", :ELITE_KAREN, 0]).party[5][:item] = :LVCARCHCREST
  lvc_getTrainer(["Karen", :ELITE_KAREN, 0]).party[5][:moves] = [:ROOST, :ROCKSLIDE, :EARTHQUAKE, :TAILWIND]
  #none for carracosta...
  #ninetaleses
  lvc_getTrainer(["ALLEN", :JOHTO_1, 0]).party[2][:item] = :LVCATALESCREST
  lvc_getTrainer(["ALLEN", :JOHTO_1, 1]).party[2][:item] = :LVCATALESCREST
  lvc_getTrainer(["Prince Allen", :LEADER_ALLEN, 0]).party[3][:item] = :LVCATALESCREST
  lvc_getTrainer(["Prince Allen", :LEADER_ALLEN, 1]).party[0][:item] = :LVCATALESCREST
  lvc_getTrainer(["Allen", :LEADER_ALLEN2, 0]).party[4][:item] = :LVCATALESCREST
  lvc_getTrainer(["Lin", :CHAMPIONLIN, 0]).party[0][:item] = :LVCATALESCREST
  lvc_getTrainer(["Lin", :CHAMPIONLIN, 1]).party[0][:item] = :LVCATALESCREST
  #spirit keta has one but he already gets crested roserade
  lvc_getTrainer(["Spector", :LEADER_SPECTOR, 0]).party[4][:item] = :LVCNINETALESCREST
  #novae but she already has tsareena
  lvc_getTrainer(["Am", :XENEX_F, 0]).party[4][:item] = :LVCNINETALESCREST
  #all important altaria trainers have altarianite instead, except for...
  lvc_getTrainer(["Ren", :OUTCAST, 5]).party[1][:item] = :LVCALTACREST
  lvc_getTrainer(["Ren", :OUTCAST, 5]).party[1][:moves] = [:HYPERVOICE, :ALLURINGVOICE, :ROOST, :DRAGONBREATH]
  #no one has mightyena but i can see some of them having one... specially cass
  #none for mawile, all the important ones use mawilite, might replace some later
  #trevenant
  lvc_getTrainer(["Sariah", :GHOSTGIRL, 2]).party[3][:item] = :LVCTREVCREST
  lvc_getTrainer(["Sariah", :GHOSTGIRL, 2]).party[3][:moves] = [:LEECHSEED, :FORESTSCURSE, :HORNLEECH, :PROTECT]
  #haxorus
  lvc_getTrainer(["Kanon", :TRAINER_KANON, 0]).party[5][:item] = :LVCHAXCREST
  lvc_getTrainer(["Kanon", :TRAINER_KANON, 0]).party[5][:moves] = [:ROCKSLIDE, :DRAGONCLAW, :NIGHTSLASH, :BITTERBLADE]
  #no one has a screamtail or any of the others after this
  ## REPLACED MONS ##
  #Vitus renegade singles bossfight
  lvc_getTrainer(["Vitus", :ASPECTVITUS, 1]).party[4] = {
        :species => :SLAKING,
        :level => 100,
        :item => :LIFEORB,
        :moves => [:RETURN, :SUCKERPUNCH, :EARTHQUAKE, :FIREBLAST],
        :ability => :TRUANT,
        :gender => :M,
        :shiny => true,
        :form => 0,
        :nature => :ADAMANT,
        :iv => 31,
        :happiness => 255,
        :ev => [0, 252, 4, 252, 0, 252],
      } 
  lvc_getTrainer(["Vitus", :ASPECTVITUS, 1]).effects[4] = {
        :buffactivation => :Always,
        :sprite => :None,
        :message => "The Dimension empowered Slaking!",
        :applyCrest => :SLAKING,
        :pokemonStatChanges => {
          1 => 1,
          2 => 1,
        }
      }
}


