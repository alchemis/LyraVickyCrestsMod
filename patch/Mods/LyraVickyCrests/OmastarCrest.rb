PBStuff::POKEMONTOCREST[:OMASTAR] = :LVCOMASTARCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCOMASTARCREST] = ItemData.new(:LVCOMASTARCREST, {
    name: "Omastar Crest",
    desc: "Omastar's first move becomes Judgment in battle, also replaces its Rock-Type with its held Plate type.",
    price: 0,
    crest: true,
    keyitem: true, #NON HELD CREST
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Battler
    #look for crest in bag/trainer items instead
    alias_method :helixcrest_hasCrest?, :hasCrest? if !defined?(helixcrest_hasCrest?)
    def hasCrest?(species = self.species)
        if species == :OMASTAR then
          plates = [:INSECTPLATE,:DREADPLATE,:DRACOPLATE,:ZAPPLATE,:FISTPLATE,
            :FLAMEPLATE,:MEADOWPLATE,:EARTHPLATE,:ICICLEPLATE,:TOXICPLATE,
            :MINDPLATE,:STONEPLATE,:SKYPLATE,:SPOOKYPLATE,:IRONPLATE,:SPLASHPLATE,
            :PIXIEPLATE]
          return true if $PokemonBag.pbQuantity(:LVCOMASTARCREST) > 0 && @battle.pbOwnedByPlayer?(@index) && plates.include?(@item)
          return true if @battle.pbGetOwnerItems(@index).include?(:LVCOMASTARCREST) && !@battle.pbOwnedByPlayer?(@index) && plates.include?(@item)
          return false
        else return helixcrest_hasCrest?(species)
        end
    end
    #type change
    alias_method :helixcrest_crestStats, :crestStats if !defined?(helixcrest_crestStats)
    def crestStats
      
      if @crested == :OMASTAR
          case @item
          when :FISTPLATE     then @type1 = :FIGHTING
          when :SKYPLATE      then @type1 = :FLYING
          when :TOXICPLATE    then @type1 = :POISON
          when :EARTHPLATE    then @type1 = :GROUND
          when :STONEPLATE    then @type1 = :ROCK
          when :INSECTPLATE   then @type1 = :BUG
          when :SPOOKYPLATE   then @type1 = :GHOST
          when :IRONPLATE     then @type1 = :STEEL
          when :FLAMEPLATE    then @type1 = :FIRE
          when :SPLASHPLATE   then @type1 = :WATER
          when :MEADOWPLATE   then @type1 = :GRASS
          when :ZAPPLATE      then @type1 = :ELECTRIC
          when :MINDPLATE     then @type1 = :PSYCHIC
          when :ICICLEPLATE   then @type1 = :ICE
          when :DRACOPLATE    then @type1 = :DRAGON
          when :DREADPLATE    then @type1 = :DARK
          when :PIXIEPLATE    then @type1 = :FAIRY
          end
          #gain move
          @helixcrest_ogmove = {:move => @moves[0].move, :pp => @moves[0].pp, :totalpp => @moves[0].totalpp}
          @moves[0] = PokeBattle_Move.pbFromPBMove(@battle, PBMove.new(:JUDGMENT), @pokemon)
          @moves[0].pp = (@helixcrest_ogmove[:pp] * (@moves[0].totalpp.to_f / @helixcrest_ogmove[:totalpp])).floor
      end
      helixcrest_crestStats
    end
    
end

InjectionHelper.defineMapPatch(337) { # Church of Theolia
  createNewEvent(56, 22, "Omastar Crest", "omastarcrest") { #By the altar
    newPage {
      @step_anime = true
      @move_speed = 1
      @move_frequency = 1
      requiresVariable 723, 1 #.karma started
      setGraphic 'object_megazcrystal_1' #crest graphic
      interact {
        branch("Kernel.pbItemBall(:LVCOMASTARCREST)") {
          self_switch["A"] = true
        }
      }
    }
    newPage { requiresSelfSwitch 'A' }
  }
}
