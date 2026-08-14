PBStuff::POKEMONTOCREST[:AURORUS] = :LVCAUROCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCAUROCREST] = ItemData.new(:LVCAUROCREST, {
    name: "Aurorus Crest",
    desc: "Replaces Rock-Type with Dragon. Rock-type moves become Dragon, also sets a 3-turn Aurora Veil on entry.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battle
  alias aurocrest_pbCrestEntry pbCrestEntry if !defined?(aurocrest_pbCrestEntry)
  def pbCrestEntry(index, pokemon)
    aurocrest_pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    case battler.crested
      when :AURORUS
        pbShowAbilityBox(battler, item: true)
        pbAnimation(:AURORAVEIL, battler, nil)
        pbDisplay(_INTL("{1} raised an Aurora Veil!", battler.pbThis))
        if battler.pbOwnSide.effects[:AuroraVeil] == 0
          pbApplySideEffect(:AuroraVeil, 3, battler.pbOwnSide, battler)
        else
          pbApplySideEffect(:AuroraVeil, + 3, battler.pbOwnSide, battler)
        end
        pbHideAbilityBox(battler)
      end
   end
end

class PokeBattle_Battler
    alias aurocrest_crestStats crestStats
    def crestStats
      aurocrest_crestStats
      case @crested
        when :AURORUS
            @type1 = :DRAGON
      end
    end
end

# (This was meant to turn Rock moves into Dragon ones, but I couldn't figure out how)
# class PBMove
#   alias aurocrest_pbMoveTypeChange pbMoveTypeChange if !defined?(aurocrestpbMoveTypeChange)
#   def pbMoveTypeChange(species, item, type)
#     aurocrest_pbMoveTypeChange
#     return type unless type == :ROCK
#     case true
#       when species == :AURORUS && item == :AUROCREST then return :DRAGON
#     end
#     return type
#   end
# end