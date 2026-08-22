PBStuff::POKEMONTOCREST[:MIGHTYENA] = :LVCMIGHTYCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCMIGHTYCREST] = ItemData.new(:LVCMIGHTYCREST, {
    name: "Mightyena Crest",
    desc: "Mightyena uses Howl on switch-in, also increases its Speed by 30%.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}



class PokeBattle_Battle
    alias mightycrest_pbCrestEntry pbCrestEntry if !defined?(mightycrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      mightycrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      case battler.crested
        when :MIGHTYENA
          pbShowAbilityBox(battler, item: true)
          battler.pbUseMoveSimple(:HOWL, -1, -1)
          pbHideAbilityBox(battler)
      end
    end
end

class PokeBattle_Battler
    alias mightycrest_crestStats crestStats if !defined?(mightycrest_crestStats)
    def crestStats
      
      case @crested
        when :MIGHTYENA
            @speed *= 1.3
      end
      mightycrest_crestStats
    end
end