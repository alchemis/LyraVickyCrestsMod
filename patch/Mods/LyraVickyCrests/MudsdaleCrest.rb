PBStuff::POKEMONTOCREST[:MUDSDALE] = :LVCMUDSCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCMUDSCREST] = ItemData.new(:LVCMUDSCREST, {
    name: "Mudsdale Crest",
    desc: "Nullifies damage and boosts Attack when hit by a Grass-type move. Increase Sp.DEF by 20%.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias mudscrest_crestStats crestStats
    def crestStats
      mudscrest_crestStats
      case @crested
        when :MUDSDALE
            @spdef *= 1.2
      end
    end
end

class PokeBattle_Move
  alias mudscrest_pbTypeImmunities pbTypeImmunities
  def pbTypeImmunities(attacker, targets, hitflags, movetype: nil)
    ret = movetype ? mudscrest_pbTypeImmunities(attacker, targets, hitflags, movetype: nil) : mudscrest_pbTypeImmunities(attacker, targets, hitflags)
    targets.each_with_index do |opponent, i|
      next if hitflags[i] != :Success
      next unless pbShouldApplyTypeImmunity?(attacker, opponent)
      if types.include?(:GRASS)
        hitflags[i] = :SapSipperItem if opponent.crested == :MUDSDALE
      end
    end
    return ret
  end
end