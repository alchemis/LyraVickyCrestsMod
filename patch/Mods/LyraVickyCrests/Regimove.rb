#Move
ModCacheInjection.hook(:moves) {
  $cache.moves[:BRAILLEBURST] = MoveData.new(:BRAILLEBURST,{
    :name => "Braille Burst",
    :desc => "Damage is equal to half the damage of the last move used by the target.",
    :function => 0x000, #no special effect
    :type => :QMARKS, #set later
    :category => :physical, #set later
    :basedamage => 1, #set later
    :accuracy => 100,
    :maxpp => 15,
    :target => :SingleNonUser,
    :contact => false,
  })
}

class PokeBattle_Move_000 < PokeBattle_Move #No special effect
  alias_method :bb_pbOnStartUse, :pbOnStartUse if !defined?(bb_pbOnStartUse)
  def pbOnStartUse(attacker, targets)
    if @move == :BRAILLEBURST
      moldBrokenArray = [0, 1, 2, 3].map { |index| @battle.battlers[index].moldbroken }
      @category = self.smartDamageCategory(attacker, targets[0], moldBrokenArray: moldBrokenArray)
      return true
    else return bb_pbOnStartUse(attacker,targets)
    end
  end

  # smartdamage category overrule glitch
  def pbIsPhysical?(attacker, type = @type)
    return @category == :physical
  end

  def pbIsSpecial?(attacker, type = @type)
    return @category == :special
  end

  def pbShowAnimation(id,attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    if showanimation
      if @move == :BRAILLEBURST
        case attacker.species
        when :REGICE then @battle.pbAnimation(:ICEBEAM,attacker,opponent,hitnum)
        when :REGIROCK then @battle.pbAnimation(:ROCKBLAST,attacker,opponent,hitnum)
        when :REGISTEEL then @battle.pbAnimation(:MIRRORBEAM,attacker,opponent,hitnum)
        else @battle.pbAnimation(:MIRRORBEAM,attacker,opponent,hitnum)
        end
      else
        @battle.pbAnimation(id,attacker,opponent,hitnum)
      end
    end
  end
  
  alias_method :rockcrest_pbEffectTarget, :pbEffectTarget if !defined?(rockcrest_pbEffectTarget)
  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
    if @move == :BRAILLEBURST
      damage = opponent.lastHPLost
      if damage > 0 && !opponent.damagestate.disguise
        hpgain = (damage * 0.5).round
        attacker.absorbHP(hpgain, opponent, :HPDrainingMove, self)
      end
    end
  end
  def pbBaseDamage(basedmg, attacker, opponent)
    return basedmg = (opponent.lastMoveUsed.basedamage/2.0).floor if @move == :BRAILLEBURST
    return basedmg
  end

  alias_method :bb_pbType, :pbType if !defined?(bb_pbType)
  def pbType(attacker, type = @type)
    return attacker.type1 if @move == :BRAILLEBURST && (attacker.species == :REGIROCK || attacker.species == :REGICE || attacker.species == :REGISTEEL)
    return bb_pbType(attacker, type = @type)
  end
end