PBStuff::POKEMONTOCREST[:KRICKETUNE] = :LVCKRICKCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCKRICKCREST] = ItemData.new(:LVCKRICKCREST, {
    name: "Kricketune Crest",
    desc: "All of its moves are affected by Technician and count as \"Round\"",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Move_083
  alias krickcrest_pbBaseDamage pbBaseDamage
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
    alias krickcrest_pbCalcDamage pbCalcDamage
    def pbCalcDamage(*args)
          damage = krickcrest_pbCalcDamage(*args) #attacker, opponent, hitnum, feedbackMessages, movetype
          basedmg = @basedamage
          basedmg = pbBaseDamage(basedmg, args[0], args[1]) 
          if args[0].crested == :KRICKETUNE then
              case args[0].ability
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

    alias krickcrest_basedmgmulti pbBaseDamageMultiplier
end

class PokeBattle_Battler
  alias krickcrest_pbUseMove pbUseMove
  def pbUseMove(*args)
      ret = krickcrest_pbUseMove(*args)
      if self.crested == :KRICKETUNE then
          @battle.state.effects[:Round] = true
      end
      return ret
  end
end