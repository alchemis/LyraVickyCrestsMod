#HiddenMoveHandlers::hasHandler(move)
#
PBStuff::POKEMONTOCREST[:BIBAREL] = :LVCBIBACREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCBIBACREST] = ItemData.new(:LVCBIBACREST, {
    name: "Bibarel Crest",
    desc: "Bibarel's Field moves are powered up, also its stats cannot be lowered",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}




class PokeBattle_Move
    alias bibacrest_pbCalcDamage pbCalcDamage if !defined?(bibacrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
      if movetype then
        damage = bibacrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype) #attacker, opponent, hitnum, feedbackMessages, movetype
      else damage = bibacrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages)
      end
      if attacker.crested == :BIBAREL && HiddenMoveHandlers::hasHandler(@move) then 
        damage *= 1.5 
      end
      return damage
      
    end

end

class PokeBattle_Battler
  alias bibacrest_pbCanReduceAnyStat? pbCanReduceAnyStat? if !defined?(bibacrest_pbCanReduceAnyStat?)
  def pbCanReduceAnyStat?(stats, statinducer, move, showMessage: false, ignoreContrary: false)
    if self.crested == :BIBAREL && statinducer != self then
      @battle.pbAbilityBoxAndDisplay(self, _INTL("{1}'s stats were not lowered!", pbThis),item: true) if showMessage
      return false
    end
    return bibacrest_pbCanReduceAnyStat?(stats, statinducer, move, showMessage: showMessage, ignoreContrary: ignoreContrary)
  end
end