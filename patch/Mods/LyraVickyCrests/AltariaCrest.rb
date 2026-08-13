PBStuff::POKEMONTOCREST[:ALTARIA] = :LVCALTACREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCALTACREST] = ItemData.new(:LVCALTACREST, {
    name: "Altaria Crest",
    desc: "Altaria echoes any Sound-based move used, and gains STAB on any sound moves.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

#Stab on sound moves
class PokeBattle_Move
  alias altacrest_pbModifySTAB pbModifySTAB if !defined?(altacrest_pbModifySTAB)
  def pbModifySTAB(stabmult, type, attacker, opponent)
    if attacker.crested == :ALTARIA && self.isSoundBased? then
        stabmult += 0.5 if stabmult <= 1
    end
    return altacrest_pbModifySTAB(stabmult, type, attacker, opponent)
  end
end

#ECHO
class PokeBattle_Battler
  alias altacrest_pbDancerMoveCheck pbDancerMoveCheck if !defined?(altacrest_pbDancerMoveCheck)
  
  def pbDancerMoveCheck(id)
    priority = @battle.setSpeedOrder
    for i in priority
      if i.crested == :ALTARIA && $cache.moves[id]&.checkFlag?(:soundmove) && !i.effects[:ALTACREST_ECHO] && !$cache.moves[id].zmovedata #exclude zmoves cus of clangorous soulblaze
        i.effects[:ALTACREST_ECHO] = true
        @battle.pbShowAbilityBox(i, item: true)
        @battle.pbDisplay(_INTL("{1} echoed the song!", i.pbThis))
        i.pbUseMoveSimple(id, -1, -1, danced: true)
        @battle.pbHideAbilityBox(i)
      end
    end
    return altacrest_pbDancerMoveCheck(id)
  end

end

#reset at turn end
class PokeBattle_Battle
  alias altacrest_pbEndOfRoundPhase pbEndOfRoundPhase if !defined?(altacrest_pbEndOfRoundPhase)
  def pbEndOfRoundPhase(skipcelebi = false)
      priority = setSpeedOrder
      for battler in priority
        battler.effects[:ALTACREST_ECHO] = false if battler.effects[:ALTACREST_ECHO]
      end
      altacrest_pbEndOfRoundPhase(skipcelebi)
  end
end