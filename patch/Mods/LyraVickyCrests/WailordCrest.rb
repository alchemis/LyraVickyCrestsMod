PBStuff::POKEMONTOCREST[:WAILORD] = :LVCWAILCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCWAILCREST] = ItemData.new(:LVCWAILCREST, {
    name: "Wailord Crest",
    desc: "Wailord's Defenses are increased depending on its current HP.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias_method :wailcrest_crestStats, :crestStats if !method_defined?(:wailcrest_crestStats)
    def crestStats
      
      case @crested
        when :WAILORD
            @defense = @defense + @hp * 0.5
            @spdef = @spdef + @hp * 0.5
      end
      wailcrest_crestStats
    end

    alias_method :wailcrest_pbRecoverHP, :pbRecoverHP if !method_defined?(:wailcrest_pbRecoverHP)
    def pbRecoverHP(amt, anim = false, hpbaranim = true, message: nil, hpamt: amt)
      anim = anim
      hpbaranim = hpbaranim
      message = nil if !defined?(message)
      ret = wailcrest_pbRecoverHP(amt, anim, hpbaranim, message: message, hpamt: amt)
      if @crested and @species == :WAILORD then
        self.pbUpdate() 
      end
      return ret
    end

    alias_method :wailcrest_pbReduceHP, :pbReduceHP if !method_defined?(:wailcrest_pbReduceHP)
    def pbReduceHP(amt, anim = false, emercheck = true, message: nil)
        message = nil if !defined?(message)
        ret = wailcrest_pbReduceHP(amt, anim, emercheck, message: message)
        if @crested and @species == :WAILORD then
          self.pbUpdate() 
        end
        return ret
    end

    alias_method :wailcrest_pbEffectsOnDealingDamage, :pbEffectsOnDealingDamage if !method_defined?(:wailcrest_pbEffectsOnDealingDamage)
    def pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent = false, futureSight = false)
      
      if target.crested and target.species == :WAILORD then
        target.pbUpdate() 
      end
      return wailcrest_pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent, futureSight)
    end
end

