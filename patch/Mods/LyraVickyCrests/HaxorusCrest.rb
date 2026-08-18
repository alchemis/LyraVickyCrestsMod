PBStuff::POKEMONTOCREST[:HAXORUS] = :LVCHAXCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCHAXCREST] = ItemData.new(:LVCHAXCREST, {
    name: "Haxorus Crest",
    desc: "Ability becomes Sharpness, also its Defenses and Sp.ATK are boosted by 10% of its ATK.",
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

class PokeBattle_Battler
    alias haxcrest_crestStats crestStats if !defined?(haxcrest_crestStats)
    def crestStats
      haxcrest_crestStats
      case @crested
        when :HAXORUS
            @ability = :SHARPNESS
            # Used to give this on top of what its ability originally was, changed because that was too broken.
            @defense += (@attack * 0.1)
            @spatk += (@attack * 0.1)
            @spdef += (@attack * 0.1)
            #@speed += (@attack * 0.1)
            # removed "all stats gain 10% of its ATK" cuz it's like a +40 to everything 
            #@speed *= 1.1
            # removed "Speed is boosted by 10%" because it was waaaaaaay too broken
      end
    end
end