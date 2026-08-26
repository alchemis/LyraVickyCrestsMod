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
class PokeBattle_AI
  alias lvc_superbossgetSwitchInScoresParty getSwitchInScoresParty if !defined?(lvc_superbossgetSwitchInScoresParty)
    def getSwitchInScoresParty(hard_switch, revival: false, doublereplace: false, batonpass: true)
        partyscores = lvc_superbossgetSwitchInScoresParty(hard_switch, revival: revival, doublereplace: doublereplace, batonpass: batonpass)
        if defined?(@battle.state.effects[:lvc_superboss]) && @battle.state.effects[:lvc_superboss]
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
end

def lvc_bossinit
  $battle.instance_eval{
    @state.effects[:lvc_superboss] = true
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
      puts remaining
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
          pbDisplayAutoPaused(_INTL("<char>{1}: Let's speed this up, shall we?", ownername))
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
    :defeat => "Such power...",
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
        :fieldChange => [:STARLIGHT, "<char>Lyra: You shouldn't have come here.", 0],
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
        form: 2,
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
}

#defeated m2 = 1975
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
        show_choices {
          choice("No") {}
          choice("Yes") {
            branch('pbDoubleTrainerBattle(:LVCVICTORY,"Victory",0,"",:LVCLYRA,"Lyra",0,"",true)'){
              text "???: Woah.."
              text "Two Pokeballs materialized from thin air!"
              script 'poke=PokeBattle_Pokemon.new(:VICTINI,100,"Victory")
              poke.pbLearnMove(:VCREATE)
              poke.pbLearnMove(:ICEBURN)
              poke.pbLearnMove(:FREEZESHOCK)
              poke.pbLearnMove(:VICTORYDANCE)
              poke.item = :LVCVICCREST
              poke.obtainText = _INTL("Somewhere far away.")
              poke.makeShiny
              pbAddPokemon(poke)'
              script 'poke=PokeBattle_Pokemon.new(:JIRACHI,100,"Lyra")
              poke.pbLearnMove(:DOOMDESIRE)
              poke.pbLearnMove(:COSMICPOWER)
              poke.pbLearnMove(:PSYCHIC)
              poke.pbLearnMove(:WISH)
              poke.obtainText = _INTL("Somewhere close by.")
              poke.makeShiny
              poke.item = :LVCRACHICREST
              pbAddPokemon(poke)'
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
        show_choices {
          choice("No") {}
          choice("Yes") {
            branch('pbDoubleTrainerBattle(:LVCVICTORY,"Victory",0,"",:LVCLYRA,"Lyra",0,"",true)'){
              text "???: Woah.."
              text "Two Pokeballs materialized from thin air!"
              script 'poke=PokeBattle_Pokemon.new(:VICTINI,100,"Victory")
              poke.pbLearnMove(:VCREATE)
              poke.pbLearnMove(:ICEBURN)
              poke.pbLearnMove(:FREEZESHOCK)
              poke.pbLearnMove(:VICTORYDANCE)
              poke.item = :LVCVICCREST
              poke.obtainText = _INTL("Somewhere close by.")
              poke.makeShiny
              pbAddPokemon(poke)'
              script 'poke=PokeBattle_Pokemon.new(:JIRACHI,100,"Lyra")
              poke.pbLearnMove(:DOOMDESIRE)
              poke.pbLearnMove(:COSMICPOWER)
              poke.pbLearnMove(:PSYCHIC)
              poke.pbLearnMove(:WISH)
              poke.obtainText = _INTL("Somewhere far away.")
              poke.makeShiny
              poke.item = :LVCRACHICREST
              pbAddPokemon(poke)'
              self_switch["A"] = true
            }
          }
        }
      }
    }
    newPage { requiresSelfSwitch 'A' }
  }
}