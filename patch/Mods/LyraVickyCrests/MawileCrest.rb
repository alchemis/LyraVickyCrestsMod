PBStuff::POKEMONTOCREST[:MAWILE] = :LVCMAWCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCMAWCREST] = ItemData.new(:LVCMAWCREST, {
    name: "Mawile Crest",
    desc: "Mawile's Defenses and Sp.ATK are boosted by its ATK.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias mawcrest_crestStats crestStats if !defined?(mawcrest_crestStats)
    def crestStats
      
      case @crested
        when :MAWILE
            @defense += @attack/2
            @spdef += @attack/2
            @spatk += @attack
      end
      mawcrest_crestStats
    end
end