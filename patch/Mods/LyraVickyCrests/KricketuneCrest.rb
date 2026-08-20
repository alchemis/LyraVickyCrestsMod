PBStuff::POKEMONTOCREST[:KRICKETUNE] = :LVCKRICKCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCKRICKCREST] = ItemData.new(:LVCKRICKCREST, {
    name: "Kricketune Crest",
    desc: "All of Kricketune's moves are affected by Technician and treated as \"Round\"",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Move_083
  alias krickcrest_pbBaseDamage pbBaseDamage if !defined?(krickcrest_pbBaseDamage)
  def pbBaseDamage(basedmg, attacker, opponent)
    basedmg = krickcrest_pbBaseDamage(basedmg, attacker, opponent)
    for i in 0...@battle.battlers.length
        battler = @battle.battlers[i]
        if battler.crested == :KRICKETUNE then
            @battle.pbMoveAfter(battler)
        end
    end
    return basedmg
  end
end

class PokeBattle_Move
    alias krickcrest_pbCalcDamage pbCalcDamage if !defined?(krickcrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
          if movetype then
            damage = krickcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype) #attacker, opponent, hitnum, feedbackMessages, movetype
          else damage = krickcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages)
          end
          basedmg = @basedamage
          #basedmg = pbBaseDamage(basedmg, attacker, opponent) 
          if attacker.crested == :KRICKETUNE then
              case attacker.ability
                when :TECHNICIAN
                    if basedmg > 60 #only if technician didn't already apply
                      damage *=1.5
                    end
              end

            if @battle.state.effects[:Round] && @function != 0x083 then 
              damage *= 2 
            end #make sure not to double round damage twice
            #doubling base damage is not *exactly* equivalent to doubling total damage, but it is close enough
          end
          return damage
    end

end

class PokeBattle_Battler
  alias krickcrest_pbTryUseMove pbTryUseMove if !defined?(krickcrest_pbTryUseMove)
  def pbTryUseMove(*args)
      ret = krickcrest_pbTryUseMove(*args)
      if self.crested == :KRICKETUNE && ret then
          @battle.state.effects[:Round] = true
      end
      return ret
  end
end