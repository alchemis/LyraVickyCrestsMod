
PBStuff::POKEMONTOCREST[:CARRACOSTA] = :LVCCARRACREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCCARRACREST] = ItemData.new(:LVCCARRACREST, {
    name: "Carracosta Crest",
    desc: "If at full HP Carracosta will endure moves at 50% HP, also sharply increases its Defenses when its HP drops to half or less.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}



#cant take more than half its hp if at full
class PokeBattle_Move
    alias carracrest_pbCalcDamage pbCalcDamage if !defined?(carracrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
      damage = carracrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype)
      if opponent.crested == :CARRACOSTA and opponent.hp == opponent.totalhp and damage >= (opponent.totalhp/2)
        opponent.effects[:LVC_TANKEDHIT] = true
        damage = [damage, (opponent.totalhp/2.to_f).ceil].min()

      end
      return damage
      
    end
end


class PokeBattle_Battler

  #sharply raise defenses
  alias carracrest_pbEmergencyExitCheck pbEmergencyExitCheck if !defined?(carracrest_pbEmergencyExitCheck)
  def pbEmergencyExitCheck(oldhp)
    if self.crested == :CARRACOSTA then
    return unless oldhp > (@totalhp / 2.0).floor && self.hp <= (@totalhp / 2.0).floor && self.hp != 0

    if self.pbCanIncreaseAnyStat?([PBStats::DEFENSE, PBStats::SPDEF], self, nil, showMessage: false)
      @battle.pbShowAbilityBox(self, item: true)
      @battle.pbDisplay(_INTL("{1} bunkers down!", self.pbThis))
      self.pbChangeStats([PBStats::DEFENSE, PBStats::SPDEF], 2, self, nil, abilitycheck: :skip)
      @battle.pbHideAbilityBox(self)
    end
    else return carracrest_pbEmergencyExitCheck(oldhp)    
    end 
  end

  #just for abilitybox
  alias carracrest_pbEffectsOnDealingDamage pbEffectsOnDealingDamage if !defined?(carracrest_pbEffectsOnDealingDamage)
  def pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent = false)
    if target.effects[:LVC_TANKEDHIT] && target.crested == :CARRACOSTA
      @battle.pbAbilityBoxAndDisplay(target, _INTL("{1} tanked the hit!", target.pbThis), item: true)
      target.effects[:LVC_TANKEDHIT] = false
      @battle.pbHideAbilityBox(target)
    end
    return carracrest_pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent || false)
  end
end