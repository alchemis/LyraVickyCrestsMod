PBStuff::POKEMONTOCREST[:KLINKLANG] = :LVCKLINCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCKLINCREST] = ItemData.new(:LVCKLINCREST, {
    name: "Klinklang Crest",
    desc: "Klinklang's Sp.ATK is equal to its Defense, also its Accuracy is boosted by 50%.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Battler
    alias_method :klinklangcrest_crestStats, :crestStats if !method_defined?(:klinklangcrest_crestStats)
    def crestStats
      
      case @crested
        when :KLINKLANG
            @spatk = @defense
      end
      klinklangcrest_crestStats
    end
end

class PokeBattle_Move
  alias_method :klinklangcrest_pbBaseAccuracy, :pbBaseAccuracy if !method_defined?(:klinklangcrest_pbBaseAccuracy)
  def pbBaseAccuracy(baseacc, attacker, opponent)
    baseacc = klinklangcrest_pbBaseAccuracy(baseacc, attacker, opponent)
    return (baseacc * 1.5).round if [:KLINKLANG].include?(attacker.crested)
    return baseacc.round
  end
end