PBStuff::POKEMONTOCREST[:LURANTIS] = :LVCLURACREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCLURACREST] = ItemData.new(:LVCLURACREST, {
    name: "Lurantis Crest",
    desc: "When Lurantis uses a damaging move, lowers its corresponding attacking stat and sharply raises the other.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


#ECHO
class PokeBattle_Battler
  alias_method :luracrest_applyPostMoveEffects, :applyPostMoveEffects if !method_defined?(:luracrest_applyPostMoveEffects)
  
  def applyPostMoveEffects(basemove, user, targets, hitflag)
    ret = luracrest_applyPostMoveEffects(basemove, user, targets, hitflag)
    if [:Success].intersect?(hitflag) && basemove.pbIsDamaging? && user.crested == :LURANTIS
      stat_lower = basemove.pbIsPhysical?(user) ? PBStats::ATTACK : PBStats::SPATK
      stat_raise = basemove.pbIsPhysical?(user) ? PBStats::SPATK : PBStats::ATTACK
      if (user.pbCanIncreaseStatStage?(stat_raise, user, user, showMessage: false) || user.pbCanReduceStatStage?(stat_lower, user, user, showMessage: false))
        @battle.pbShowAbilityBox(user, item: true)
        user.pbChangeStats(stat_raise, 2, user, user, abilitycheck: :skip)
        user.pbChangeStats(stat_lower, -1, user, user, abilitycheck: :skip)
        @battle.pbHideAbilityBox(user)
      end
    end
    return ret
  end

end

