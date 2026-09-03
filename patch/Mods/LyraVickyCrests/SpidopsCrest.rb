PBStuff::POKEMONTOCREST[:SPIDOPS] = :LVCSPIDCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCSPIDCREST] = ItemData.new(:LVCSPIDCREST, {
    name: "Spidops Crest",
    desc: "Spidops sets Sticky Webs on entry and its moves do double damage when moving first.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

# Turns out none of the stuff below works... so uh :pleading: Lyra heeeeellllp
# should work now but i cba testing it
class PokeBattle_Battle
    alias_method :spidopscrest_pbCrestEntry, :pbCrestEntry if !method_defined?(:spidopscrest_pbCrestEntry)
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
    alias_method :spidopscrest_pbCalcDamage, :pbCalcDamage if !method_defined?(:spidopscrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
    damage = spidopscrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype)
      case attacker.crested
        when :SPIDOPS then damage *= 2 if (!opponent.hasMovedThisRound? || @battle.switchedOut[opponent.index])
      end
    return damage.round
    end
end