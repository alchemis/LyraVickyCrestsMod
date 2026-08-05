PBStuff::POKEMONTOCREST[:MAWILE] = :MAWCREST


ModCacheInjection.hook(:items) {
  $cache.items[:MAWCREST] = ItemData.new(:MAWCREST, {
    name: "Mawile Crest",
    desc: "Adds Mawile's Attack to its Special Attack.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias mawcrest_crestStats crestStats
    def crestStats
      mawcrest_crestStats
      case @crested
        when :MAWILE
            @spatk = @attack + @spatk
      end
    end
end