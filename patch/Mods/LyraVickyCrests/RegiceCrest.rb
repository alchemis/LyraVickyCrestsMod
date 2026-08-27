PBStuff::POKEMONTOCREST[:REGICE] = :LVCRICECREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCRICECREST] = ItemData.new(:LVCRICECREST, {
    name: "Regice Crest",
    desc: "Regice gains the Ghost typing and its Normal-type moves become Ghost-type. Special moves use Sp. Def.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}
# CodeInjector.insert_in_method(:PokeBattle_Move, :pbCalcDamage, "atkstage = attacker.stages[PBStats::DEFENSE] + 6 if attacker.crested == :CLAYDOL && !attackerUseSpDef", "
#   puts 'regice code inject'
#   if attacker.crested == :REGICE
#     atk = attacker.spdef 
#     atkstage = attacker.stages[PBStats::SPDEF] + 6
#   end
# ")

class PokeBattle_Move #ew, but should work without code injection
  alias_method :ricecrest_pbCalcDamage, :pbCalcDamage if !defined?(ricecrest_pbCalcDamage)
  def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
    if attacker.crested == :REGICE && @battle.FE != :GLITCH
        oldspatk = attacker.spatk.dup
        oldspatk_stages = attacker.stages[PBStats::SPATK].dup
        attacker.spatk = attacker.spdef
        attacker.stages[PBStats::SPATK] = attacker.stages[PBStats::SPDEF]
    end
    damage = ricecrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype)  
    if attacker.crested == :REGICE && @battle.FE != :GLITCH
      attacker.spatk = oldspatk
      attacker.stages[PBStats::SPATK] = oldspatk_stages
    end
    return damage
  end
end

class PokeBattle_Battler
    alias_method :ricecrest_crestStats, :crestStats if !defined?(ricecrest_crestStats)
    def crestStats
      if @crested == :REGICE
        @type2 = :GHOST
      end
      ricecrest_crestStats
    end
end

alias :ricecrest_pbCrestMoveTypeChange :pbCrestMoveTypeChange if !defined?(ricecrest_pbCrestMoveTypeChange)
def pbCrestMoveTypeChange(species, form, item, type)
    if species == :REGICE && item == :LVCRICECREST && type == :NORMAL then 
      return :GHOST
    end
    return ricecrest_pbCrestMoveTypeChange(species, form, item, type)
end