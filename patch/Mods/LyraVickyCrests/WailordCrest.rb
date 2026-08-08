PBStuff::POKEMONTOCREST[:WAILORD] = :LVCWAILCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCWAILCREST] = ItemData.new(:LVCWAILCREST, {
    name: "Wailord Crest",
    desc: "Increases Defenses based on current HP.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias wailcrest_crestStats crestStats
    def crestStats
      wailcrest_crestStats
      case @crested
        when :WAILORD
            @defense = @defense + @hp * 0.5
            @spdef = @spdef + @hp * 0.5
      end
    end
end

class PokeBattle_Move
    alias wailcrest_pbCalcDamage pbCalcDamage if !defined?(wailcrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
          if opponent.crested && oponent.species == :WAILORD then
            opponent.pbUpdate()
          end
          if movetype then
            damage = wailcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype) #attacker, opponent, hitnum, feedbackMessages, movetype
          else damage = wailcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages)
          end
    end
end
# Put Leftovers-style healing here