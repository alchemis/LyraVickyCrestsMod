
PBStuff::POKEMONTOCREST[:ARCHEOPS] = :LVCARCHCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCARCHCREST] = ItemData.new(:LVCARCHCREST, {
    name: "Archeops Crest",
    desc: "If at full HP, Archeops endures at 25% HP, also it retreats when its HP drops to half or less and regenerates.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}



#cant take more than half its hp if at full
class PokeBattle_Move
    alias_method :archcrest_pbCalcDamage, :pbCalcDamage if !method_defined?(:archcrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
      if movetype then
        damage = archcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype) #attacker, opponent, hitnum, feedbackMessages, movetype
      else damage = archcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages)
      end
      if opponent.crested == :ARCHEOPS and opponent.hp == opponent.totalhp and damage >= ((opponent.totalhp/4)*3)
        opponent.effects[:LVC_TANKEDHIT] = true
        damage = [damage, ((opponent.totalhp/4.to_f)*3).ceil].min()

      end
      return damage.round
      
    end
end


class PokeBattle_Battler
  #regen
  alias_method :archcrest_pbInitialize, :pbInitialize if !method_defined?(:archcrest_pbInitialize)
  def pbInitialize(pkmn, index, batonpass)
    ret = archcrest_pbInitialize(pkmn, index, batonpass)
    if self.crested == :ARCHEOPS && @pokemon && @hp > 0 && self.status != :PETRIFIED
      self.pbRecoverHP((self.totalhp / 3.0).round, false, false) # Healing isn't shown on HP bar before switching
    end
    return ret
  end
  #e. exit
  alias_method :archcrest_pbEmergencyExitCheck, :pbEmergencyExitCheck if !method_defined?(:archcrest_pbEmergencyExitCheck)
  def pbEmergencyExitCheck(oldhp)
    if self.crested == :ARCHEOPS then
    return unless oldhp > (@totalhp / 2.0).round && self.hp <= (@totalhp / 2.0).round && self.hp != 0

    if @battle.FE == :COLOSSEUM
        @battle.pbAbilityBoxAndDisplay(self, _INTL("{1} has nowhere to run!", self.pbThis), item: true)
    else
      if @battle.pbIsWild? and @battle.pbIsOpposing?(self.index)
        # when a boss is initialized cantescape is getting set on the battle, so wild bosses will never be fleed from unless the boss's settings explicitly allow it
        unless @battle.cantescape || $game_switches[:Never_Escape]
          @battle.pbShowAbilityBox(self, item:true)
          pbSEPlay("escape", 100)
          @battle.pbDisplayPaused(_INTL("{1} fled!", self.pbThis))
          @battle.pbHideAbilityBox(self)
          @battle.decision = 3 # Set decision to escaped
        end
      else
        if self.canTriggerUserSwitch?
          message = _INTL("{1} slinks away in defeat!", self.pbThis)
          @battle.pbAbilityBoxAndDisplay(self, message, item: true)
          self.userSwitch = :Ability
        end
      end
    end
    else return archcrest_pbEmergencyExitCheck(oldhp)    
    end 
  end
  #just for abilitybox
  alias_method :archcrest_pbEffectsOnDealingDamage, :pbEffectsOnDealingDamage if !method_defined?(:archcrest_pbEffectsOnDealingDamage)
  def pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent = false)
    if target.effects[:LVC_TANKEDHIT] && target.crested == :ARCHEOPS
      @battle.pbAbilityBoxAndDisplay(target, _INTL("{1} tanked the hit!", target.pbThis), item: true)
      target.effects[:LVC_TANKEDHIT] = false
      @battle.pbHideAbilityBox(target)
    end
    return archcrest_pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent || false)
  end
end