PBStuff::POKEMONTOCREST[:SCREAMTAIL] = :LVCSTCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCSTCREST] = ItemData.new(:LVCSTCREST, {
    name: "Scream Tail Crest",
    desc: "Scream Tail floats in the air until hit, and KOs raise its highest stat. Swaps its offenses and defenses.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    
    alias_method :stcrest_crestStats, :crestStats if !defined?(stcrest_crestStats)
    def crestStats
      
      case @crested
        when :SCREAMTAIL
            @spatk, @spdef = @spdef, @spatk
            @attack, @defense = @defense, @attack
      end
      stcrest_crestStats
    end


    alias_method :stcrest_hasWorkingItem, :hasWorkingItem if !defined?(stcrest_hasWorkingItem)
    def hasWorkingItem(item, ignorefainted: false)
      ignorefainted = false if !defined?(ignorefainted)
      if item == :AIRBALLOON and @crested == :SCREAMTAIL and (!defined?(@stcrest_popped) or !@stcrest_popped) then
          return true 
      else return stcrest_hasWorkingItem(item, ignorefainted: ignorefainted)
      end
    end


    alias_method :stcrest_pbDisposeItem, :pbDisposeItem if !defined?(stcrest_pbDisposeItem)
    def pbDisposeItem(burp: true, symbiosis: true, pickupable: true, duringattack: false)
        burp = true if !defined?(burp)
        symbiosis = true if !defined?(symbiosis)
        pickupable = true if !defined?(pickupable)
        duringattack = false if !defined?(duringattack)
        if @crested == :SCREAMTAIL then
          @stcrest_popped = true
        else
          return stcrest_pbDisposeItem(burp: burp, symbiosis: symbiosis, pickupable: pickupable, duringattack: duringattack)
        end
    end

    alias_method :stcrest_pbOnKillEffects, :pbOnKillEffects if !defined?(stcrest_pbOnKillEffects)
    def pbOnKillEffects(targets, basemove, flags = { totaldamage: 0 })
      ret = stcrest_pbOnKillEffects(targets,basemove,flags)
      if @crested == :SCREAMTAIL then
        stat = self.getHighestRawStat
        statmod = @battle.FE == :DIMENSIONAL ? 2 : 1
        if pbCanIncreaseStatStage?(stat, self, nil)
          @battle.pbShowAbilityBox(self, attrname: getAbilityName(:BEASTBOOST))
          increment = targets.length * statmod
          self.pbChangeStats(stat, increment, self, nil, abilitycheck: :skip)
          @battle.pbHideAbilityBox(self)
        end
      end
      return ret
    end
end
