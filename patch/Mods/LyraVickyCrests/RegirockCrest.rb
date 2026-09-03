PBStuff::POKEMONTOCREST[:REGIROCK] = :LVCROCKCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCROCKCREST] = ItemData.new(:LVCROCKCREST, {
    name: "Regirock Crest",
    desc: "Resists Ghost and cannot be statused. Retailiates when hit by a physical move.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Battler
  alias_method :rockcrest_pbCanStatus?, :pbCanStatus? if !method_defined?(:rockcrest_pbCanStatus?)
  def pbCanStatus?(attacker, move, ignorestatus: false, showMessage: false)
    can_status = rockcrest_pbCanStatus?(attacker, move, ignorestatus: ignorestatus, showMessage: showMessage)
    if self.crested == :REGIROCK && can_status && move.move != :REST
      if showMessage
        @battle.pbShowAbilityBox(self, item: true)
        @battle.pbDisplay(_INTL("It doesn't affect\n{1}...", self.pbThis))
        @battle.pbHideAbilityBox(self)
      end
      can_status = false
    end
    return can_status
  end



  alias_method :rockcrest_pbEffectsOnDealingDamage, :pbEffectsOnDealingDamage if !method_defined?(:rockcrest_pbEffectsOnDealingDamage)
  def pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent = false)
    if target.crested == :REGIROCK then
      if move.pbIsPhysical?(user) && move.move != :BRAILLEBURST && !attackerNotPresent
        lvc_useregimove(target,user,@battle,move) #defined in regimove.rb
      end
    end
    return rockcrest_pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent || false)
  end
end

class PokeBattle_Move
  alias_method :rockcrest_irregularTypeMods, :irregularTypeMods if !method_defined?(:rockcrest_irregularTypeMods)
  def irregularTypeMods(attacker, opponent, typemod, type)
    typemod = rockcrest_irregularTypeMods(attacker, opponent, typemod, type)
    case opponent.crested
      when :REGIROCK
        typemod *= Typemod.half if [:GHOST].include?(type)
    end
    return typemod
  end
end

