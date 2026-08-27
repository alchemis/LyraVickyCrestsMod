PBStuff::POKEMONTOCREST[:REGICE] = :LVCRICECREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCRICECREST] = ItemData.new(:LVCRICECREST, {
    name: "Regice Crest",
    desc: "Regice bounces status moves back at the user. Retaliates when hit by a special move.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Battler
  alias_method :icecrest_pbEffectsOnDealingDamage, :pbEffectsOnDealingDamage if !defined?(icecrest_pbEffectsOnDealingDamage)
  def pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent = false)
    if target.crested == :REGICE then
      if move.pbIsSpecial?(user)
        _m = user.lastMoveUsed.dup #temporarily store this just in case
        user.lastMoveUsed = move
        @battle.pbShowAbilityBox(target, item:true)
        target.pbUseMoveSimple(:BRAILLEBURST, target.index, user.index, danced: true)
        @battle.pbHideAbilityBox(target)
        user.lastMoveUsed = _m
      end
    end
    return icecrest_pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent || false)
  end

  alias_method :icecrest_pbSuccessCheck, :pbSuccessCheck if !defined?(icecrest_pbSuccessCheck)
  def pbSuccessCheck(basemove, targets, flags, accuracy = true)
      hitflags = icecrest_pbSuccessCheck(basemove, targets, flags, accuracy)
      return hitflags if targets.difference([self]).none? 
      if basemove.pbIsStatus?
        targets.each_with_index do |target, i|
          next if hitflags[i] != :StatusSuccess
          hitflags[i] = :MagicBouncedCrest if target.crested == :REGICE
        end
      end
      return hitflags
  end

  alias_method :icecrest_moveFailureEffects, :moveFailureEffects if !defined?(moveFailureEffects)
  def moveFailureEffects(user, basemove, target, hitflag)
    # messaging of move failure
    if hitflag == :MagicBouncedCrest
      @battle.pbShowAbilityBox(target,item:true)
      # target for this method should generally be the original user
      target.effects[:MagicBounced] = true
      target.pbChangeStats(PBStats::EVASION, 1, self, nil, abilitycheck: :hide) if @battle.FE == :MIRROR
      target.pbUseMoveSimple(basemove.move, -1, user.index)
      target.effects[:MagicBounced] = false
      @battle.pbHideAbilityBox(target)
      return
    else return icecrest_moveFailureEffects(user, basemove, target, hitflag)
    end
  end

end