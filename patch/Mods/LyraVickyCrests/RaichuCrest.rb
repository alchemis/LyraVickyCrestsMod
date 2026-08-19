PBStuff::POKEMONTOCREST[:RAICHU] = :LVCRAICHUCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCRAICHUCREST] = ItemData.new(:LVCRAICHUCREST, {
    name: "Raichu Crest",
    desc: "Raichu uses Ion Deluge on switch-in, also increases its offenses by 30%.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}



class PokeBattle_Battle
    alias raichucrest_pbCrestEntry pbCrestEntry if !defined?(raichucrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      raichucrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      case battler.crested
        when :RAICHU
          pbShowAbilityBox(battler, item: true)
          battler.pbUseMoveSimple(:IONDELUGE, -1, -1)
          pbHideAbilityBox(battler)
      end
    end
end

class PokeBattle_Battler
    alias raichucrest_crestStats crestStats if !defined?(raichucrest_crestStats)
    def crestStats
      raichucrest_crestStats
      case @crested
        when :RAICHU
            @attack *= 1.3
            @spatk *= 1.3
      end
    end
end