#Move
ModCacheInjection.hook(:moves) {
  $cache.moves[:BRAILLEBURST] = MoveData.new(:BRAILLEBURST,{
    :name => "Braille Burst",
    :desc => "Damage is equal to half the damage of the last move used by the target.",
    :function => 0x000, #no special effect
    :type => :QMARKS, #set later
    :category => :physical, #set later
    :basedamage => 5, #set later
    :accuracy => 100,
    :maxpp => 15,
    :target => :SingleNonUser,
    :contact => false,
  })
}
def lvc_useregimove(target,user,battle,move)
    target.effects[:lvc_brailleburstBP] = (move.basedamage/2).round
    battle.pbShowAbilityBox(target, item:true)
    target.pbUseMoveSimple(:BRAILLEBURST, target.index, user.index, danced: true)
    battle.pbHideAbilityBox(target)
    target.effects[:lvc_brailleburstBP] = nil
end
class PokeBattle_Move_000 < PokeBattle_Move #No special effect
  alias_method :regimove_pbOnStartUse, :pbOnStartUse if !method_defined?(:regimove_pbOnStartUse)
  def pbOnStartUse(attacker, targets)
    if @move == :BRAILLEBURST
      moldBrokenArray = [0, 1, 2, 3].map { |index| @battle.battlers[index].moldbroken }
      @category = self.smartDamageCategory(attacker, targets[0], moldBrokenArray: moldBrokenArray)
      return true
    else regimove_pbOnStartUse(attacker,targets)
    end
  end

  # smartdamage category overrule glitch
  alias_method :regimove_pbIsPhysical?, :pbIsPhysical? if !method_defined?(:regimove_pbIsPhysical?)
  def pbIsPhysical?(attacker, type = @type)
    return @category == :physical if @move == :BRAILLEBURST
    return regimove_pbIsPhysical?(attacker, type)
  end

  alias_method :regimove_pbIsSpecial?, :pbIsSpecial? if !method_defined?(:regimove_pbIsSpecial?)
  def pbIsSpecial?(attacker, type = @type)
    return @category == :special  if @move == :BRAILLEBURST
    return regimove_pbIsSpecial?(attacker, type)
  end

  alias_method :regimove_pbShowAnimation, :pbShowAnimation if !method_defined?(:regimove_pbShowAnimation)
  def pbShowAnimation(id,attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    if showanimation
      if @move == :BRAILLEBURST
        case attacker.species
        when :REGICE then @battle.pbAnimation(:ICEBEAM,attacker,opponent,hitnum)
        when :REGIROCK then @battle.pbAnimation(:ROCKBLAST,attacker,opponent,hitnum)
        when :REGISTEEL then @battle.pbAnimation(:MIRRORSHOT,attacker,opponent,hitnum)
        else @battle.pbAnimation(:MIRRORSHOT,attacker,opponent,hitnum)
        end
      else
        regimove_pbShowAnimation(id,attacker,opponent,hitnum,alltargets,showanimation)
      end
    end
  end

  alias_method :regimove_pbEffectTarget, :pbEffectTarget if !method_defined?(:regimove_pbEffectTarget)
  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
    if @move == :BRAILLEBURST
      damage = opponent.lastHPLost
      if damage > 0 && !opponent.damagestate.disguise
        hpgain = (damage * 0.5).round
        attacker.absorbHP(hpgain, opponent, :HPDrainingMove, self)
      end
    else
      regimove_pbEffectTarget(attacker, opponent, hitnum, alltargets)
    end
  end
  alias_method :regimove_pbBaseDamage, :pbBaseDamage if !method_defined?(:regimove_pbBaseDamage)
  def pbBaseDamage(basedmg, attacker, opponent)
    return basedmg =  [5, attacker.effects[:lvc_brailleburstBP] || 0].max if @move == :BRAILLEBURST
    return regimove_pbBaseDamage(basedmg, attacker, opponent)
  end

  alias_method :regimove_pbType, :pbType if !method_defined?(:regimove_pbType)
  def pbType(attacker, type = @type)
    return attacker.type1 if @move == :BRAILLEBURST && (attacker.species == :REGIROCK || attacker.species == :REGICE || attacker.species == :REGISTEEL)
    return regimove_pbType(attacker,type)
  end
end