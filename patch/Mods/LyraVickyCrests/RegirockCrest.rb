PBStuff::POKEMONTOCREST[:REGIROCK] = :LVCROCKCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCROCKCREST] = ItemData.new(:LVCROCKCREST, {
    name: "Regirock Crest",
    desc: "Regice gains the Ghost typing and its Normal-type moves become Ghost-type. Physical moves use Defense.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Move #ew, but should work without code injection
  alias_method :rockcrest_pbCalcDamage, :pbCalcDamage if !defined?(rockcrest_pbCalcDamage)
  def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
    if attacker.crested == :REGIROCK
        oldatk = attacker.attack.dup
        oldatk_stages = attacker.stages[PBStats::ATTACK].dup
        attacker.attack = attacker.defense
        attacker.stages[PBStats::ATTACK] = attacker.stages[PBStats::DEFENSE]
    end
    damage = rockcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype)  
    if attacker.crested == :REGIROCK
      attacker.attack = oldatk
      attacker.stages[PBStats::ATTACK] = oldatk_stages
    end
    return damage
  end
end

class PokeBattle_Battler
    alias_method :rockcrest_crestStats, :crestStats if !defined?(rockcrest_crestStats)
    def crestStats
      if @crested == :REGIROCK
        @type2 = :GHOST
      end
      rockcrest_crestStats
    end
end

alias :rockcrest_pbCrestMoveTypeChange :pbCrestMoveTypeChange if !defined?(rockcrest_pbCrestMoveTypeChange)
def pbCrestMoveTypeChange(species, form, item, type)
    if species == :REGIROCK && item == :LVCROCKCREST && type == :NORMAL then 
      return :GHOST
    end
    return rockcrest_pbCrestMoveTypeChange(species, form, item, type)
end