PBStuff::POKEMONTOCREST[:KLINKLANG] = :LVCKLINCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCKLINCREST] = ItemData.new(:LVCKLINCREST, {
    name: "Klinklang Crest",
    desc: "Special attacks use its defense, accuracy of all moves is increased by 50%.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Battler
    alias klinklangcrest_crestStats crestStats
    def crestStats
      klinklangcrest_crestStats
      case @crested
        when :KLINKLANG
            @spatk = @defense
      end
    end
end

class PokeBattle_Move
  alias klinklangcrest_pbBaseAccuracy pbBaseAccuracy
  def pbBaseAccuracy(baseacc, attacker, opponent)
    baseacc = klinklangcrest_pbBaseAccuracy
    return baseacc * 1.5 if [:KLINKLANG].include?(attacker.crested)
    return baseacc
  end
end