PBStuff::POKEMONTOCREST[:ROSERADE] = :LVCROSECREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCROSECREST] = ItemData.new(:LVCROSECREST, {
    name: "Roserade Crest",
    desc: "Swaps Physical and Special stats and boosts Speed by 15%.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias rosecrest_crestStats crestStats
    def crestStats
      rosecrest_crestStats
      case @crested
        when :ROSERADE
            @attack, @spatk = @spatk, @attack
            @defense, @spdef = @spdef,defense
            @speed *= 1.15
      end
    end 
end

# I want to add an unlisted part that makes multihits hit 4-5 times, but can't figure it out, so please help me Lyra.