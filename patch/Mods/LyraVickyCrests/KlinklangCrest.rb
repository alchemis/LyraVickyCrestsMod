PBStuff::POKEMONTOCREST[:KLINKLANG] = :LVCKLINCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCKLINCREST] = ItemData.new(:LVCKLINCREST, {
    name: "Klinklang Crest",
    desc: "Special attacks use its Defense stat. Increases its Accuracy by 50%.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias klincrest_crestStats crestStats
    def crestStats
      klincrest_crestStats
      case @crested
        when :KLINGLANG
            @spatk = @defense
      end
    end
end

class PokeBattle_Move
  alias klinkcrest_pbCalcAccuracy pbCalcAccuracy
  def klinkcrest_pbCalcAccuracy
    accmult.append(1.5) if [:KLINKLANG].include?(attacker.crested)
    return pbCalcFinalAccuracy(baseaccuracy, accmult, stagemult, miclemult)
  end
end