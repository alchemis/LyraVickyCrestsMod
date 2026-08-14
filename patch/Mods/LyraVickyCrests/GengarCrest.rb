PBStuff::POKEMONTOCREST[:GENGAR] = :LVCGENGCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCGENGCREST] = ItemData.new(:LVCGENGCREST, {
    name: "Gengar Crest",
    desc: "Swaps ATK and Sp.ATK. Ability becomes Levitate.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias gengcrest_crestStats crestStats
    def crestStats
      gengcrest_crestStats
      case @crested
        when :GENGAR
            @attack, @spatk = @spatk, @attack
            @ability = :LEVITATE
      end
    end
end