PBStuff::POKEMONTOCREST[:REGISTEEL] = :LVCSTEELCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCSTEELCREST] = ItemData.new(:LVCSTEELCREST, {
    name: "Registeel Crest",
    desc: "Registeel is immune to status moves. Attacking moves use the respective defensive stat.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}



class PokeBattle_Battler

  alias_method :steelcrest_pbSuccessCheck, :pbSuccessCheck if !defined?(steelcrest_pbSuccessCheck)
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

  alias_method :steelcrest_moveFailureEffects, :moveFailureEffects if !defined?(moveFailureEffects)
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