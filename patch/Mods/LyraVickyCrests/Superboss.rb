ModCacheInjection.hook(:trainertypes) {
  $cache.trainertypes[:LVCLYRA] = TrainerData.new(:LVCLYRA, {
    ID: "Lyra", #change this if we want custom sprites
    title: "Fallen Interceptor",
    skill: 100,
    moneymult: 40,
    battleBGM: "Battle - Space and Time.ogg"
  })
  $cache.trainertypes[:LVCVICTORY] = TrainerData.new(:LVCVICTORY, {
  ID: "Victory", #change this if we want custom sprites
  title: "Fallen Interceptor",
  skill: 100,
  moneymult: 40
})

def lvc_bossinit
  PokeBattle_AI.class_eval{  
  alias_method :lvc_superbossgetSwitchInScoresParty, :getSwitchInScoresParty if !defined?(lvc_superbossgetSwitchInScoresParty)
  def getSwitchInScoresParty(hard_switch, revival: false, doublereplace: false, batonpass: true)
      partyscores = lvc_superbossgetSwitchInScoresParty(hard_switch, revival: revival, doublereplace: doublereplace, batonpass: batonpass)
      if @battle.opponent.is_a?(Array) && !@battle.opponent.nil? && @battle.opponent[0].trainertype == :LVCVICTORY
        party = @battle.pbPartySingleOwner(@attacker.index)
        for partyindex in 0...party.length
              mon = party[partyindex]
              if mon.ev[5] == 252 && @battle.state.effects[:TrickRoom] > 0
                partyscores[partyindex] -= 500
              end
        end
        puts "Partycores adjusted, ignore log below"
        puts "It's incorrect because of my stupid hook, here's the actual switchscores:"
        puts partyscores
      end
      return partyscores
  end
  }
end

def lvc_changetospeedmode
    $battle.instance_eval{
      
      pkmn = nil
      for i in @battlers
        if i.applyingEntryEffects && pbIsOpposing?(i.index)
          pkmn = i
          break
        end
      end
      remaining = 0
      for mon in pbCombinedParty(pkmn.index) do
        remaining += 1 if mon && !mon.isEgg? && mon.hp > 0
      end
      if (!defined?(@lvc_musicchanged) || !@lvc_musicchanged) && remaining <= 6
        pbBGMPlay("Battle - Lonely Moon",position: 5, fadeIn: true)
        @lvc_musicchanged = true
      end
      return if defined?(@lvc_speedmodeused) && @lvc_speedmodeused
      if pkmn
        if @state.effects[:TrickRoom] > 0 || !pkmn.pbOwnSide.effects[:Tailwind] || pkmn.pbOwnSide.effects[:Tailwind] == 0
          trainer = @opponent[0] #pbGetOwner(pkmn.index) 
          ownername = trainer.name
          @scene.pbShowOpponent(0)
          showtrainer = true
          pbDisplayAutoPaused(_INTL("<char>{1}: Let's speed this up, shall we?", ownername.upcase))
          @lvc_speedmodeused = true
        end
        if @state.effects[:TrickRoom] > 0
          pbDisplay(_INTL("The twisted dimensions returned to normal!", pkmn.pbThis))
          pbAnimation(:TRICKROOM, pkmn, nil)
          @state.effects[:TrickRoom] = 0
        end
        if !pkmn.pbOwnSide.effects[:Tailwind] || pkmn.pbOwnSide.effects[:Tailwind] == 0
          pbDisplay(_INTL("A tailwind blew from behind the opposing team!", pkmn.pbThis))
          pbAnimation(:TAILWIND, pkmn, nil)
          pbApplySideEffect(:Tailwind, 5, pkmn.pbOwnSide, pkmn)
        end
        @scene.pbHideOpponent if showtrainer
      end

        

    }
end

}
ModCacheInjection.hook(:trainers) {
  $cache.trainers[:LVCLYRA] = {} unless $cache.trainers[:LVCLYRA]
  $cache.trainers[:LVCLYRA]["Lyra"] = {} unless $cache.trainers[:LVCLYRA]["Lyra"]
  $cache.trainers[:LVCVICTORY] = {} unless $cache.trainers[:LVCVICTORY]
  $cache.trainers[:LVCVICTORY]["Victory"] = {} unless $cache.trainers[:LVCVICTORY]["Victory"]

  $cache.trainers[:LVCLYRA]["Lyra"][0] = TeamData.new(0, ["Lyra", :LVCLYRA, 0], {
    :teamid => ["Lyra", :LVCLYRA, 0],
    :defeat => "LYRA: Such power...",
    :items => [:MEGARING],
    :mons => [
      { #tr side
        species: :AURORUS,
        level: 100,
        moves: [:BLOODMOON,:POWERGEM,:THUNDERBOLT,:BLIZZARD],
        item: :LVCAUROCREST,
        ability: :REFRIGERATE,
        nature: :QUIET,
        shiny: true,
        happiness: 255,
        ev: [252,0,0,252,0,0],
        iv: [31,31,31,31,31,0],
      },
      {
        species: :MAWILE,
        level: 100,
        moves: [:FLASHCANNON,:DRAININGKISS,:FIREBLAST,:ICEBEAM],
        item: :LVCMAWCREST,
        ability: :SHEERFORCE,
        nature: :QUIET,
        shiny: false,
        happiness: 255,
        ev: [252,252,0,252,0,0],
        iv: [31,31,31,31,31,0],
      },
      {
        species: :MAGNEZONE,
        level: 100,
        moves: [:FLASHCANNON,:THUNDERBOLT,:BODYPRESS,:HIDDENPOWER],
        hptype: :FIRE,
        item: :MAGICALSEED,
        ability: :MAGNETPULL,
        nature: :QUIET,
        shiny: true,
        happiness: 255,
        ev: [4,0,252,252,0,0],
        iv: [31,31,31,31,31,0],
      },
      #tailwind side
      {
        species: :MEOWSCARADA,
        level: 100,
        moves: [:FLOWERTRICK,:SUCKERPUNCH,:TRIPLEAXEL,:FIRELASH],
        item: :LIFEORB,
        ability: :PROTEAN,
        nature: :ADAMANT,
        shiny: true,
        happiness: 255,
        ev: [4,252,0,0,0,252],
        iv: 31,
      },
      {
        species: :MOLTRES,
        level: 100,
        moves: [:HEATWAVE,:WEATHERBALL,:SOLARBEAM,:SCORCHINGSANDS],
        item: :CHOICESPECS,
        ability: :FLAMEBODY,
        nature: :TIMID,
        shiny: true,
        happiness: 255,
        ev: [4,0,0,252,0,252],
        iv: 31,
      },
      {
        species: :JIRACHI,
        level: 100,
        moves: [:DOOMDESIRE,:COSMICPOWER,:PSYCHIC,:WISH],
        item: :LVCRACHICREST,
        ability: :SERENEGRACE,
        nature: :MODEST,
        shiny: true,
        happiness: 255,
        ev: [4,0,0,252,0,252],
        iv: 31,
      },
      ],
    :trainereffect => {
      :effectmode => :Party,
       0 => {
        :buffactivation => :Limited,
        :stateChanges => {
          :TrickRoom => [5, :TRICKROOM, "The dimensions were twisted!"],
        },
        :fieldChange => [:STARLIGHT, "<char>LYRA: You shouldn't have come here.", 0],
        :CustomMethod => "lvc_bossinit",
      },
      1 => {
        :buffactivation => :Always,
        :applySwitchInAbility => :INTIMIDATE,
        
      },
      3 => {
        :sprite => :None,
        :buffactivation => :Limited,
        :CustomMethod => "lvc_changetospeedmode",
      },
      4 => {
        :sprite => :None,
        :buffactivation => :Limited,
        :abilitychangeMessage => _INTL("A sunbeam shone on Moltres and changed its ability!"),
        :animation => :SPOTLIGHT,
        :abilitychange => :MEGASOL,
        :CustomMethod => "lvc_changetospeedmode",
      },
      5 => {
        :sprite => :None,
        :buffactivation => :Limited,
        :CustomMethod => "lvc_changetospeedmode",
      },
    }
   })
  $cache.trainers[:LVCVICTORY]["Victory"][0] = TeamData.new(0, ["Victory", :LVCVICTORY, 0], {
    :teamid => ["Victory", :LVCVICTORY, 0],
    :items => [:MEGARING],
    :defeat => "VICTORY: ...",
    :mons => [
      #TR SIDE
      {
        species: :SHIINOTIC,
        level: 100,
        moves: [:DAZZLINGGLEAM,:SPORE,:POLLENPUFF,:STRENGTHSAP],
        item: :SHIINCREST,
        ability: :ILLUMINATE,
        nature: :BOLD,
        shiny: true,
        happiness: 255,
        ev: [252,0,252,0,0,0],
        iv: [31,31,31,31,31,0],
      },
      {
        species: :SABLEYE,
        level: 100,
        moves: [:KNOCKOFF,:ENCORE,:WILLOWISP,:MOONLIGHT],
        item: :ROCKYHELMET,
        ability: :PRANKSTER,
        nature: :CALM,
        shiny: true,
        happiness: 255,
        ev: [252,0,4,0,252,0],
        iv: [31,31,31,31,31,0],
      },
      {
        species: :NECROZMA,
        level: 100,
        moves: [:PHOTONGEYSER,:METEORBEAM,:HEATWAVE,:MOONLIGHT],
        item: :ROOMSERVICE,
        ability: :PRISMARMOR,
        nature: :QUIET,
        shiny: true,
        happiness: 255,
        ev: [252,0,4,252,0,0],
        iv: [31,31,31,31,31,0],
      },
      #tailwind side
      {
        species: :SNEASLER,
        level: 100,
        form: 1,
        moves: [:RADIANTCLAW,:CLOSECOMBAT,:FAKEOUT,:PROTECT],
        item: :FOCUSSASH,
        ability: :WINDRIDER,
        nature: :JOLLY,
        shiny: true,
        happiness: 255,
        ev: [4,252,0,0,0,252],
        iv: 31,
      },
      {
        species: :GLIMMORA,
        level: 100,
        form: 1,
        moves: [:HURRICANE,:INJECTION,:ZAPCANNON,:SIGNALBEAM],
        item: :GLIMMORANITEA,
        ability: :DOWNLOAD,
        nature: :TIMID,
        shiny: true,
        happiness: 255,
        ev: [4,0,0,252,0,252],
        iv: 31,
      },
      {
        species: :VICTINI,
        level: 100,
        moves: [:FREEZESHOCK,:VICTORYDANCE,:VCREATE,:BOLTSTRIKE],
        item: :LVCVICCREST,
        ability: :VICTORYSTAR,
        nature: :JOLLY,
        shiny: true,
        happiness: 255,
        ev: [4,252,0,0,0,252],
        iv: 31,
      },
    ],
    :trainereffect => {
      :effectmode => :Party,
      2 => {
        :buffactivation => :Limited,
        :message => "Necrozma is bursting with power!",
        :formchange => [3, "UltraBurst"],
      },
      3 => {
        :sprite => :None,
        :applySwitchInAbility => :SWORNDUTY,
        :buffactivation => :Always,
        :CustomMethod => "lvc_changetospeedmode",
      },
      4 => {
        :sprite => :None,
        :buffactivation => :Limited,
        :CustomMethod => "lvc_changetospeedmode",
      },
      5 => {
        :sprite => :None,
        :buffactivation => :Limited,
        :CustomMethod => "lvc_changetospeedmode",
      },
    }
   })


#harder versions, for renegade
#changelog:
#evs -> 252 where relevant
#magnezone -> sturdy
#TR duration -> 8
  $cache.trainers[:LVCLYRA]["Lyra"][1] = TeamData.new(0, ["Lyra", :LVCLYRA, 0], {
    :teamid => ["Lyra", :LVCLYRA, 0],
    :defeat => "LYRA: Such power...",
    :items => [:MEGARING],
    :mons => [
      { #tr side
        species: :AURORUS,
        level: 100,
        moves: [:BLOODMOON,:POWERGEM,:THUNDERBOLT,:BLIZZARD],
        item: :LVCAUROCREST,
        ability: :REFRIGERATE,
        nature: :QUIET,
        shiny: true,
        happiness: 255,
        ev: [252,0,252,252,252,0],
        iv: [31,31,31,31,31,0],
      },
      {
        species: :MAWILE,
        level: 100,
        moves: [:FLASHCANNON,:DRAININGKISS,:FIREBLAST,:ICEBEAM],
        item: :LVCMAWCREST,
        ability: :SHEERFORCE,
        nature: :QUIET,
        shiny: false,
        happiness: 255,
        ev: [252,252,252,252,252,0],
        iv: [31,31,31,31,31,0],
      },
      {
        species: :MAGNEZONE,
        level: 100,
        moves: [:FLASHCANNON,:THUNDERBOLT,:BODYPRESS,:HIDDENPOWER],
        hptype: :FIRE,
        item: :MAGICALSEED,
        ability: :STURDY,
        nature: :QUIET,
        shiny: true,
        happiness: 255,
        ev: [252,0,252,252,252,0],
        iv: [31,31,31,31,31,0],
      },
      #tailwind side
      {
        species: :MEOWSCARADA,
        level: 100,
        moves: [:FLOWERTRICK,:SUCKERPUNCH,:TRIPLEAXEL,:FIRELASH],
        item: :LIFEORB,
        ability: :PROTEAN,
        nature: :ADAMANT,
        shiny: true,
        happiness: 255,
        ev: [252,252,252,252,252,252],
        iv: 31,
      },
      {
        species: :MOLTRES,
        level: 100,
        moves: [:HEATWAVE,:WEATHERBALL,:SOLARBEAM,:SCORCHINGSANDS],
        item: :MAGICALSEED,
        ability: :FLAMEBODY,
        nature: :TIMID,
        shiny: true,
        happiness: 255,
        ev: [252,0,252,252,252,252],
        iv: 31,
      },
      {
        species: :JIRACHI,
        level: 100,
        moves: [:DOOMDESIRE,:COSMICPOWER,:PSYCHIC,:WISH],
        item: :LVCRACHICREST,
        ability: :SERENEGRACE,
        nature: :MODEST,
        shiny: true,
        happiness: 255,
        ev: [252,0,252,252,252,252],
        iv: 31,
      },
      ],
    :trainereffect => {
      :effectmode => :Party,
       0 => {
        :buffactivation => :Limited,
        :stateChanges => {
          :TrickRoom => [8, :TRICKROOM, "The dimensions were twisted!"],
        },
        :fieldChange => [:STARLIGHT, "<char>LYRA: You shouldn't have come here.", 0],
        :CustomMethod => "lvc_bossinit",
      },
      1 => {
        :buffactivation => :Always,
        :applySwitchInAbility => :INTIMIDATE,
        
      },
      3 => {
        :sprite => :None,
        :buffactivation => :Limited,
        :CustomMethod => "lvc_changetospeedmode",
      },
      4 => {
        :sprite => :None,
        :buffactivation => :Limited,
        :abilitychangeMessage => _INTL("A sunbeam shone on Moltres and changed its ability!"),
        :animation => :SPOTLIGHT,
        :abilitychange => :MEGASOL,
        :CustomMethod => "lvc_changetospeedmode",
      },
      5 => {
        :sprite => :None,
        :buffactivation => :Limited,
        :CustomMethod => "lvc_changetospeedmode",
      },
    }
   })
  $cache.trainers[:LVCVICTORY]["Victory"][0] = TeamData.new(0, ["Victory", :LVCVICTORY, 0], {
    :teamid => ["Victory", :LVCVICTORY, 1],
    :items => [:MEGARING],
    :defeat => "VICTORY: ...",
    :mons => [
      #TR SIDE
      {
        species: :SHIINOTIC,
        level: 100,
        moves: [:DAZZLINGGLEAM,:SPORE,:POLLENPUFF,:STRENGTHSAP],
        item: :SHIINCREST,
        ability: :ILLUMINATE,
        nature: :BOLD,
        shiny: true,
        happiness: 255,
        ev: [252,0,252,252,252,0],
        iv: [31,31,31,31,31,0],
      },
      {
        species: :SABLEYE,
        level: 100,
        moves: [:KNOCKOFF,:ENCORE,:WILLOWISP,:MOONLIGHT],
        item: :ROCKYHELMET,
        ability: :PRANKSTER,
        nature: :CALM,
        shiny: true,
        happiness: 255,
        ev: [252,252,252,252,252,0],
        iv: [31,31,31,31,31,0],
      },
      {
        species: :NECROZMA,
        level: 100,
        moves: [:PHOTONGEYSER,:METEORBEAM,:HEATWAVE,:MOONLIGHT],
        item: :ROOMSERVICE,
        ability: :PRISMARMOR,
        nature: :QUIET,
        shiny: true,
        happiness: 255,
        ev: [252,0,252,252,252,0],
        iv: [31,31,31,31,31,0],
      },
      #tailwind side
      {
        species: :SNEASLER,
        level: 100,
        form: 1,
        moves: [:RADIANTCLAW,:CLOSECOMBAT,:FAKEOUT,:PROTECT],
        item: :FOCUSSASH,
        ability: :WINDRIDER,
        nature: :JOLLY,
        shiny: true,
        happiness: 255,
        ev: [252,252,252,252,252,252],
        iv: 31,
      },
      {
        species: :GLIMMORA,
        level: 100,
        form: 1,
        moves: [:HURRICANE,:INJECTION,:ZAPCANNON,:SIGNALBEAM],
        item: :GLIMMORANITEA,
        ability: :DOWNLOAD,
        nature: :TIMID,
        shiny: true,
        happiness: 255,
        ev: [252,252,252,252,252,252],
        iv: 31,
      },
      {
        species: :VICTINI,
        level: 100,
        moves: [:FREEZESHOCK,:VICTORYDANCE,:VCREATE,:BOLTSTRIKE],
        item: :LVCVICCREST,
        ability: :VICTORYSTAR,
        nature: :JOLLY,
        shiny: true,
        happiness: 255,
        ev: [252,252,252,252,252,252],
        iv: 31,
      },
    ],
    :trainereffect => {
      :effectmode => :Party,
      2 => {
        :buffactivation => :Limited,
        :message => "Necrozma is bursting with power!",
        :formchange => [3, "UltraBurst"],
      },
      3 => {
        :sprite => :None,
        :applySwitchInAbility => :SWORNDUTY,
        :buffactivation => :Always,
        :CustomMethod => "lvc_changetospeedmode",
      },
      4 => {
        :sprite => :None,
        :buffactivation => :Limited,
        :CustomMethod => "lvc_changetospeedmode",
      },
      5 => {
        :sprite => :None,
        :buffactivation => :Limited,
        :CustomMethod => "lvc_changetospeedmode",
      },
    }
   })
}
def lvc_make_flicker(arr, amt, incl_real = false, chance: 50)
    flicker_arr = []
    flicker_chars = ["$","#","!","%","/","=","+","&"]
    for item in arr
        flicker_arr.push(item) if incl_real
        for _ in 0..amt
            curr = item.dup()
            curr = curr.chars()
            for i in 0..(curr.length)
              curr[i] = flicker_chars.sample() if curr[i] != " " && chance > rand(99)
            end
            flicker_arr.push(curr.join)
        end
    end
    return flicker_arr
end


def lvc_givebossreward
  poke=PokeBattle_Pokemon.new(:VICTINI,100,$Trainer,false)
  poke.pbLearnMove(:VCREATE)
  poke.pbLearnMove(:ICEBURN)
  poke.pbLearnMove(:FREEZESHOCK)
  poke.pbLearnMove(:VICTORYDANCE)
  poke.item = :LVCVICCREST
  poke.ot = "Victory"
  poke.obtainText = _INTL("Somewhere far away.")
  poke.makeShiny
  pbAddPokemon(poke)
  poke=PokeBattle_Pokemon.new(:JIRACHI,100,$Trainer,false)
  poke.pbLearnMove(:DOOMDESIRE)
  poke.pbLearnMove(:COSMICPOWER)
  poke.pbLearnMove(:PSYCHIC)
  poke.pbLearnMove(:WISH)
  poke.ot = "Lyra"
  poke.flickerID =
  {
    :interval => 3,
    :IDlist => [18365, 38470],
    :weight => 100,
    :timer => 0,
    :display => poke.publicID,
  }
  poke.flickerLocation = 
  {
    :interval => 4,
    :IDlist => lvc_make_flicker(["Purgatorium", "Deux Finalis", "Core Crown", "Xen Observatory", "Edge of My World", "Faraway place"], 10, chance: 50),
    :weight => 100,
    :timer => 0,
    :display => poke.obtainText,
  }
  poke.obtainText = _INTL("Somewhere close by.")
  poke.fakeOT = true
  poke.makeShiny
  poke.item = :LVCRACHICREST
  pbAddPokemon(poke)
end

InjectionHelper.defineMapPatch(674) { # Purgatorium
  createNewEvent(21, 23, "lvc boss", "lvcboss") { #down the stairs
    newPage {
      @step_anime = true
      @move_speed = 1
      @move_frequency = 1
      @direction_fix = true
      requiresSwitch 1975 #Defeated witch of the end M2
      setGraphic 'karmabutterfly', direction: :Down, hueShift: 240 
      interact {
        text "There is a paradoxical energy emanating from this butterfly..."
        text "Face this entity? (Rec. Lv. 100+)\|"
        text "Warning, this battle is not yet avaliable in Story Mode."
        show_choices {
          choice("No") {}
          choice("Yes") {
            branch('pbDoubleTrainerBattle(:LVCVICTORY,"Victory",1,"",:LVCLYRA,"Lyra",1,"",true)'){ #call harder versions in renegade
              text "???: Woah.."
              text "Two Pokeballs materialized from thin air!"
              script 'lvc_givebossreward'
              self_switch["A"] = true
            }
          }
        }
      }
    }
    newPage { requiresSelfSwitch 'A' }
  }
}


InjectionHelper.defineMapPatch(639) { # Deux Finalis cathedral
  createNewEvent(95, 65, "lvc boss", "lvcboss") { #by the star in the middle of the room
    newPage {
      @step_anime = true
      @move_speed = 1
      @move_frequency = 1
      @direction_fix = true
      requiresSwitch 1999 #Defeated kaina
      setGraphic 'karmabutterfly', direction: :Down, hueShift: 180 
      interact {
        text "There is a paradoxical energy emanating from this butterfly..."
        text "Face this entity? (Rec. Lv. 100+)\|"
        text "Warning, this battle is not yet avaliable in Story Mode."
        show_choices {
          choice("No") {}
          choice("Yes") {
            branch('pbDoubleTrainerBattle(:LVCVICTORY,"Victory",0,"",:LVCLYRA,"Lyra",0,"",true)'){
              text "???: Woah.."
              text "Two Pokeballs materialized from thin air!"
              script 'lvc_givebossreward'
              self_switch["A"] = true
            }
          }
        }
      }
    }
    newPage { requiresSelfSwitch 'A' }
  }
}