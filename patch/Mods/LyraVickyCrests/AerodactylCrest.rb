PBStuff::POKEMONTOCREST[:AERODACTYL] = :LVCAERODACTYLCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCAERODACTYLCREST] = ItemData.new(:LVCAERODACTYLCREST, {
    name: "Aerodactyl Crest",
    desc: "Its first move becomes Multi-Attack in battle, also replaces its Rock-Type with its held Memory type.",
    price: 0,
    crest: true,
    keyitem: true, #NON HELD CREST
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Battler
    #look for crest in bag/trainer items instead
    alias_method :aerocrest_hasCrest?, :hasCrest? if !defined?(aerocrest_hasCrest?)
    def hasCrest?(species = self.species)
        if species == :AERODACTYL then
          return true if $PokemonBag.pbQuantity(:LVCAERODACTYLCREST) > 0 && @battle.pbOwnedByPlayer?(@index) && PBStuff::SILVALLYCRESTABILITIES.has_key?(@item)
          return true if @battle.pbGetOwnerItems(@index).include?(:LVCAERODACTYLCREST) && !@battle.pbOwnedByPlayer?(@index) && PBStuff::SILVALLYCRESTABILITIES.has_key?(@item)
          return false
        else return aerocrest_hasCrest?(species)
        end
    end
    #type change
    alias_method :aerocrest_crestStats, :crestStats if !defined?(aerocrest_crestStats)
    def crestStats
      
      if @crested == :AERODACTYL
          case @item
          when :FIGHTINGMEMORY  then @type1 = :FIGHTING
          when :FLYINGMEMORY    then @type1 = :FLYING
          when :POISONMEMORY    then @type1 = :POISON
          when :GROUNDMEMORY    then @type1 = :GROUND
          when :ROCKMEMORY      then @type1 = :ROCK
          when :BUGMEMORY       then @type1 = :BUG
          when :GHOSTMEMORY     then @type1 = :GHOST
          when :STEELMEMORY     then @type1 = :STEEL
          when :FIREMEMORY      then @type1 = :FIRE
          when :WATERMEMORY     then @type1 = :WATER
          when :GRASSMEMORY     then @type1 = :GRASS
          when :ELECTRICMEMORY  then @type1 = :ELECTRIC
          when :PSYCHICMEMORY   then @type1 = :PSYCHIC
          when :ICEMEMORY       then @type1 = :ICE
          when :DRAGONMEMORY    then @type1 = :DRAGON
          when :DARKMEMORY      then @type1 = :DARK
          when :FAIRYMEMORY     then @type1 = :FAIRY
          when :GLITCHMEMORY    then @type1 = :QMARKS
          end
          #gain move
          @aerocrest_ogmove = {:move => @moves[0].move, :pp => @moves[0].pp, :totalpp => @moves[0].totalpp}
          @moves[0] = PokeBattle_Move.pbFromPBMove(@battle, PBMove.new(:MULTIATTACK), @pokemon)
          @moves[0].pp = (@aerocrest_ogmove[:pp] * (@moves[0].totalpp.to_f / @aerocrest_ogmove[:totalpp])).floor
      end
      aerocrest_crestStats
    end
    
end

InjectionHelper.defineMapPatch(72) { # Garufa sanctuary
  createNewEvent(22, 68, "aero Crest", "aerocrest") { #by the "something emerged from the earth here"
    newPage {
      @step_anime = true
      @move_speed = 1
      @move_frequency = 1
      requiresVariable 723, 1 #.karma started
      setGraphic 'object_megazcrystal_1' #crest graphic
      interact {
        branch("Kernel.pbItemBall(:LVCAERODACTYLCREST)") {
          self_switch["A"] = true
        }
      }
    }
    newPage { requiresSelfSwitch 'A' }
  }
}