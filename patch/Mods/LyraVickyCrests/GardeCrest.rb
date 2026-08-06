#Item

PBStuff::POKEMONTOCREST[:GARDEVOIR] = :LVCGARDECREST
PBStuff::POKEMONTOMEGASTONE[:GARDEVOIR].append(:LVCGARDECREST)

ModCacheInjection.hook(:items) {
  $cache.items[:LVCGARDECREST] = ItemData.new(:LVCGARDECREST, {
    name: "Gardevoir Crest",
    desc: "Shifts into Dark form, Psychic moves become Dark. Might do something special if you have a Gardevoirite in your bag.",
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

        :MegaEvolutions => {
          :LVCGARDECREST => "Mega Crested Form",
        },
      }
  )

  ModCacheInjection.createNewForm(:GARDEVOIR,"Mega Crested Form",6,
      {
        :baseForm => "Crested Form",
        :BaseStats => [68, 85, 65, 165, 135, 100],
        :Abilities => [:EXECUTION],
        :HiddenAbility => nil,
        :BattlerPlayerX => 16,
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


alias gardecrest_pbCrestMoveTypeChange pbCrestMoveTypeChange
def pbCrestMoveTypeChange(species, form, item, type)
    if species == :GARDEVOIR && item == :LVCGARDECREST && type == :PSYCHIC then 
      return :DARK 

    end
    return gardecrest_pbCrestMoveTypeChange(species, form, item, type)
end


#Form change
class PokeBattle_Pokemon

  alias gardecrest_changeFormOnBattleStart changeFormOnBattleStart
  def changeFormOnBattleStart
      if @species == :GARDEVOIR && @item == :LVCGARDECREST && @form == 0 then
        self.originalForm = 0
        self.originalAbility = self.abilityIndex
        self.form = 5
      else return gardecrest_changeFormOnBattleStart
      end
  end

  alias gardecrest_changeFormOnBattleEnd changeFormOnBattleEnd
  def changeFormOnBattleEnd
      if @species == :GARDEVOIR && (@form == 5 || @form == 6) then
          self.form = 0
          self.ability = originalAbility if @form == 6
          self.originalAbility = nil
          self.originalForm = nil
      else return gardecrest_changeFormOnBattleEnd
      end 
  end

  alias gardecrest_hasMegaForm? hasMegaForm?
  def hasMegaForm?
      if @species == :GARDEVOIR && form == 5 then
          puts "has mega!"
          return true 
      else
        return gardecrest_hasMegaForm?
      end
  
  end
end

class PokeBattle_Battle
    alias gardecrest_pbCanMegaEvolve? pbCanMegaEvolve?

    def pbCanMegaEvolve?(index, aiBattler: nil)
      ret = aiBattler ? gardecrest_pbCanMegaEvolve?(index, aiBattler) : gardecrest_pbCanMegaEvolve?(index)
      battler = aiBattler || @battlers[index]
      puts "canmegaevolve ret:"
      puts ret
      if battler.species == :GARDEVOIR && battler.form == 5 then
          puts "garde detected"
          puts "ite?"
          puts $PokemonBag.pbQuantity(:GARDEVOIRITE) > 0
          return true if $PokemonBag.pbQuantity(:GARDEVOIRITE) > 0 and ret
      else return ret
      end
    end
end