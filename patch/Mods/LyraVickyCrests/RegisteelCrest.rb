PBStuff::POKEMONTOCREST[:REGISTEEL] = :LVCSTEELCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCSTEELCREST] = ItemData.new(:LVCSTEELCREST, {
    name: "Registeel Crest",
    desc: "Registeel is immune to status moves. Retaliates when hit by a move.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}



class PokeBattle_Battler

  alias_method :steelcrest_pbEffectsOnDealingDamage, :pbEffectsOnDealingDamage if !method_defined?(:steelcrest_pbEffectsOnDealingDamage)
  def pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent = false, futureSight = false)
    if target.crested == :REGISTEEL then
      if (move.pbIsSpecial?(user) || move.pbIsPhysical?(user)) && move.move != :BRAILLEBURST && !attackerNotPresent
        lvc_useregimove(target,user,@battle,move) #defined in regimove.rb
      end
    end
    return steelcrest_pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent, futureSight)
  end

  alias_method :steelcrest_pbSuccessCheck, :pbSuccessCheck if !method_defined?(:steelcrest_pbSuccessCheck)
  def pbSuccessCheck(basemove, targets, flags, accuracy = true)
      hitflags = steelcrest_pbSuccessCheck(basemove, targets, flags, accuracy)
      return hitflags if targets.difference([self]).none? 
      if basemove.pbIsStatus?
        targets.each_with_index do |target, i|
          next if hitflags[i] != :StatusSuccess
          hitflags[i] = :GoodAsGoldCrest if target.crested == :REGISTEEL
        end
      end
      return hitflags
  end

  alias_method :steelcrest_moveFailureEffects, :moveFailureEffects if !method_defined?(:steelcrest_moveFailureEffects)
  def moveFailureEffects(user, basemove, target, hitflag)
    # messaging of move failure
    if hitflag == :GoodAsGoldCrest
        @battle.pbAbilityBoxAndDisplay(target, _INTL("It doesn't affect\n{1}...", target.pbThis(true)), item: true)
        @battle.pbHideAbilityBox(target)
        return
    else return steelcrest_moveFailureEffects(user, basemove, target, hitflag)
    end
  end
end