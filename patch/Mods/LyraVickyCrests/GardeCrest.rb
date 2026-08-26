if !(File.exist?('patch/Init/0000.cache_injection.rb') or !File.exist?('patch/Init/0000.map_injection.rb')) then 
  print("Error, patching libraries not found. Please download 0000.cache_injection.rb and 0000.map_injection.rb from wiresegal's modpack at: github.com/yrsegal/rejuvenation-modpack")
end

#Item

PBStuff::POKEMONTOCREST[:GARDEVOIR] = :LVCGARDECREST
PBStuff::POKEMONTOMEGASTONE[:GARDEVOIR].append(:LVCGARDECREST)

ModCacheInjection.hook(:items) {
  $cache.items[:LVCGARDECREST] = ItemData.new(:LVCGARDECREST, {
    name: "Broken Halo",
    desc: "Touching it brings forth a loyal servant's broken faith... Perhaps it could resonate with a Gardevoirite.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}



#Forms
ModCacheInjection.hook(:pkmn) {

 
  ModCacheInjection.createNewForm(:GARDEVOIR,"Crested Form",5,
      {
        :Type1 => :DARK,
        :BaseStats => [68, 85, 85, 120, 110, 100],
		    :Abilities => [:TRACE],
        :HiddenAbility => nil,
        :MegaEvolutions => {
          :LVCGARDECREST => "Mega Gardevoir Z",
        },
      }
  )

  ModCacheInjection.createNewForm(:GARDEVOIR,"Mega Gardevoir Z",6,
      {
        :baseForm => "Crested Form",
        :BaseStats => [68, 150, 85, 160, 85, 120],
        :Abilities => [:EXECUTION],
        :HiddenAbility => nil,
        :BattlerPlayerX => -9,
        :BattlerPlayerY => 9,
        :BattlerEnemyX => -9,
        :BattlerEnemyY => 14,
        :BattlerShadowSize => 27,
        :BattlerShadowX => 10,
        :Mega => true,
      }
  )
}

#Move type change


alias :gardecrest_pbCrestMoveTypeChange :pbCrestMoveTypeChange if !defined?(gardecrest_pbCrestMoveTypeChange)
def pbCrestMoveTypeChange(species, form, item, type)
    if species == :GARDEVOIR && item == :LVCGARDECREST && type == :PSYCHIC then 
      return :DARK 

    end
    return gardecrest_pbCrestMoveTypeChange(species, form, item, type)
end


#Form change
class PokeBattle_Battle

  alias_method :gardecrest_pbCrestEntry, :pbCrestEntry if !defined?(gardecrest_pbCrestEntry)
  def pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      if battler.species == :GARDEVOIR && battler.item == :LVCGARDECREST && battler.form == 0 then
        battler.pokemon.originalForm = 0
        battler.pokemon.originalAbility = battler.pokemon.abilityIndex
        pbShowAbilityBox(battler, item: true)
        pbDisplay(_INTL("{1}'s Broken Halo is glowing!", battler.pbThis))
        pbAnimation(:TRANSFORM,  battler, battler)
        battler.form = 5
        @scene.pbChangePokemon(battler, battler.pokemon)
        battler.pbUpdate(true)
        pbHideAbilityBox(battler)
      else return gardecrest_pbCrestEntry(index, pokemon)
      end
  end
end
class PokeBattle_Pokemon
  alias_method :gardecrest_changeFormOnBattleEnd, :changeFormOnBattleEnd if !defined?(gardecrest_changeFormOnBattleEnd)
  def changeFormOnBattleEnd
      if @species == :GARDEVOIR && (@form == 5 || @form == 6) then
          self.form = 0
          self.ability = :TRACE
          self.originalAbility = nil
          self.originalForm = nil
      else return gardecrest_changeFormOnBattleEnd
      end 
  end

  alias_method :gardecrest_hasMegaForm?, :hasMegaForm? if !defined?(gardecrest_hasMegaForm?)
  def hasMegaForm?
      if @species == :GARDEVOIR && form == 5 then
          return true 
      else
        return gardecrest_hasMegaForm?
      end
  
  end
end

class PokeBattle_Battle
    alias_method :gardecrest_pbCanMegaEvolve?, :pbCanMegaEvolve? if !defined?(gardecrest_pbCanMegaEvolve?)

    def pbCanMegaEvolve?(index, aiBattler: nil)
      ret = aiBattler ? gardecrest_pbCanMegaEvolve?(index, aiBattler: aiBattler) : gardecrest_pbCanMegaEvolve?(index)
      battler = aiBattler || @battlers[index]
      if battler.species == :GARDEVOIR && battler.form == 5 then
          return true if $PokemonBag.pbQuantity(:GARDEVOIRITE) > 0 and ret
      else return ret
      end
    end
end


#EV112 21,77 MAP634 
InjectionHelper.defineMapPatch(634) { # core crown
  crest = nil

  crest = createNewEvent(21, 78, "gardevoir crest", "gardevoircrest") {
    newPage {
      @step_anime = true
      @move_speed = 4
      @move_frequency = 3
      requiresSwitch 1791
      setGraphic 'sparkle'
      interact {
        text "... There seems to be something still here."
        branch("Kernel.pbItemBall(:LVCGARDECREST)") {
          self_switch["A"] = true
        }
      }
    }
    newPage { requiresSelfSwitch 'A' }
  }
}