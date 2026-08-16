PBStuff::POKEMONTOCREST[:SPIDOPS] = :LVCSPIDCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCSPIDCREST] = ItemData.new(:LVCSPIDCREST, {
    name: "Spidops Crest",
    desc: "Spidops sets its Silk Trap on entry, also it deals extra damage when it moves first.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battle
    alias spidopscrest_pbCrestEntry pbCrestEntry if !defined?(spidopscrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      spidopscrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      case battler.crested
        when :SPIDOPS
          pbShowAbilityBox(battler, item: true)
          battler.pbUseMoveSimple(:SILKTRAP, -1, -1)
          pbHideAbilityBox(battler)
      end
    end
end

class PokeBattle_Move
    alias spidopscrest_pbCalcDamage pbCalcDamage if !defined?(spidopscrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
      case attacker.crested
        when :SPIDOPS then basemult.append(1.5) if (!opponent.hasMovedThisRound? || @battle.switchedOut[opponent.index])
      end
    return damage
    end
end