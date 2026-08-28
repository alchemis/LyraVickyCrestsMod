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
  def pbOnStartUse(attacker, targets)
    if @move == :BRAILLEBURST
      moldBrokenArray = [0, 1, 2, 3].map { |index| @battle.battlers[index].moldbroken }
      @category = self.smartDamageCategory(attacker, targets[0], moldBrokenArray: moldBrokenArray)
      return true
    else super(attacker,targets)
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
        when :REGISTEEL then @battle.pbAnimation(:MIRRORSHOT,attacker,opponent,hitnum)
        else @battle.pbAnimation(:MIRRORSHOT,attacker,opponent,hitnum)
        end
      else
        @battle.pbAnimation(id,attacker,opponent,hitnum)
      end
    end
  end

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
    return basedmg =  [5, attacker.effects[:lvc_brailleburstBP] || 0].max if @move == :BRAILLEBURST
    return basedmg
  end

  def pbType(attacker, type = @type)
    return attacker.type1 if @move == :BRAILLEBURST && (attacker.species == :REGIROCK || attacker.species == :REGICE || attacker.species == :REGISTEEL)
    return super(attacker)
  end
end