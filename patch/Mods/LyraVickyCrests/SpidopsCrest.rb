PBStuff::POKEMONTOCREST[:SPIDOPS] = :LVCSPIDCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCSPIDCREST] = ItemData.new(:LVCSPIDCREST, {
    name: "Spidops Crest",
    desc: "Spidops sets Sticky Webs on entry, also it deals extra damage when it moves first.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

# Turns out none of the stuff below works... so uh :pleading: Lyra heeeeellllp
# should work now but i cba testing it
class PokeBattle_Battle
    alias spidopscrest_pbCrestEntry pbCrestEntry if !defined?(spidopscrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      spidopscrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      case battler.crested
        when :SPIDOPS
          pbShowAbilityBox(battler, item: true)
          battler.pbUseMoveSimple(:STICKYWEB, -1, -1)
          pbHideAbilityBox(battler)
      end
    end
end

class PokeBattle_Move
    alias spidopscrest_pbCalcDamage pbCalcDamage if !defined?(spidopscrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
    damage = spidopscrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype)
      case attacker.crested
        when :SPIDOPS then damage *= 1.5 if (!opponent.hasMovedThisRound? || @battle.switchedOut[opponent.index])
      end
    return damage.floor
    end
end