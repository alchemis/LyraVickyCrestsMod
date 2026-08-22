PBStuff::POKEMONTOCREST[:HAXORUS] = :LVCHAXCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCHAXCREST] = ItemData.new(:LVCHAXCREST, {
    name: "Haxorus Crest",
    desc: "Haxorus gains STAB with Slicing moves, also its Defenses are boosted by 20%.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

#class PokeBattle_Move
    #alias haxcrest_pbCalcDamage pbCalcDamage if !defined?(haxcrest_pbCalcDamage)
    #def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
          #if movetype then
            #damage = haxcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype) #attacker, opponent, hitnum, feedbackMessages, movetype
          #else damage = haxcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages)
          #end
          #if attacker.crested == :HAXORUS && $cache.moves[@move]&.checkFlag?(:sharpmove)
            #damage *= 1.5
          #end

          #return damage
    #end

#end
# Used to provide a Sharpness bonus not tied to an ability, removed due to being broken.

#Sharpness Stab
class PokeBattle_Move
  alias haxcrest_pbModifySTAB pbModifySTAB if !defined?(haxcrest_pbModifySTAB)
  def pbModifySTAB(stabmult, type, attacker, opponent)
    if attacker.crested == :HAXORUS && self.sharpMove? then
        stabmult += 0.5 if stabmult <= 1
    end
    return haxcrest_pbModifySTAB(stabmult, type, attacker, opponent)
  end
end

class PokeBattle_Battler
    alias haxcrest_crestStats crestStats if !defined?(haxcrest_crestStats)
    def crestStats
      
      case @crested
        when :HAXORUS
            # @ability = :SHARPNESS
            @defense *= 1.2
            #@spatk += (@attack * 0.1)
            @spdef *= 1.2
            #@speed += (@attack * 0.1)
            #@speed *= 1.1
      end
      haxcrest_crestStats
    end
end