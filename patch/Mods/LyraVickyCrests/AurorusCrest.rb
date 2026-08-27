PBStuff::POKEMONTOCREST[:AURORUS] = :LVCAUROCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCAUROCREST] = ItemData.new(:LVCAUROCREST, {
    name: "Aurorus Crest",
    desc: "Aurorus' Rock-Type and Rock moves become Dragon, also it sets a 3-turn Aurora Veil on entry.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

alias :aurocrest_pbCrestMoveTypeChange :pbCrestMoveTypeChange if !defined?(aurocrest_pbCrestMoveTypeChange)
def pbCrestMoveTypeChange(species, form, item, type)
    if species == :AURORUS && item == :LVCAUROCREST && type == :ROCK then 
      return :DRAGON

    end
    return aurocrest_pbCrestMoveTypeChange(species, form, item, type)
end

class PokeBattle_Battle
  alias_method :aurocrest_pbCrestEntry, :pbCrestEntry if !defined?(aurocrest_pbCrestEntry)
  def pbCrestEntry(index, pokemon)
    aurocrest_pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    case battler.crested
      when :AURORUS
        pbShowAbilityBox(battler, item: true)
        pbAnimation(:AURORAVEIL, battler, nil)
        if battler.pbOwnSide.effects[:AuroraVeil] == 0
          pbDisplay(_INTL("{1} raised an Aurora Veil!", battler.pbThis))
          pbApplySideEffect(:AuroraVeil, 3, battler.pbOwnSide, battler)
        else
          pbDisplay(_INTL("{1} extended the Aurora Veil!", battler.pbThis))
          battler.pbOwnSide.effects[:AuroraVeil]+=3
        end
        pbHideAbilityBox(battler)
    end
  end
end

class PokeBattle_Battler
    alias_method :aurocrest_crestStats, :crestStats if !defined?(aurocrest_crestStats)
    def crestStats
      
      case @crested
        when :AURORUS
            @type1 = :DRAGON
      end
      aurocrest_crestStats
    end
end