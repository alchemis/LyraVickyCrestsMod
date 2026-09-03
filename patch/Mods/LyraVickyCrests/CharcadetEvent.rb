if !(File.exist?('patch/Init/0000.cache_injection.rb') or !File.exist?('patch/Init/0000.map_injection.rb')) then 
  print("Error, patching libraries not found. Please download 0000.cache_injection.rb and 0000.map_injection.rb from wiresegal's modpack at: github.com/yrsegal/rejuvenation-modpack")
end

ModCacheInjection.hook(:bosses) {
  $cache.bosses[:LVCGRISELDAGUARD] = BossData.new(:LVCGRISELDAGUARD, {
    name: "Agravain",
    entrytext: "...", #placeholder
    shieldcount: 2,
    immunities: {},
    moninfo: {
      species: :CERULEDGE,
      level: 80,
      form: 0, #make form 1 when created
      item: :MAGICALSEED,
      moves: [:BITTERBLADE, :HEXINGSLASH, :VORPALBLADE, :KINGSSHIELD], #change King's Shield to Queen's Guard when created
      gender: :F, 
      ability: :SHARPNESS,
      nature: :JOLLY,
      iv: 31,
      happiness: 0,
      shiny: true, 
      ev: [0, 252, 0, 0, 252, 252],
    },
    onBreakEffects: {
      1 => {
        threshold: 0,
        message: "Agravain is being fueled by her regrets!",
        statDropCure: true, 
        statusCure: true,
        effectClear: true,
        itemchange: :FIREGEM,
        bossStatChanges: => {
          PBStats::ATTACK => 1,
          PBSTATS::SPEED => 1
        }
      },
      2 => {
        threshold: 0,
        fieldChange: :FAIRYTALE,
        fieldChangeMessage: "Agravain has brought us back to better times to make her final stand!"
        statDropCure: true,
        statusCure: true,
        effectClear: true,
        itemchange: :MAGICALSEED,
        bossStatChanges: => {
          PBStats::DEFENSE => 1,
          PBStats::SPDEF => 1
        }
      }
    }
  })
   $cache.bosses[:LVCGRISELDAGUARD_A] = BossData.new(:LVCGRISELDAGUARD_A, {
    name: "Gawain",
    entrytext: "...", #placeholder
    shieldcount: 2,
    immunities: {},
    moninfo: {
      species: :ARMAROUGE,
      level: 80,
      form: 0, #make form 1 when created
      item: :MAGICALSEED,
      moves: [:ARMORCANNON, :AURASPHERE, :TERRAINPULSE, :HEALPULSE],
      gender: :F, 
      ability: :MEGALAUNCHER,
      nature: :TIMID,
      iv: 31,
      happiness: 0,
      shiny: true, 
      ev: [0, 0, 252, 252, 0, 252],
    },
    onBreakEffects: {
      1 => {
        threshold: 0,
        weatherChange: [:SUNNYDAY, 5, nil],
        message: "Gawain's hatred is burning like the Sun!",
        statDropCure: true, 
        statusCure: true,
        effectClear: true,
        itemchange: :FIREGEM,
        bossStatChanges: => {
          PBStats::SPATK => 1,
          PBSTATS::SPEED => 1
        }
      },
      2 => {
        threshold: 0,
        overlay: :PSYTERRAIN
        overlayMessage: "Gawain is warping spacetime in her desperation!"
        statDropCure: true,
        statusCure: true,
        effectClear: true,
        itemchange: :MAGICALSEED,
        movesetUpdate: [:ARMORCANNON, :EXPANDINGFORCE, :TERRAINPULSE, :HEALPULSE]
        bossStatChanges: => {
          PBStats::DEFENSE => 1,
          PBStats::SPDEF => 1
        }
      }
    }
  })
}

def lvcknight_givebossreward(rene = false)
  poke=PokeBattle_Pokemon.new(:CHARCADET,5,$Trainer,false)
  poke.pbLearnMove(:HEXINGSLASH)
  poke.pbLearnMove(:VORPALBLADE)
  poke.pbLearnMove(:TERRAINPULSE)
  poke.pbLearnMove(:HEALPULSE)
  poke.item = :LIFEORB
  poke.ot = "Griselda"
  poke.id = "05772"
  poke.obtainMode = 4
  poke.obtainLevel = 5
  poke.makeShiny
  pbAddPokemon(poke)
end

InjectionHelper.defineMapPatch(219) { # Lost Castle
  createNewEvent(93, 24, "lvc knight boss", "lvcknightboss") { 
    newPage {
      @step_anime = true
      @move_speed = 1
      @move_frequency = 1
      @direction_fix = true
      requiresSwitch 0291 #defeated Gym 9
      setGraphic 'knight', direction: :Down, hueShift: 180 
      interact {
        text "Test"
        text "Battle? (Level 80+)\|"
        text "Warning, this battle is not yet avaliable in Story Mode."
        show_choices {
          choice("No") {}
          choice("Yes") {
            branch('pbDoubleWildBattle(:LVCGRISELDAGUARD, 80, :LVCGRISELDAGUARD_A, 80)'){
              text "A Charcadet came out of nowhere!?!" 
              script 'lvcknight_givebossreward'
              self_switch["A"] = true
            }
          }
        }
      }
    }
    newPage { requiresSelfSwitch 'A' }
  }
}

ModCacheInjection.hook(:pkmn) {
  ModCacheInjection.createNewForm(:CHARCADET,"Ghovoran Guard",1,
      {
		    :Abilities => [:SWORNDUTY],
        :ExcludeDex => true,
      }
  )
  ModCacheInjection.createNewForm(:CERULEDGE,"Ghovoran Guard",1,
      {
        :BaseStats => [75, 125, 80, 60, 100, 85],
		    :Abilities => [:SHARPNESS],
        :preevo => {
          :species => :CHARCADET,
          :form => 1,
        },
        :ExcludeDex => true,
      }
  )
  ModCacheInjection.createNewForm(:ARMAROUGE,"Ghovoran Guard",1,
      {
        :BaseStats => [80, 60, 100, 125, 80, 75], 
		    :Abilities => [:SHARPNESS],
        :preevo => {
          :species => :CHARCADET,
          :form => 1,
        },
        :ExcludeDex => true,
      }
  )
}

# TO-DO:
#   DONE 1. Add Charcadet Form 1 (Only difference between it and Form 0 is that it evolves into...)
#   DONE 2. Add Ceruledge and Armarouge Form 1 (Sharpness/Mega Launcher and Relearns Hexing Slash/Vorpal Blade and Terrain Pulse/Heal Pulse respectively)
#   3. Add "Queen's Guard", a Ghost-type Follow Me variant that also Protects the user from damaging moves. (Ceruledge/Armarouge Form 1 learns on Evo.)
#      > "The user protects its ally from any attack!" or something like that for a description? maybe reference Griselda?
#   4. Make Vorpal Blade into a Sharp move. Why isn't it already a Sharp move?
#   5. ??? I added a 5 but I forgot what I was supposed to do.... uh oh -Victory