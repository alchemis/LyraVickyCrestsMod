PBStuff::POKEMONTOCREST[:JIRACHI] = :LVCRACHICREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCRACHICREST] = ItemData.new(:LVCRACHICREST, {
    name: "Jirachi Crest",
    desc: "Jirachi uses Doom Desire on entry and whenever it hits an opponent.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}



class PokeBattle_Move_111 #f sight, doomdesire
  alias_method :rachicrest_pbEffectTarget, :pbEffectTarget if !method_defined?(:rachicrest_pbEffectTarget)
  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
      ret = rachicrest_pbEffectTarget(attacker, opponent, hitnum, alltargets)
      opponent.effects[:RACHICREST_DOOMDESIRE_FLAG] = attacker.pokemon if @move == :DOOMDESIRE && attacker.crested == :JIRACHI
      return ret
  end
end
class PokeBattle_Battle
  alias_method :rachicrest_pbCrestEntry, :pbCrestEntry if !method_defined?(:rachicrest_pbCrestEntry)
  def pbCrestEntry(index, pokemon)
    rachicrest_pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    case battler.crested
      when :JIRACHI
        pbShowAbilityBox(battler, item: true)
        target = @battle.doublebattle ? battler.index ^ 3 : -1
        battler.pbUseMoveSimple(:DOOMDESIRE, -1, target) #Use on directly opposing opponent, so there's no RNG in targetting
        pbHideAbilityBox(battler)
    end
  end
  alias_method :rachicrest_pbLifeBlood, :pbLifeBlood if !method_defined?(:rachicrest_pbLifeBlood)
  def pbLifeBlood #only thing i can hook onto that is in the correct spot
    eachBattler do |i| # not speed order
      next if i.effects[:FutureSight] != 0
      next if !defined?(!i.effects[:RACHICREST_DOOMDESIRE_FLAG]) || !i.effects[:RACHICREST_DOOMDESIRE_FLAG]
      next if i.isFainted?
      movemon = i.effects[:RACHICREST_DOOMDESIRE_FLAG]
      for battler in @battle.battlers
        moveuser = battler if battler.pokemon == movemon && !battler.isFainted?
      end
      next if moveuser.nil?
      i.effects[:RACHICREST_DOOMDESIRE_FLAG] = nil
      pbShowAbilityBox(moveuser, item: true)
      moveuser.pbUseMoveSimple(:DOOMDESIRE,-1,i.index)
      pbHideAbilityBox(moveuser)
    end
    rachicrest_pbLifeBlood
  end
  
end